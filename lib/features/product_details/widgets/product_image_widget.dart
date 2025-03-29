import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_logged_in_bottom_sheet_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/compare/controllers/compare_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/controllers/product_details_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/domain/models/product_details_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/screens/product_image_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/favourite_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ProductImageWidget extends StatelessWidget {
  final ProductDetailsModel? productModel;
  ProductImageWidget({super.key, required this.productModel});

  final PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    var splashController =
        Provider.of<SplashController>(context, listen: false);
    return productModel != null
        ? Consumer<ProductDetailsController>(
            builder: (context, productController, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => ProductImageScreen(
                            title: getTranslated('product_image', context),
                            imageList: productModel!.thumbnailFullUrl != null
                                ? [productModel!.thumbnailFullUrl!]
                                : []))),
                    child: (productModel != null &&
                            productModel!.thumbnailFullUrl != null)
                        ? Padding(
                            padding: const EdgeInsets.all(
                                Dimensions.homePagePadding),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.paddingSizeSmall),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        border: Border.all(
                                            color: Provider.of<ThemeController>(context, listen: false).darkTheme
                                                ? Theme.of(context)
                                                    .hintColor
                                                    .withOpacity(.25)
                                                : Theme.of(context).primaryColor.withOpacity(.25)),
                                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                                    child: Stack(children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: productModel!
                                                      .thumbnailFullUrl !=
                                                  null
                                              ? CustomImageWidget(
                                                  height: MediaQuery
                                                              .of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  image:
                                                      '${productModel!.thumbnailFullUrl?.path}')
                                              : const SizedBox()),
                                      Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 10,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const SizedBox(),
                                                const Spacer(),
                                                const Spacer(),
                                                const SizedBox()
                                              ])),
                                      Positioned(
                                          top: 16,
                                          right: 16,
                                          child: Column(children: [
                                            FavouriteButtonWidget(
                                                backgroundColor:
                                                    ColorResources.getImageBg(
                                                        context),
                                                productId: productModel!.id),
                                            if (splashController
                                                    .configModel!.activeTheme !=
                                                "default")
                                              const SizedBox(
                                                height:
                                                    Dimensions.paddingSizeSmall,
                                              ),
                                            if (splashController
                                                    .configModel!.activeTheme !=
                                                "default")
                                              InkWell(onTap: () {
                                                if (Provider.of<AuthController>(
                                                        context,
                                                        listen: false)
                                                    .isLoggedIn()) {
                                                  Provider.of<CompareController>(
                                                          context,
                                                          listen: false)
                                                      .addCompareList(
                                                          productModel!.id!);
                                                } else {
                                                  showModalBottomSheet(
                                                      backgroundColor:
                                                          const Color(
                                                              0x00FFFFFF),
                                                      context: context,
                                                      builder: (_) =>
                                                          const NotLoggedInBottomSheetWidget());
                                                }
                                              }, child:
                                                  Consumer<CompareController>(
                                                      builder: (context,
                                                          compare, _) {
                                                return Card(
                                                    elevation: 2,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50)),
                                                    child: Container(
                                                        width: 40,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: compare
                                                                    .compIds
                                                                    .contains(
                                                                        productModel!
                                                                            .id)
                                                                ? Theme.of(
                                                                        context)
                                                                    .primaryColor
                                                                : Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                            shape: BoxShape
                                                                .circle),
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                              .all(Dimensions
                                                                  .paddingSizeSmall),
                                                          child: Image.asset(
                                                              Images.compare,
                                                              color: compare
                                                                      .compIds
                                                                      .contains(
                                                                          productModel!
                                                                              .id)
                                                                  ? Theme.of(
                                                                          context)
                                                                      .cardColor
                                                                  : Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                        )));
                                              })),
                                            const SizedBox(
                                              height:
                                                  Dimensions.paddingSizeSmall,
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  if (productController
                                                          .sharableLink !=
                                                      null) {
                                                    Share.share(
                                                        productController
                                                            .sharableLink!);
                                                  }
                                                },
                                                child: Card(
                                                    elevation: 2,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                50)),
                                                    child: Container(
                                                        width: 40,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: Theme.of(context)
                                                                .cardColor,
                                                            shape: BoxShape
                                                                .circle),
                                                        child: Padding(
                                                            padding: const EdgeInsets.all(
                                                                Dimensions
                                                                    .paddingSizeSmall),
                                                            child: Image.asset(
                                                                Images.share,
                                                                color: Theme.of(context).primaryColor)))))
                                          ])),
                                      Positioned(
                                          top: 10,
                                          left: 0,
                                          child: Container(
                                            transform:
                                                Matrix4.translationValues(
                                                    -1, 0, 0),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal:
                                                    Dimensions.paddingSizeSmall,
                                                vertical: Dimensions
                                                    .paddingSizeExtraSmall),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topRight: Radius.circular(
                                                    Dimensions
                                                        .paddingSizeExtraSmall),
                                                bottomRight: Radius.circular(
                                                    Dimensions
                                                        .paddingSizeExtraSmall),
                                              ),
                                            ),
                                            child: Center(
                                                child: Directionality(
                                                    textDirection:
                                                        TextDirection.ltr,
                                                    child: Text(
                                                      PriceConverter
                                                          .percentageCalculation(
                                                              context,
                                                              productModel!
                                                                  .unitPrice,
                                                              productModel!
                                                                  .discount,
                                                              productModel!
                                                                  .discountType),
                                                      style: textBold.copyWith(
                                                          color: Colors.white,
                                                          fontSize: Dimensions
                                                              .fontSizeSmall),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ))),
                                          )),
                                    ]))))
                        : const SizedBox()),
              ],
            );
          })
        : const SizedBox();
  }
}
