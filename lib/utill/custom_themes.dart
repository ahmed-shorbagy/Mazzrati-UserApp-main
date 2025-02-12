import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

const titilliumRegular = TextStyle(
  fontFamily: 'DINNextLTArabic',
  fontSize: 12,
);
const titleRegular = TextStyle(
  fontFamily: 'DINNextLTArabic',
  fontWeight: FontWeight.w500,
  fontSize: 14,
);
const titleHeader = TextStyle(
  fontFamily: 'DINNextLTArabic',
  fontWeight: FontWeight.w600,
  fontSize: 16,
);
const titilliumSemiBold = TextStyle(
  fontFamily: 'DINNextLTArabic',
  fontSize: 12,
  fontWeight: FontWeight.w600,
);

const titilliumBold = TextStyle(
  fontFamily: 'DINNextLTArabic',
  fontSize: 14,
  fontWeight: FontWeight.w700,
);
const titilliumItalic = TextStyle(
  fontFamily: 'DINNextLTArabic',
  fontSize: 14,
  fontStyle: FontStyle.italic,
);

const textRegular = TextStyle(
  fontFamily: 'DINNextLTArabic',
  fontWeight: FontWeight.w300,
  fontSize: 14,
);

const textMedium = TextStyle(
    fontFamily: 'DINNextLTArabic', fontSize: 14, fontWeight: FontWeight.w500);
const textBold = TextStyle(
    fontFamily: 'DINNextLTArabic', fontSize: 14, fontWeight: FontWeight.w600);

const robotoBold = TextStyle(
  fontFamily: 'DINNextLTArabic',
  fontSize: 14,
  fontWeight: FontWeight.w700,
);

final robotoHintRegular = TextStyle(
    fontFamily: 'DINNextLTArabic',
    fontWeight: FontWeight.w400,
    fontSize: Dimensions.fontSizeSmall,
    color: Colors.grey);
final robotoRegular = TextStyle(
  fontFamily: 'DINNextLTArabic',
  fontWeight: FontWeight.w400,
  fontSize: Dimensions.fontSizeDefault,
);
final robotoRegularMainHeadingAddProduct = TextStyle(
  fontFamily: 'DINNextLTArabic',
  fontWeight: FontWeight.w400,
  fontSize: Dimensions.fontSizeDefault,
);

final robotoRegularForAddProductHeading = TextStyle(
  fontFamily: 'DINNextLTArabic',
  color: const Color(0xFF9D9D9D),
  fontWeight: FontWeight.w400,
  fontSize: Dimensions.fontSizeSmall,
);

final robotoTitleRegular = TextStyle(
  fontFamily: 'DINNextLTArabic',
  fontWeight: FontWeight.w400,
  fontSize: Dimensions.fontSizeLarge,
);

final robotoSmallTitleRegular = TextStyle(
  fontFamily: 'DINNextLTArabic',
  fontWeight: FontWeight.w400,
  fontSize: Dimensions.fontSizeSmall,
);

final robotoMedium = TextStyle(
  fontFamily: 'DINNextLTArabic',
  fontSize: Dimensions.fontSizeDefault,
  fontWeight: FontWeight.w500,
);

class ThemeShadow {
  static List<BoxShadow> getShadow(BuildContext context) {
    List<BoxShadow> boxShadow = [
      BoxShadow(
          color: Provider.of<ThemeController>(context, listen: false).darkTheme
              ? Colors.black26
              : Theme.of(context).primaryColor.withOpacity(.075),
          blurRadius: 5,
          spreadRadius: 1,
          offset: const Offset(1, 1))
    ];
    return boxShadow;
  }
}
