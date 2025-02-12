import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/controllers/cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class SquareButtonWidget extends StatelessWidget {
  final String image;
  final String? title;
  final Widget navigateTo;
  final int count;
  final bool hasCount;
  final bool isWallet;
  final double? balance;
  final bool isLoyalty;
  final String? subTitle;

  // Customizable properties
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry imagePadding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final Color? imageColor;
  final double imageSize;
  final TextStyle? titleTextStyle;
  final TextStyle? subTitleTextStyle;
  final TextStyle? balanceTextStyle;
  final double countRadius;
  final Color? countBackgroundColor;
  final TextStyle? countTextStyle;

  const SquareButtonWidget({
    super.key,
    required this.image,
    this.title,
    required this.navigateTo,
    required this.count,
    required this.hasCount,
    this.isWallet = false,
    this.balance,
    this.subTitle,
    this.isLoyalty = false,
    this.imagePadding = const EdgeInsets.all(Dimensions.paddingSizeLarge),
    this.width = 120.0,
    this.height = 90.0,
    this.padding = const EdgeInsets.all(8.0),
    this.borderRadius = 10.0,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 15.0,
    this.imageColor = ColorResources.white,
    this.imageSize = 30.0,
    this.titleTextStyle,
    this.subTitleTextStyle,
    this.balanceTextStyle,
    this.countRadius = 10.0,
    this.countBackgroundColor = ColorResources.red,
    this.countTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => navigateTo),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Adjust the size based on children
        children: [
          Padding(
            padding: padding,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                color: backgroundColor ??
                    (Provider.of<ThemeController>(context).darkTheme
                        ? Theme.of(context).primaryColor.withOpacity(.30)
                        : Theme.of(context).primaryColor),
                border: borderColor != null
                    ? Border.all(
                        color: borderColor!.withOpacity(.07),
                        width: borderWidth)
                    : null,
              ),
              child: Stack(
                children: [
                  if (isWallet)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: imageSize,
                        height: imageSize,
                        child: Image.asset(image, color: imageColor),
                      ),
                    )
                  else
                    Center(
                      child: Padding(
                        padding: imagePadding,
                        child: Image.asset(image,
                            color: imageColor,
                            width: imageSize,
                            height: imageSize),
                      ),
                    ),
                  if (isWallet)
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            getTranslated(subTitle, context) ?? '',
                            style: subTitleTextStyle ??
                                textRegular.copyWith(color: Colors.white),
                          ),
                          Text(
                            balance != null
                                ? (isLoyalty
                                    ? balance!.toStringAsFixed(0)
                                    : PriceConverter.convertPrice(
                                        context, balance))
                                : '0',
                            style: balanceTextStyle ??
                                textMedium.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  if (hasCount)
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Consumer<CartController>(
                        builder: (context, cart, child) {
                          return CircleAvatar(
                            radius: countRadius,
                            backgroundColor: countBackgroundColor,
                            child: Text(
                              count.toString(),
                              style: countTextStyle ??
                                  titilliumSemiBold.copyWith(
                                    color: Theme.of(context).cardColor,
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (title !=
              null) // Only add the Text widget if the title is not null
            Text(
              title!,
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: titleTextStyle ??
                  titilliumRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
            ),
        ],
      ),
    );
  }
}
