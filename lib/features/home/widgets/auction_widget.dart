import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';

import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_sixvalley_ecommerce/features/auction/controllers/add_auction_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/domain/models/auction_model.dart';

import 'package:flutter_sixvalley_ecommerce/features/auction/screens/auction_details_screen.dart';

import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';

class ActiveAuctionWidget extends StatefulWidget {
  final Auction? auction;
  final bool isDetails;

  const ActiveAuctionWidget({
    super.key,
    required this.auction,
    this.isDetails = false,
  });

  @override
  State<ActiveAuctionWidget> createState() => _ActiveAuctionWidgetState();
}

class _ActiveAuctionWidgetState extends State<ActiveAuctionWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
        builder: (context, themeController, child) {
      return Padding(
        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        child: GestureDetector(
          onTap: widget.isDetails
              ? null
              : () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AuctionDetailsScreen(
                          customDocId: widget.auction?.auctionId ?? ""),
                    ),
                  ),
          child: Container(
            alignment: Alignment.center,
            height: 200,
            width: MediaQuery.of(context).size.width * .95,
            decoration: BoxDecoration(
              color: themeController.darkTheme
                  ? Theme.of(context).cardColor
                  : Colors.white,
              borderRadius: BorderRadius.circular(12), // Rounded corners
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.15), // Stronger shadow
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal:
                      Dimensions.paddingSizeDefault), // Internal padding
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color:
                              Colors.grey.withOpacity(0.1), // Background color
                          borderRadius: BorderRadius.circular(
                              Dimensions.paddingSizeSmall),
                        ),
                        padding: const EdgeInsets.all(
                            8.0), // Padding between image and border
                        width: 150,
                        height: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              Dimensions.paddingSizeSmall),
                          child: CustomImageWidget(
                            image: widget.auction?.imagesUrl.isNotEmpty ?? false
                                ? widget.auction!.imagesUrl[0]
                                : Images.mazzratiLogo, // Placeholder image
                          ),
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.auction?.itemName != null)
                                Text(
                                  widget.auction!.itemName,
                                  style: robotoBold.copyWith(
                                    fontSize: 16,
                                    color: ColorResources.titleColor(context),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),
                              if (widget.auction?.startingBid != null)
                                Text(
                                  '${getTranslated('starting_bid', context)}: ${widget.auction!.startingBid}',
                                  style: robotoRegular.copyWith(),
                                ),
                              if (widget.auction?.currentBid != null)
                                Text(
                                  '${getTranslated('current_bid', context)}: ${widget.auction!.currentBid}',
                                  style: robotoRegular
                                      .copyWith(), // Noticeable color for current bid
                                ),
                              if (widget.auction?.bidIncrement != null)
                                Text(
                                  '${getTranslated('bid_amount', context)}: ${widget.auction!.bidIncrement}',
                                  style: robotoRegular.copyWith(),
                                ),
                              if (widget.auction != null)
                                Text(
                                  '${getTranslated('auction_status', context)}: ${(widget.auction!.calculateAuctionState() == "active") ? getTranslated('active', context) : (widget.auction!.calculateAuctionState() == "closed") ? getTranslated('closed', context) : getTranslated('Upcoming', context)}',
                                  style: robotoRegular.copyWith(),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

// class ActiveAuctionWidget extends StatefulWidget {
//   final Auction? auction;
//   final bool isDetails;
//   const ActiveAuctionWidget(
//       {super.key, required this.auction, this.isDetails = false});

//   @override
//   State<ActiveAuctionWidget> createState() => _ActiveAuctionWidgetState();
// }

// class _ActiveAuctionWidgetState extends State<ActiveAuctionWidget> {
//   var extend = false;
//   var mini = true;
//   var visible = true;
//   var buttonSize = const Size(35.0, 35.0);
//   var childrenButtonSize = const Size(45.0, 45.0);

//   ValueNotifier<bool> isDialOpen = ValueNotifier(false);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
//       child: GestureDetector(
//         onTap: widget.isDetails
//             ? null
//             : () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (_) => AuctionDetailsScreen(
//                         customDocId: widget.auction?.auctionId ?? ""))),
//         child: Container(
//           alignment: Alignment.center,
//           height: 200,
//           width: MediaQuery.of(context).size.width * .95,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             // border: Border.all(color: Theme.of(context).primaryColor),
//             borderRadius: BorderRadius.circular(12), // Rounded corners
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(.15), // Stronger shadow
//                 spreadRadius: 2,
//                 blurRadius: 4,
//                 offset: const Offset(2, 4),
//               ),
//             ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0), // Internal padding
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey.withOpacity(0.1), // Background color
//                         borderRadius:
//                             BorderRadius.circular(Dimensions.paddingSizeSmall),
//                       ),
//                       padding: const EdgeInsets.all(
//                           8.0), // Padding between image and border
//                       width: 140,
//                       height: 140,
//                       child: ClipRRect(
//                         borderRadius:
//                             BorderRadius.circular(Dimensions.paddingSizeSmall),
//                         child: CustomImageWidget(
//                           image: widget.auction?.imagesUrl.isNotEmpty ?? false
//                               ? widget.auction!.imagesUrl[0]
//                               : 'path/to/placeholder_image.png', // Placeholder image
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: Dimensions.paddingSizeSmall),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             if (widget.auction?.itemName != null)
//                               Text(widget.auction!.itemName,
//                                   style: robotoBold.copyWith(
//                                       // Bold and larger font
//                                       fontSize: 16,
//                                       color:
//                                           ColorResources.titleColor(context)),
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis),
//                             const SizedBox(height: Dimensions.paddingSizeSmall),
//                             if (widget.auction?.startingBid != null)
//                               Text(
//                                 '${getTranslated('starting_bid', context)}: ${widget.auction!.startingBid}',
//                                 style:
//                                     robotoRegular.copyWith(color: Colors.black),
//                               ),
//                             if (widget.auction?.currentBid != null)
//                               Text(
//                                 '${getTranslated('current_bid', context)}: ${widget.auction!.currentBid}',
//                                 style: robotoRegular.copyWith(
//                                     color: Colors
//                                         .green), // Noticeable color for current bid
//                               ),
//                             if (widget.auction?.currentBid != null)
//                               Text(
//                                 '${getTranslated('bid_amount', context)}: ${widget.auction!.bidIncrement}',
//                                 style:
//                                     robotoRegular.copyWith(color: Colors.black),
//                               ),
//                             if (widget.auction != null)
//                               Text(
//                                 '${getTranslated('auction_status', context)}: ${(widget.auction!.calculateAuctionState() == "active") ? getTranslated('active', context) : (widget.auction!.calculateAuctionState() == "closed") ? getTranslated('closed', context) : getTranslated('Upcoming', context)}',
//                                 style:
//                                     robotoRegular.copyWith(color: Colors.black),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
