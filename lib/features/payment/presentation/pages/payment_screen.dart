import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/screens/home_screens.dart';
import 'package:flutter_sixvalley_ecommerce/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaymentScreen extends StatefulWidget {
  final String token;
  final double amount;
  final int orderId;
  final int sellerId;
  final String productName;

  const PaymentScreen({
    super.key,
    required this.token,
    required this.amount,
    required this.orderId,
    required this.sellerId,
    required this.productName,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with WidgetsBindingObserver {
  InAppWebViewController? _webViewController;
  final String baseUrl = "https://ksa.paymob.com/api/acceptance/iframes/6357";
  bool isLoading = true;
  bool isPaymentProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isPaymentProcessing) {
          Fluttertoast.showToast(
            msg: "Please wait until the process is complete",
            backgroundColor: Colors.orange,
          );
          return false;
        }
        if (_webViewController != null) {
          if (await _webViewController!.canGoBack()) {
            await _webViewController!.goBack();
            return false;
          }
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              if (isPaymentProcessing) {
                Fluttertoast.showToast(
                  msg: "Please wait until the process is complete",
                  backgroundColor: Colors.orange,
                );
                return;
              }
              Fluttertoast.showToast(
                msg: "Payment cancelled",
                backgroundColor: Colors.orange,
              );
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri("$baseUrl?payment_token=${widget.token}"),
              ),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  javaScriptEnabled: true,
                  useShouldOverrideUrlLoading: true,
                  mediaPlaybackRequiresUserGesture: false,
                  useOnLoadResource: true,
                ),
              ),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onLoadStart: (controller, url) {
                setState(() => isLoading = true);
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final uri = navigationAction.request.url;
                if (uri == null) return NavigationActionPolicy.CANCEL;

                log('URL Loading: ${uri.toString()}');

                if (uri.toString().contains('api/acceptance/post_pay')) {
                  final params = uri.queryParameters;
                  setState(() => isPaymentProcessing = true);

                  if (params['success'] == 'true') {
                    // Wait for PayMob to show success screen
                    Future.delayed(const Duration(seconds: 3), () async {
                      if (mounted) {
                        await _handlePaymentSuccess(context);
                      }
                    });
                    return NavigationActionPolicy.ALLOW;
                  }

                  if (params['success'] == 'false' ||
                      params['error_occured'] == 'true') {
                    setState(() => isPaymentProcessing = false);
                    String errorMessage = params['data.message'] ??
                        params['message'] ??
                        "An error occurred during payment. Please try again later.";
                    await _handlePaymentFailure(context, errorMessage);
                    return NavigationActionPolicy.CANCEL;
                  }
                }

                return NavigationActionPolicy.ALLOW;
              },
              onLoadStop: (controller, url) async {
                setState(() => isLoading = false);

                if (url != null &&
                    url.toString().contains('success=true') &&
                    isPaymentProcessing) {
                  // Wait for PayMob's success screen
                  await Future.delayed(const Duration(seconds: 5));
                  if (mounted) {
                    await _handlePaymentSuccess(context);
                  }
                }
              },
              onLoadError: (controller, url, code, message) {
                setState(() {
                  isLoading = false;
                  isPaymentProcessing = false;
                });
                _handlePaymentError(context, message);
              },
            ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePaymentSuccess(BuildContext context) async {
    try {
      if (!isPaymentProcessing) return; // Prevent duplicate handling

      // Record transaction
      await context.read<PaymentCubit>().createTransaction(
            amount: widget.amount,
            orderId: widget.orderId,
            sellerId: widget.sellerId,
            customerId:
                -1, // Will be replaced with actual customer ID from shared prefs
            description: "Payment for: ${widget.productName}",
          );

      Fluttertoast.showToast(
        msg: "Payment successful",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
      );

      setState(() => isPaymentProcessing = false);

      // Navigate back to the proper screen
      if (mounted) {
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      setState(() => isPaymentProcessing = false);
      log('Payment success handling error: $e');
      _handlePaymentError(context, e.toString());
    }
  }

  Future<void> _handlePaymentFailure(
      BuildContext context, String errorMessage) async {
    Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
    );

    setState(() => isPaymentProcessing = false);

    if (mounted) {
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.of(context).pop();
    }
  }

  void _handlePaymentError(BuildContext context, String message) {
    log('Payment error: $message');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $message')),
    );
  }
}
