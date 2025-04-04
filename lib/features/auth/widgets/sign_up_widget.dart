import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/domain/models/register_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/widgets/condition_check_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/velidate_check.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';
import '../screens/otp_verification_screen.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  @override
  SignUpWidgetState createState() => SignUpWidgetState();
}

class SignUpWidgetState extends State<SignUpWidget> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _referController = TextEditingController();

  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referFocus = FocusNode();

  RegisterModel register = RegisterModel();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  route(bool isRoute, String? token, String? tempToken,
      String? errorMessage) async {
    var splashController =
        Provider.of<SplashController>(context, listen: false);
    var authController = Provider.of<AuthController>(context, listen: false);
    var profileController =
        Provider.of<ProfileController>(context, listen: false);
    String phone =
        authController.countryDialCode + _phoneController.text.trim();
    if (isRoute) {
      if (splashController.configModel!.emailVerification!) {
        authController
            .sendOtpToEmail(_emailController.text.toString(), tempToken!)
            .then((value) async {
          if (value.response?.statusCode == 200) {
            authController.updateEmail(_emailController.text.toString());
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => VerificationScreen(
                        tempToken, '', _emailController.text.toString())),
                (route) => false);
          }
        });
      } else if (splashController.configModel!.phoneVerification!) {
        authController.sendOtpToPhone(phone, tempToken!).then((value) async {
          if (value.isSuccess) {
            authController.updatePhone(phone);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => VerificationScreen(tempToken, phone, '')),
                (route) => false);
          }
        });
      } else {
        await profileController.getUserInfo(context);
        Navigator.pushAndRemoveUntil(
            Get.context!,
            MaterialPageRoute(builder: (_) => const DashBoardScreen()),
            (route) => false);
        _emailController.clear();
        _passwordController.clear();
        _firstNameController.clear();
        _lastNameController.clear();
        _phoneController.clear();
        _confirmPasswordController.clear();
        _referController.clear();
      }
    } else {
      showCustomSnackBar(errorMessage, context);
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<AuthController>(context, listen: false).setCountryCode(
        CountryCode.fromCountryCode(
                Provider.of<SplashController>(context, listen: false)
                    .configModel!
                    .countryCode!)
            .dialCode!,
        notify: false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<AuthController>(builder: (context, authProvider, _) {
          return Consumer<SplashController>(
              builder: (context, splashProvider, _) {
            return Form(
              key: signUpFormKey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: Dimensions.marginSizeDefault,
                        right: Dimensions.marginSizeDefault,
                        top: Dimensions.marginSizeSmall),
                    child: Column(
                      children: [
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: CustomTextFieldWidget(
                              hintText:
                                  getTranslated('enter_mobile_number', context),
                              labelText:
                                  getTranslated('enter_mobile_number', context),
                              controller: _phoneController,
                              focusNode: _phoneFocus,
                              nextFocus: _passwordFocus,
                              isEnabled: !authProvider.isOTPSent,
                              required: true,
                              showCodePicker: true,
                              onChanged: (value) {
                                if (value.startsWith('0')) {
                                  _phoneController.text =
                                      _phoneController.text.substring(1);
                                }
                                if (authProvider.isOTPSent) {
                                  authProvider.focusNodes[0].requestFocus();
                                }
                              },
                              countryDialCode: authProvider.countryDialCode,
                              onCountryChanged: (CountryCode countryCode) {
                                _phoneFocus.requestFocus();
                                authProvider.countryDialCode =
                                    countryCode.dialCode!;
                                authProvider
                                    .setCountryCode(countryCode.dialCode!);
                              },
                              isAmount: true,
                              validator: (value) =>
                                  ValidateCheck.validateEmptyText(
                                      value, "phone_must_be_required"),
                              inputAction: TextInputAction.next,
                              inputType: TextInputType.phone),
                        ),
                        const SizedBox(
                          height: Dimensions.paddingSizeExtraSmall,
                        ),
                        if (!authProvider.isOTPSent) ...[
                          !authProvider.isPhoneNumberButtonLoading
                              ? CustomButton(
                                  buttonText:
                                      getTranslated("send_otp", context),
                                  onTap: () {
                                    if (_phoneController.text.startsWith('0')) {
                                      _phoneController.text =
                                          _phoneController.text.substring(1);
                                      log(_phoneController.text);
                                    }
                                    if (_phoneController.text.isNotEmpty) {
                                      Provider.of<AuthController>(context,
                                              listen: false)
                                          .sendOtp(
                                              _phoneController.text.trim());
                                    }
                                  })
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ],
                        const SizedBox(
                          height: Dimensions.paddingSizeExtraSmall,
                        ),
                        if (authProvider.isOTPSent &&
                            !authProvider.isPhoneNumberVerified) ...[
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(6, (index) {
                                  return SizedBox(
                                    width: 40,
                                    height: 50,
                                    child: TextField(
                                      autofocus: true,
                                      controller:
                                          authProvider.controllers[index],
                                      focusNode: authProvider.focusNodes[index],
                                      textAlign: TextAlign.center,
                                      maxLength: 1,
                                      keyboardType: TextInputType.number,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                      decoration: InputDecoration(
                                        counterText: '',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        authProvider.handleTextChange(
                                            value, index, context);
                                      },
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: Dimensions.paddingSizeSmall,
                          ),
                          authProvider.isPhoneNumberButtonLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : CustomButton(
                                  buttonText:
                                      getTranslated("verify_OTP", context),
                                  onTap: () {
                                    String otp = authProvider.controllers
                                        .map((controller) => controller.text)
                                        .join();
                                    if (otp.length == 6) {
                                      Provider.of<AuthController>(context,
                                              listen: false)
                                          .verifyOTP(_phoneController.text, otp,
                                              context);
                                    }
                                  }),
                          if (authProvider.isOTPSent) ...[
                            const SizedBox(
                              height: Dimensions.paddingSizeSmall,
                            ),
                            !authProvider.isPhoneNumberButtonLoading
                                ? CustomButton(
                                    buttonText:
                                        getTranslated("resend_otp", context),
                                    onTap: () {
                                      if (_phoneController.text
                                          .startsWith('0')) {
                                        _phoneController.text =
                                            _phoneController.text.substring(1);
                                        log(_phoneController.text);
                                      }
                                      if (_phoneController.text.isNotEmpty) {
                                        Provider.of<AuthController>(context,
                                                listen: false)
                                            .sendOtp(
                                                _phoneController.text.trim());
                                      }
                                    })
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                            const SizedBox(
                              height: Dimensions.paddingSize,
                            ),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Provider.of<AuthController>(context,
                                          listen: false)
                                      .ChangeNumber();
                                },
                                child: Text(
                                    getTranslated('change_number', context) ??
                                        ''),
                              ),
                            ),
                          ],
                        ]
                      ],
                    ),
                  ),
                  if (authProvider.isPhoneNumberVerified) ...[
                    const SizedBox(
                      height: Dimensions.paddingSizeExtraSmall,
                    ),
                    Container(
                        margin: const EdgeInsets.only(
                            left: Dimensions.marginSizeDefault,
                            right: Dimensions.marginSizeDefault),
                        child: CustomTextFieldWidget(
                            hintText: getTranslated('first_name', context),
                            labelText: getTranslated('first_name', context),
                            inputType: TextInputType.name,
                            required: true,
                            focusNode: _fNameFocus,
                            nextFocus: _lNameFocus,
                            prefixIcon: Images.username,
                            capitalization: TextCapitalization.words,
                            controller: _firstNameController,
                            validator: (value) =>
                                ValidateCheck.validateEmptyText(
                                    value, "first_name_field_is_required"))),
                    Container(
                        margin: const EdgeInsets.only(
                            left: Dimensions.marginSizeDefault,
                            right: Dimensions.marginSizeDefault,
                            top: Dimensions.marginSizeSmall),
                        child: CustomTextFieldWidget(
                            hintText: getTranslated('last_name', context),
                            labelText: getTranslated('last_name', context),
                            focusNode: _lNameFocus,
                            prefixIcon: Images.username,
                            nextFocus: _emailFocus,
                            required: true,
                            capitalization: TextCapitalization.words,
                            controller: _lastNameController,
                            validator: (value) =>
                                ValidateCheck.validateEmptyText(
                                    value, "last_name_field_is_required"))),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Container(
                          margin: const EdgeInsets.only(
                              left: Dimensions.marginSizeDefault,
                              right: Dimensions.marginSizeDefault,
                              top: Dimensions.marginSizeSmall),
                          child: CustomTextFieldWidget(
                              hintText:
                                  getTranslated('enter_your_email', context),
                              labelText:
                                  getTranslated('enter_your_email', context),
                              focusNode: _emailFocus,
                              nextFocus: _phoneFocus,
                              required: true,
                              inputType: TextInputType.emailAddress,
                              controller: _emailController,
                              prefixIcon: Images.email,
                              validator: (value) =>
                                  ValidateCheck.validateEmail(value))),
                    ),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Container(
                          margin: const EdgeInsets.only(
                              left: Dimensions.marginSizeDefault,
                              right: Dimensions.marginSizeDefault,
                              top: Dimensions.marginSizeSmall),
                          child: CustomTextFieldWidget(
                              hintText: getTranslated(
                                  'minimum_password_length', context),
                              labelText: getTranslated('password', context),
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              isPassword: true,
                              required: true,
                              nextFocus: _confirmPasswordFocus,
                              inputAction: TextInputAction.next,
                              validator: (value) =>
                                  ValidateCheck.validatePassword(
                                      value, "password_must_be_required"),
                              prefixIcon: Images.pass)),
                    ),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Hero(
                          tag: 'user',
                          child: Container(
                              margin: const EdgeInsets.only(
                                  left: Dimensions.marginSizeDefault,
                                  right: Dimensions.marginSizeDefault,
                                  top: Dimensions.marginSizeSmall),
                              child: CustomTextFieldWidget(
                                  isPassword: true,
                                  required: true,
                                  hintText: getTranslated(
                                      're_enter_password', context),
                                  labelText: getTranslated(
                                      're_enter_password', context),
                                  controller: _confirmPasswordController,
                                  focusNode: _confirmPasswordFocus,
                                  inputAction: TextInputAction.done,
                                  validator: (value) =>
                                      ValidateCheck.validateConfirmPassword(
                                          value,
                                          _passwordController.text.trim()),
                                  prefixIcon: Images.pass))),
                    ),
                    if (splashProvider.configModel!.refEarningStatus != null &&
                        splashProvider.configModel!.refEarningStatus == "1")
                      Padding(
                          padding: const EdgeInsets.only(
                              top: Dimensions.paddingSizeDefault,
                              left: Dimensions.paddingSizeDefault),
                          child: Row(children: [
                            Text(getTranslated('refer_code', context) ?? '')
                          ])),
                    if (splashProvider.configModel!.refEarningStatus != null &&
                        splashProvider.configModel!.refEarningStatus == "1")
                      Container(
                          margin: const EdgeInsets.only(
                              left: Dimensions.marginSizeDefault,
                              right: Dimensions.marginSizeDefault,
                              top: Dimensions.marginSizeSmall),
                          child: CustomTextFieldWidget(
                              hintText:
                                  getTranslated('enter_refer_code', context),
                              labelText:
                                  getTranslated('enter_refer_code', context),
                              controller: _referController,
                              focusNode: _referFocus,
                              inputAction: TextInputAction.done)),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    const ConditionCheckBox(),
                    Container(
                        margin:
                            const EdgeInsets.all(Dimensions.marginSizeLarge),
                        child: Hero(
                          tag: 'onTap',
                          child: CustomButton(
                            isLoading: authProvider.isLoading,
                            onTap: authProvider.isAcceptTerms
                                ? () {
                                    String firstName =
                                        _firstNameController.text.trim();
                                    String lastName =
                                        _lastNameController.text.trim();
                                    String email = _emailController.text.trim();
                                    String phoneNumber =
                                        authProvider.countryDialCode +
                                            _phoneController.text.trim();
                                    String password =
                                        _passwordController.text.trim();

                                    if (signUpFormKey.currentState
                                            ?.validate() ??
                                        false) {
                                      register.fName = firstName;
                                      register.lName = lastName;
                                      register.email = email;
                                      register.phone = phoneNumber;
                                      register.password = password;
                                      register.referCode =
                                          _referController.text.trim();
                                      authProvider.registration(
                                          register, route);
                                    }
                                  }
                                : null,
                            buttonText: getTranslated('sign_up', context),
                          ),
                        )),
                    authProvider.isLoading
                        ? const SizedBox()
                        : Center(
                            child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: Dimensions.paddingSizeExtraLarge),
                            child: InkWell(
                              onTap: () {
                                authProvider.getGuestIdUrl();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const DashBoardScreen()));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(getTranslated('skip_for_now', context)!,
                                      style: titilliumRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault,
                                          color: ColorResources.getPrimary(
                                              context))),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 15,
                                    color: Theme.of(context).primaryColor,
                                  )
                                ],
                              ),
                            ),
                          )),
                  ]
                ],
              ),
            );
          });
        }),
      ],
    );
  }
}
