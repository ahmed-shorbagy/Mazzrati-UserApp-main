import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/see_more_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:provider/provider.dart';

import 'package:flutter_sixvalley_ecommerce/features/auction/controllers/add_auction_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/domain/models/auction_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

class AuctionDetailsWidget extends StatefulWidget {
  final Auction auction;
  const AuctionDetailsWidget({super.key, required this.auction});

  @override
  State<AuctionDetailsWidget> createState() => _AuctionDetailsWidgetState();
}

class _AuctionDetailsWidgetState extends State<AuctionDetailsWidget> {
  ScrollController? _controller;
  String message = "";
  bool activated = false;
  bool endScroll = false;

  _onStartScroll(ScrollMetrics metrics) {
    setState(() {
      message = "start";
    });
  }

  _onUpdateScroll(ScrollMetrics metrics) {
    setState(() {
      message = "scrolling";
    });
  }

  _onEndScroll(ScrollMetrics metrics) {
    setState(() {
      message = "end";
    });
  }

  _scrollListener() {
    if (_controller!.offset >= _controller!.position.maxScrollExtent &&
        !_controller!.position.outOfRange) {
      setState(() {
        endScroll = true;
        message = "bottom";
      });
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller!.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _controller!.removeListener(_scrollListener);
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (message == 'end' && !endScroll) {
      Future.delayed(const Duration(seconds: 10), () {
        if (mounted) {
          setState(() {
            activated = true;
          });
        }
      });
    } else {
      activated = false;
    }

    return Consumer<AddAuctionController>(
      builder: (context, auctionProvider, _) {
        return RefreshIndicator(
          onRefresh: () async {
            // Fetch auction details
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollStartNotification) {
                _onStartScroll(scrollNotification.metrics);
              } else if (scrollNotification is ScrollUpdateNotification) {
                _onUpdateScroll(scrollNotification.metrics);
              } else if (scrollNotification is ScrollEndNotification) {
                _onEndScroll(scrollNotification.metrics);
              }
              return false;
            },
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: _controller,
                  child: Column(
                    children: [
                      // Auction data table
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.125),
                              blurRadius: 1,
                              spreadRadius: 1,
                              offset: const Offset(1, 2),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                          title: getTranslated(
                                                  'item_name', context) ??
                                              ""),
                                      CustomText(
                                          title: getTranslated(
                                                  'starting_bid', context) ??
                                              ""),
                                      CustomText(
                                          title: getTranslated(
                                                  'current_bid', context) ??
                                              ""),
                                      CustomText(
                                          title: getTranslated(
                                                  'bid_increment', context) ??
                                              ""),
                                      CustomText(
                                          title: getTranslated(
                                                  'start_time', context) ??
                                              ""),
                                      CustomText(
                                          title: getTranslated(
                                                  'end_time', context) ??
                                              ""),
                                      CustomText(
                                          title: getTranslated(
                                                  'auction_status', context) ??
                                              ""),
                                    ],
                                  ),
                                ),
                                Container(
                                  transform: Matrix4.translationValues(0, 4, 0),
                                  height: 301,
                                  width: .25,
                                  color: Theme.of(context).hintColor,
                                ),
                                Expanded(
                                  flex: 8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                          title: widget.auction.itemName),
                                      CustomText(
                                        title: widget.auction.startingBid
                                            .toString(),
                                        isAmount: true,
                                      ),
                                      CustomText(
                                        title: widget.auction.currentBid
                                            .toString(),
                                        isAmount: true,
                                      ),
                                      CustomText(
                                        title: widget.auction.bidIncrement
                                            .toString(),
                                        isAmount: true,
                                      ),
                                      CustomText(
                                        title:
                                            widget.auction.startTime.toString(),
                                        isLocale: false,
                                      ),
                                      CustomText(
                                        title:
                                            widget.auction.endTime.toString(),
                                        isLocale: false,
                                      ),
                                      CustomText(
                                        title: widget.auction.auctionStatus,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      // You may want to add or adjust the layout here as needed
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(.125),
                              blurRadius: 1,
                              spreadRadius: 1,
                              offset: const Offset(1, 2),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                Dimensions.paddingSizeDefault,
                                Dimensions.paddingSizeMedium,
                                Dimensions.paddingSizeDefault,
                                0,
                              ),
                              child: Text(
                                getTranslated("description", context) ?? "",
                                style: robotoBold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                Dimensions.paddingSizeSmall,
                                0,
                                Dimensions.paddingSizeDefault,
                                Dimensions.paddingSizeSmall,
                              ),
                              child: Html(
                                data: widget.auction.itemDescription,
                                style: {
                                  "table": Style(
                                    backgroundColor: const Color.fromARGB(
                                      0x50,
                                      0xee,
                                      0xee,
                                      0xee,
                                    ),
                                  ),
                                  "tr": Style(
                                    border: const Border(
                                      bottom: BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                  "th": Style(
                                    padding: HtmlPaddings.all(6),
                                    backgroundColor: Colors.grey,
                                  ),
                                  "td": Style(
                                    padding: HtmlPaddings.all(6),
                                    alignment: Alignment.topLeft,
                                  ),
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                activated ? const SeeMoreButtonWidget() : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomText extends StatelessWidget {
  final String title;
  final bool isAmount;
  final bool isLocale;
  const CustomText({
    super.key,
    required this.title,
    this.isAmount = false,
    this.isLocale = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Divider(thickness: .1),
        SizedBox(
          height: 28,
          child: Padding(
            padding: EdgeInsets.only(
              left: Provider.of<LocalizationController>(context).isLtr
                  ? Dimensions.iconSizeDefault
                  : 0,
              right: Provider.of<LocalizationController>(context).isLtr
                  ? 0
                  : Dimensions.iconSizeDefault,
            ),
            child: Text(
              isAmount
                  ? PriceConverter.convertPrice(context, double.parse(title))
                  : title,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
