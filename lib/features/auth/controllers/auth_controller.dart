import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_snackbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/domain/models/login_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/domain/models/register_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/error_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/domain/models/social_login_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/domain/services/auth_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/screens/auth_screen.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:provider/provider.dart';

class AuthController with ChangeNotifier {
  final AuthServiceInterface authServiceInterface;
  AuthController({required this.authServiceInterface});

  bool _isLoading = false;
  bool? _isRemember = false;
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  bool _isAcceptTerms = false;
  bool get isAcceptTerms => _isAcceptTerms;

  String countryDialCode = '+880';
  void setCountryCode(String countryCode, {bool notify = true}) {
    countryDialCode = countryCode;
    if (notify) {
      notifyListeners();
    }
  }

  updateSelectedIndex(int index, {bool notify = true}) {
    _selectedIndex = index;
    if (notify) {
      notifyListeners();
    }
  }

  bool get isLoading => _isLoading;
  bool? get isRemember => _isRemember;

  void updateRemember() {
    _isRemember = !_isRemember!;
    notifyListeners();
  }

  Future<void> socialLogin(
      SocialLoginModel socialLogin, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await authServiceInterface.socialLogin(socialLogin.toJson());
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      _isLoading = false;
      Map map = apiResponse.response!.data;
      String? message = '', token = '', temporaryToken = '';
      try {
        message = map['error_message'];
        token = map['token'];
        temporaryToken = map['temporary_token'];
      } catch (e) {
        message = null;
        token = null;
        temporaryToken = null;
      }

      if (token != null) {
        authServiceInterface.saveUserToken(token);
        await authServiceInterface.updateDeviceToken();
        setCurrentLanguage(
            Provider.of<LocalizationController>(Get.context!, listen: false)
                    .getCurrentLanguage() ??
                'en');
      }
      callback(true, token, temporaryToken, message);
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future registration(RegisterModel register, Function callback) async {
    _isLoading = true;
    notifyListeners();

    register.phone = register.phone!.substring(4);
    ApiResponse apiResponse =
        await authServiceInterface.registration(register.toJson());
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      String? temporaryToken = '', token = '', message = '';
      try {
        message = map["message"];
        token = map["token"];
        temporaryToken = map["temporary_token"];
      } catch (e) {
        message = null;
        token = null;
        temporaryToken = null;
      }
      if (token != null && token.isNotEmpty) {
        authServiceInterface.saveUserToken(token);
        await authServiceInterface.updateDeviceToken();
      }
      callback(true, token, temporaryToken, message);
      notifyListeners();
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future logOut() async {
    ApiResponse apiResponse = await authServiceInterface.logout();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {}
  }

  Future<void> setCurrentLanguage(String currentLanguage) async {
    ApiResponse apiResponse =
        await authServiceInterface.setLanguageCode(currentLanguage);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {}
  }

  Future<void> login(LoginModel loginBody, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await authServiceInterface.login(loginBody.toJson());
    _isLoading = false;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      clearGuestId();
      Map map = apiResponse.response!.data;
      String? temporaryToken = '', token = '', message = '';
      try {
        message = map["message"];
        token = map["token"];
        temporaryToken = map["temporary_token"];
      } catch (e) {
        message = null;
        token = null;
        temporaryToken = null;
      }
      if (token != null && token.isNotEmpty) {
        authServiceInterface.saveUserToken(token);
        await authServiceInterface.updateDeviceToken();
      }
      callback(true, token, temporaryToken, message);
      notifyListeners();
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> updateToken(BuildContext context) async {
    ApiResponse apiResponse = await authServiceInterface.updateDeviceToken();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
    } else {
      ApiChecker.checkApi(apiResponse);
    }
  }

  Future<ApiResponse> sendOtpToEmail(String email, String temporaryToken,
      {bool resendOtp = false}) async {
    _isPhoneNumberVerificationButtonLoading = true;
    notifyListeners();
    ApiResponse apiResponse;
    if (resendOtp) {
      apiResponse =
          await authServiceInterface.resendEmailOtp(email, temporaryToken);
    } else {
      apiResponse =
          await authServiceInterface.sendOtpToEmail(email, temporaryToken);
    }
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      resendTime = (apiResponse.response!.data["resend_time"]);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ApiResponse> verifyEmail(String email, String token) async {
    _isPhoneNumberVerificationButtonLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await authServiceInterface.verifyEmail(email, _verificationCode, token);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      authServiceInterface.saveUserToken(apiResponse.response!.data['token']);
      await authServiceInterface.updateDeviceToken();
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  int resendTime = 0;

  Future<ResponseModel> sendOtpToPhone(String phone, String temporaryToken,
      {bool fromResend = false}) async {
    _isPhoneNumberVerificationButtonLoading = true;
    notifyListeners();
    ApiResponse apiResponse;
    if (fromResend) {
      apiResponse =
          await authServiceInterface.resendPhoneOtp(phone, temporaryToken);
    } else {
      apiResponse =
          await authServiceInterface.sendOtpToPhone(phone, temporaryToken);
    }
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response?.statusCode == 200) {
      responseModel = ResponseModel(apiResponse.response!.data["token"], true);
      resendTime = (apiResponse.response!.data["resend_time"]);
    } else {
      String? errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        errorMessage = errorResponse.errors![0].message;
      }
      responseModel = ResponseModel(errorMessage, false);
    }
    notifyListeners();
    return responseModel;
  }

  Future<ApiResponse> verifyPhone(String phone, String token) async {
    _isPhoneNumberVerificationButtonLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await authServiceInterface.verifyPhone(phone, token, _verificationCode);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
    } else {
      _isPhoneNumberVerificationButtonLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  bool isOTPSent = false;
  bool isPhoneNumberVerified = false;

  bool _isPhoneNumberButtonLoading = false;

  bool get isPhoneNumberButtonLoading => _isPhoneNumberButtonLoading;

  Future<void> sendOtp(String phone) async {
    _isPhoneNumberButtonLoading = true;
    notifyListeners();
    var data = jsonEncode({"phone": phone});

    var dio = Dio();
    try {
      var response = await dio.post(
        '${AppConstants.baseUrl}/api/v1/auth/get-phone-otp',
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // log(jsonEncode(response.data));
        showCustomSnackBar(
            '${getTranslated("otp_sent_successfully", Get.context!)}',
            Get.context!,
            isError: false);
        isOTPSent = true;
        _isPhoneNumberButtonLoading = false; // Set loading state to false
        focusNodes[0].requestFocus();
        notifyListeners();
      } else {
        _isPhoneNumberButtonLoading = false; // Set loading state to false

        log('Failed to get OTP: ${response.statusMessage}');
        showCustomSnackBar(
            '${getTranslated("otp_sent_failed", Get.context!)}', Get.context!,
            isError: true);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        log('DioException [${e.type}]: ${e.response?.data}');
        showCustomSnackBar(
            '${e.response?.data["errors"]['phone'][0]}', Get.context!,
            isError: true);
        log('Status code: ${e.response?.statusCode}');
        log('Headers: ${e.response?.headers}');
        _isPhoneNumberButtonLoading = false; // Set loading state to false
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        log('Error sending request: ${e.message}');
        _isPhoneNumberButtonLoading = false; // Set loading state to false

        showCustomSnackBar('${e.message}', Get.context!, isError: true);
      }
    } catch (e) {
      log('Unexpected error: $e');
      _isPhoneNumberButtonLoading = false; // Set loading state to false

      showCustomSnackBar('$e', Get.context!, isError: true);
    } finally {
      _isPhoneNumberButtonLoading = false; // Set loading state to false
      notifyListeners(); // Notify listeners after loading is finished
    }
  }

  Future<bool> verifyOTP(String phone, String otp, BuildContext context) async {
    _isPhoneNumberButtonLoading = true;
    notifyListeners();
    var data = jsonEncode({"phone": phone, "otp": otp});
    var dio = Dio();

    try {
      var response = await dio.post(
        '${AppConstants.baseUrl}/api/v1/auth/verify-phone-otp',
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          followRedirects: true, // Enable redirection handling
        ),
      );

      if (response.statusCode == 200) {
        log(jsonEncode(response.data));
        showCustomSnackBar(response.data["message"], context, isError: false);
        isPhoneNumberVerified = true;
        return true;
      } else if (response.statusCode == 302 || response.statusCode == 301) {
        // Handle redirection manually if needed
        var redirectUrl = response.headers['location']?.first;
        if (redirectUrl != null) {
          log('Redirecting to: $redirectUrl');
          var redirectResponse = await dio.get(redirectUrl);
          if (redirectResponse.statusCode == 200) {
            log(jsonEncode(redirectResponse.data));
            showCustomSnackBar(
                '${getTranslated('otp_verified_successfully', context)}',
                context,
                isError: false);
          } else {
            log('Failed to verify OTP after redirection: ${redirectResponse.statusMessage}');
            showCustomSnackBar(
                '${getTranslated('otp_verified_failed', context)}', context);
          }
        } else {
          log('Failed to verify OTP: Redirection URL not found.');
          showCustomSnackBar(
              '${getTranslated('otp_verified_failed', context)}', context);
        }
        isPhoneNumberVerified = false;

        return false;
      } else {
        log('${getTranslated('otp_verified_failed', context)}: ${response.statusMessage}');
        showCustomSnackBar(response.statusMessage, context);
        isPhoneNumberVerified = false;
        return false;
      }
    } catch (e) {
      log('Unexpected error: $e');
      showCustomSnackBar('Unexpected error: $e', context);
      isPhoneNumberVerified = false;
      return false;
    } finally {
      _isPhoneNumberButtonLoading = false; // Set loading state to false
      notifyListeners(); // Notify listeners after loading is finished
    }
  }

  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  List<TextEditingController> get controllers => _controllers;
  List<FocusNode> get focusNodes => _focusNodes;

  void handleTextChange(String value, int index, BuildContext context) {
    if (value.isNotEmpty) {
      if (index < _focusNodes.length - 1) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        _focusNodes[index].unfocus();
      }
    }
  }

  Future<ApiResponse> verifyOtpForResetPassword(String phone) async {
    _isPhoneNumberVerificationButtonLoading = true;
    notifyListeners();

    ApiResponse apiResponse =
        await authServiceInterface.verifyOtp(phone, _verificationCode);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
    } else {
      _isPhoneNumberVerificationButtonLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ApiResponse> resetPassword(String identity, String otp,
      String password, String confirmPassword) async {
    _isPhoneNumberVerificationButtonLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await authServiceInterface.resetPassword(
        identity, otp, password, confirmPassword);
    _isPhoneNumberVerificationButtonLoading = false;
    notifyListeners();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      showCustomSnackBar(
          getTranslated('password_reset_successfully', Get.context!),
          Get.context!);
      Navigator.pushAndRemoveUntil(
          Get.context!,
          MaterialPageRoute(builder: (_) => const AuthScreen()),
          (route) => false);
    } else {
      _isPhoneNumberVerificationButtonLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  // for phone verification
  bool _isPhoneNumberVerificationButtonLoading = false;
  bool get isPhoneNumberVerificationButtonLoading =>
      _isPhoneNumberVerificationButtonLoading;
  String _email = '';
  String _phone = '';

  String get email => _email;
  String get phone => _phone;

  updateEmail(String email) {
    _email = email;
    notifyListeners();
  }

  updatePhone(String phone) {
    _phone = phone;
    notifyListeners();
  }

  String _verificationCode = '';
  String get verificationCode => _verificationCode;
  bool _isEnableVerificationCode = false;
  bool get isEnableVerificationCode => _isEnableVerificationCode;

  updateVerificationCode(String query) {
    if (query.length == 4) {
      _isEnableVerificationCode = true;
    } else {
      _isEnableVerificationCode = false;
    }
    _verificationCode = query;
    notifyListeners();
  }

  String getUserToken() {
    return authServiceInterface.getUserToken();
  }

  String? getGuestToken() {
    return authServiceInterface.getGuestIdToken();
  }

  bool isLoggedIn() {
    return authServiceInterface.isLoggedIn();
  }

  bool isGuestIdExist() {
    return authServiceInterface.isGuestIdExist();
  }

  Future<bool> clearSharedData() {
    return authServiceInterface.clearSharedData();
  }

  Future<bool> clearGuestId() async {
    return await authServiceInterface.clearGuestId();
  }

  void saveUserEmail(String email, String password) {
    authServiceInterface.saveUserEmailAndPassword(email, password);
  }

  String getUserEmail() {
    return authServiceInterface.getUserEmail();
  }

  Future<bool> clearUserEmailAndPassword() async {
    return authServiceInterface.clearUserEmailAndPassword();
  }

  String getUserPassword() {
    return authServiceInterface.getUserPassword();
  }

  Future<ApiResponse> forgetPassword(String email) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse =
        await authServiceInterface.forgetPassword(email.replaceAll('+', ''));
    _isLoading = false;

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      showCustomSnackBar(apiResponse.response?.data['message'], Get.context!,
          isError: false);
    } else {
      _isLoading = false;
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<void> getGuestIdUrl() async {
    ApiResponse apiResponse = await authServiceInterface.getGuestId();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      authServiceInterface
          .saveGuestId(apiResponse.response!.data['guest_id'].toString());
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void toggleTermsCheck() {
    _isAcceptTerms = !_isAcceptTerms;
    notifyListeners();
  }

  ChangeNumber() {
    isOTPSent = false;
    notifyListeners();
  }
}
