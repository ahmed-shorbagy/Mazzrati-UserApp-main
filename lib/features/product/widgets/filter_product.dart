import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';

class SortProductBottomSheet extends StatefulWidget {
  const SortProductBottomSheet({super.key});

  @override
  _SortProductBottomSheetState createState() => _SortProductBottomSheetState();
}

class _SortProductBottomSheetState extends State<SortProductBottomSheet> {
  ProductController? resProvider; // Changed to nullable

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resProvider = Provider.of<ProductController>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    if (resProvider == null) {
      return const CircularProgressIndicator(); // Loading indicator
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Text(
            getTranslated('sort_product', context)!,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              ListTile(
                title:
                    Text(getTranslated("sort_by_price_low_to_high", context)!),
                leading: Radio<String>(
                  value: 'asc',
                  groupValue: resProvider!.sortOrder, // Use resProvider!
                  onChanged: (String? value) {
                    setState(() {
                      resProvider!.sortOrder = value!;
                      Provider.of<ProductController>(context, listen: false)
                          .sortProducts(value);
                    });
                  },
                ),
              ),
              ListTile(
                title:
                    Text(getTranslated("sort_by_price_high_to_low", context)!),
                leading: Radio<String>(
                  value: 'desc',
                  groupValue: resProvider!.sortOrder, // Use resProvider!
                  onChanged: (String? value) {
                    setState(() {
                      resProvider!.sortOrder = value!;
                      Provider.of<ProductController>(context, listen: false)
                          .sortProducts(value);
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // CustomButton(
          //   onTap: () {
          //     setState(() {
          //       resProvider!.sortOrder = 'desc'; // Use resProvider!
          //     });
          //     final productController =
          //         Provider.of<ProductController>(context, listen: false);
          //     productController.sortProducts('desc');
          //     Navigator.pop(context);
          //   },
          //   buttonText: getTranslated("clear_filter", context)!,
          // ),
        ],
      ),
    );
  }
}

// Method to show the bottom sheet
Future<void> showProductFilterBottomSheet(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    builder: (context) => const SortProductBottomSheet(),
  );
}
