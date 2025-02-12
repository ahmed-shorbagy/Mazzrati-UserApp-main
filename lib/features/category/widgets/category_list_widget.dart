import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/screens/category_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/widgets/category_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/screens/brand_and_category_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

import 'category_shimmer_widget.dart';

class CategoryListWidget extends StatelessWidget {
  final bool isHomePage;
  const CategoryListWidget({super.key, required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryController>(
      builder: (context, categoryProvider, child) {
        return Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeExtraExtraSmall),
            child: TitleRowWidget(
              title: getTranslated('CATEGORY', context),
              onTap: categoryProvider.categoryList.length <= 10
                  ? null
                  : () {
                      if (categoryProvider.categoryList.isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CategoryScreen()));
                      }
                    },
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          categoryProvider.categoryList.isNotEmpty
              ? GridView.builder(
                  padding:
                      const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Adjust the number of columns as needed
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1, // Adjust the aspect ratio as needed
                  ),
                  itemCount: categoryProvider.categoryList.length > 9
                      ? 9
                      : categoryProvider.categoryList.length,
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(), // To prevent the grid from scrolling inside the column
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => BrandAndCategoryProductScreen(
                                    isBrand: false,
                                    id: categoryProvider.categoryList[index].id
                                        .toString(),
                                    name: categoryProvider
                                        .categoryList[index].name)));
                      },
                      child: CategoryWidget(
                          category: categoryProvider.categoryList[index],
                          index: index,
                          length: categoryProvider.categoryList.length),
                    );
                  },
                )
              : const CategoryShimmerWidget(),
          categoryProvider.categoryList.length > 9
              ? InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,

                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => BrandAndCategoryProductScreen(
                                isBrand: false,
                                id: categoryProvider.categoryList[9].id
                                    .toString(),
                                name: categoryProvider.categoryList[9].name)));
                  },
                  // child: CategoryWidget(

                  //     category: categoryProvider.categoryList[9],
                  //     index: 9,
                  //     length: categoryProvider.categoryList.length),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: Provider.of<LocalizationController>(context,
                                    listen: false)
                                .isLtr
                            ? Dimensions.homePagePadding
                            : 0,
                        right: 0 + 1 == 1
                            ? Dimensions.paddingSizeDefault
                            : Provider.of<LocalizationController>(context,
                                        listen: false)
                                    .isLtr
                                ? 0
                                : Dimensions.homePagePadding),
                    child: Column(children: [
                      Container(
                          height: MediaQuery.of(context).size.width / 4,
                          width: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.125),
                                  width: .25),
                              borderRadius: BorderRadius.circular(
                                  Dimensions.paddingSizeSmall),
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.125)),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.paddingSizeSmall),
                              child: CustomImageWidget(
                                image:
                                    '${categoryProvider.categoryList[9].imageFullUrl?.path}',
                                fit: BoxFit.fill,
                              ))),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      Center(
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Text(
                                  categoryProvider.categoryList[9].name ?? '',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: textRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: ColorResources.getTextTitle(
                                          context)))))
                    ]),
                  ),
                )
              // ? GridView(
              //     padding:
              //         const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 1, // Adjust the number of columns as needed
              //     ),

              //     shrinkWrap: true,
              //     physics:
              //         const NeverScrollableScrollPhysics(), // To prevent the grid from scrolling inside the column
              //     children: [
              //       InkWell(
              //         splashColor: Colors.transparent,
              //         highlightColor: Colors.transparent,
              //         onTap: () {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (_) => BrandAndCategoryProductScreen(
              //                       isBrand: false,
              //                       id: categoryProvider.categoryList[9].id
              //                           .toString(),
              //                       name: categoryProvider
              //                           .categoryList[9].name)));
              //         },
              //         child: CategoryWidget(
              //             category: categoryProvider.categoryList[9],
              //             index: 9,
              //             length: categoryProvider.categoryList.length),
              //       )
              //     ],
              //   )
              : const SizedBox(),
        ]);
      },
    );
  }
}
