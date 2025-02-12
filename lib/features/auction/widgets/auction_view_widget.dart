import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';

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

class AuctionWidget extends StatefulWidget {
  final Auction? auction;
  final bool isDetails;
  const AuctionWidget(
      {super.key, required this.auction, this.isDetails = false});

  @override
  State<AuctionWidget> createState() => _AuctionWidgetState();
}

class _AuctionWidgetState extends State<AuctionWidget> {
  var extend = false;
  var mini = true;
  var visible = true;
  var buttonSize = const Size(35.0, 35.0);
  var childrenButtonSize = const Size(45.0, 45.0);

  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          child: GestureDetector(
            onTap: widget.isDetails
                ? null
                : () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AuctionDetailsScreen(
                            customDocId: widget.auction?.auctionId ?? ""))),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeMedium,
                  vertical: Dimensions.paddingSizeSmall),
              decoration:
                  BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [
                BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(.05),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(1, 2))
              ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: Dimensions.paddingSizeSmall),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(.10),
                                borderRadius: BorderRadius.circular(
                                    Dimensions.paddingSizeSmall),
                              ),
                              width: 110,
                              height: 110,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.paddingSizeSmall),
                                child: CustomImageWidget(
                                  image: widget.auction?.imagesUrl.isNotEmpty ??
                                          false
                                      ? widget.auction!.imagesUrl[0]
                                      : '',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.auction!.itemName ?? '',
                                  style: robotoRegular.copyWith(
                                      color:
                                          ColorResources.titleColor(context)),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(
                                  height: Dimensions.paddingSizeSmall),
                              Text(
                                '${getTranslated('starting_bid', context)}: ${widget.auction!.startingBid}',
                                style: robotoRegular.copyWith(
                                    color: ColorResources.titleColor(context)),
                              ),
                              Text(
                                '${getTranslated('current_bid', context)}: ${widget.auction!.currentBid}',
                                style: robotoRegular.copyWith(
                                    color: ColorResources.titleColor(context)),
                              ),
                              Text(
                                '${getTranslated('auction_status', context)}: ${(widget.auction!.calculateAuctionState() == "active") ? getTranslated('active', context) : (widget.auction!.calculateAuctionState() == "closed") ? getTranslated('closed', context) : getTranslated('Upcoming', context)}',
                                style: robotoRegular.copyWith(
                                    color: ColorResources.titleColor(context)),
                              ),
                              Text(
                                '${getTranslated('category', context)}: ${widget.auction!.category}',
                                style: robotoRegular.copyWith(
                                    color: ColorResources.titleColor(context)),
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
      ],
    );
  }
}
