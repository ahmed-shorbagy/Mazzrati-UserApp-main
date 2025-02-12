import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/controllers/add_auction_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final filterProvider =
          Provider.of<AddAuctionController>(context, listen: false);
      final resProvider =
          Provider.of<CategoryController>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                getTranslated('filter_by_category', context)!,
                style: robotoRegular.copyWith(
                    color: ColorResources.titleColor(context),
                    fontSize: Dimensions.fontSizeDefault),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Consumer<CategoryController>(
            builder: (context, resProvider, child) {
              return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius:
                        BorderRadius.circular(Dimensions.radiusDefault),
                    border: Border.all(
                        width: .5,
                        color: Theme.of(context).primaryColor.withOpacity(.7)),
                  ),
                  child: DropdownButton<int>(
                      value: resProvider.categoryIndex,
                      items: resProvider.categoryIds.map((int? value) {
                        return DropdownMenuItem<int>(
                          value: resProvider.categoryIds.indexOf(value),
                          child: Text(value != 0
                              ? resProvider
                                  .categoryList[
                                      (resProvider.categoryIds.indexOf(value) -
                                          1)]
                                  .name!
                              : getTranslated('all', context)!),
                        );
                      }).toList(),
                      onChanged: (int? value) {
                        resProvider.setCategoryIndex(value, true);
                        final filterProvider =
                            Provider.of<AddAuctionController>(context,
                                listen: false);
                        if (value != 0) {
                          filterProvider.setCategory(
                              resProvider.categoryList[value! - 1].name);
                        } else {
                          filterProvider.setCategory(null);
                        }
                        log(filterProvider.selectedCategory!);
                      },
                      isExpanded: true,
                      underline: const SizedBox()));
            },
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          Consumer<AddAuctionController>(
            builder: (context, filterProvider, child) {
              return Column(
                children: [
                  RadioListTile<SortingOption>(
                    title: Text(getTranslated('sory_by_newest', context)!),
                    value: SortingOption.Newest,
                    groupValue: filterProvider.selectedSortingOption,
                    onChanged: (value) {
                      filterProvider.setSortingOption(value!);
                    },
                  ),
                  RadioListTile<SortingOption>(
                    title: Text(getTranslated('sory_by_oldest', context)!),
                    value: SortingOption.Oldest,
                    groupValue: filterProvider.selectedSortingOption,
                    onChanged: (value) {
                      filterProvider.setSortingOption(value!);
                    },
                  ),
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CustomButton(
              buttonText: getTranslated('clear_filter', context)!,
              onTap: () {
                Provider.of<AddAuctionController>(context, listen: false)
                    .setCategory(null);
                Provider.of<CategoryController>(context, listen: false)
                    .setCategoryIndex(0, true);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum SortingOption {
  Newest,
  Oldest,
}

// Method to show the bottom sheet
Future<Map<String, dynamic>?> showFilterBottomSheet(
    BuildContext context) async {
  return await showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    builder: (context) => const FilterBottomSheet(),
  );
}
