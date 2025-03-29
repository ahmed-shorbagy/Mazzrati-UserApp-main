import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sixvalley_ecommerce/features/payment/presentation/cubit/paymob_manager.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());
  static PaymentCubit get(context) => BlocProvider.of(context);

  // Function to get user data from shared preferences
  Future<Map<String, dynamic>?> getUserData() async {
    emit(GetUserDataLoadingState());

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(AppConstants.user);

      if (userData != null) {
        final user = jsonDecode(userData);
        emit(GetUserDataSuccessState());
        return user;
      } else {
        emit(const GetUserDataFailureState(error: "User data not found"));
        return null;
      }
    } catch (e) {
      emit(GetUserDataFailureState(error: "Failed to retrieve user data: $e"));
      return null;
    }
  }

  // Main function to create payment with PayMob
  Future<String> payWithPaymob(double amount) async {
    emit(PayWithPayMobLoading());
    try {
      // Get user data for the payment process
      final userData = await getUserData();
      if (userData == null) {
        throw Exception("Cannot get user data");
      }

      // Extract user information safely
      final String firstName = userData['name']?.toString() ?? "User";
      final String lastName = userData['surname']?.toString() ?? "";
      final String email =
          userData['email']?.toString() ?? "customer@example.com";
      final String phone = userData['phone']?.toString() ?? "00000000000";

      // Create billing data
      final billingData = PaymobManager.createBillingData(
          firstName: firstName, lastName: lastName, email: email, phone: phone);

      // Step 1: Get auth token
      String token = await PaymobManager.getAuthToken();

      // Step 2: Create order on PayMob
      int orderId = await PaymobManager.createOrder(
          token: token, amount: (100 * amount).toString());

      // Step 3: Get payment key
      String paymentKey = await PaymobManager.getPaymentKey(
        token: token,
        orderId: orderId.toString(),
        amount: (100 * amount).toString(),
        billingData: billingData,
      );

      emit(PayWithPayMobSuccess());
      return paymentKey;
    } catch (e) {
      log("Payment error: ${e.toString()}");
      emit(PayWithPayMobFailure(error: e.toString()));
      rethrow;
    }
  }

  // Record a transaction in the system after successful payment
  Future<void> createTransaction({
    required double amount,
    required int orderId,
    required int sellerId,
    required int customerId,
    required String description,
  }) async {
    emit(CreateTransactionLoading());

    try {
      // Get stored token
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(AppConstants.userLoginToken);

      if (token == null) {
        throw Exception("Authentication token not found");
      }

      // Construct API endpoint for transaction recording
      String url = '${AppConstants.baseUrl}/api/v1/customer/transaction/create';

      Map<String, String> headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };

      Map<String, dynamic> body = {
        "amount": amount,
        "type": "credit",
        "description": description,
        "seller_id": sellerId,
        "customer_id": customerId,
        "order_id": orderId,
        "status": "completed",
      };

      var response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(body));

      Map<String, dynamic> data = json.decode(response.body);

      if (data['status'] == "success") {
        emit(CreateTransactionSuccess());
      } else {
        emit(CreateTransactionFailure(
            error: data['message'] ?? "Failed to record transaction"));
      }
    } catch (e) {
      log('Transaction error: ${e.toString()}');
      emit(CreateTransactionFailure(error: e.toString()));
    }
  }
}
