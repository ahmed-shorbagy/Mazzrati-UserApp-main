import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class ProductSpecificationWidget extends StatelessWidget {
  final String productSpecification;

  const ProductSpecificationWidget(
      {super.key, required this.productSpecification});

  @override
  Widget build(BuildContext context) {
    // Check if the specification is in JSON format
    bool isJsonFormat = false;
    try {
      if (productSpecification.startsWith('{') &&
          productSpecification.endsWith('}')) {
        jsonDecode(productSpecification);
        isJsonFormat = true;
      }
    } catch (e) {
      // Not valid JSON, will display as HTML
    }

    // If it's in JSON format, we'll skip this widget as the attributes widget will handle it
    if (isJsonFormat) {
      return const SizedBox();
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        child: Text(getTranslated('specification', context) ?? "",
            style: textMedium),
      ),
      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

      // Display raw data for debugging
      // Container(
      //   margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
      //   padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      //   width: double.infinity,
      //   decoration: BoxDecoration(
      //     color: ColorResources.getIconBg(context),
      //     borderRadius: BorderRadius.circular(5),
      //   ),
      //   child: Text(
      //     'Raw Data: $productSpecification',
      //     style: textRegular.copyWith(fontSize: 12),
      //   ),
      // ),

      // Original HTML content
      Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).highlightColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: HtmlWidget(
          productSpecification,
          textStyle: textRegular,
        ),
      ),
    ]);
  }
}
