import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_snackbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/widgets/all_bids_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/widgets/auction_data_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/widgets/auction_timer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/widgets/full_screen_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/controllers/add_auction_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/domain/models/auction_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/widgets/auction_details_widget.dart';

class AuctionDetailsScreen extends StatefulWidget {
  final String customDocId;
  const AuctionDetailsScreen({super.key, required this.customDocId});

  @override
  State<AuctionDetailsScreen> createState() => _AuctionDetailsScreenState();
}

class _AuctionDetailsScreenState extends State<AuctionDetailsScreen> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  double? previousBid;
  String formatBidTime(DateTime dateTime, {String locale = 'en'}) {
    if (locale == 'en') {
      return DateFormat('dd/MM/yyyy hh:mm a', locale).format(dateTime);
    }
    return DateFormat('yyyy/MM/dd hh:mm a', locale).format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated('auction_details', context) ?? '',
        isBackButtonExist: true,
      ),
      body: StreamBuilder<List<Auction>>(
        stream: Provider.of<AddAuctionController>(context, listen: false)
            .getACustomAuctionsStream(context, widget.customDocId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No auction found.'));
          } else {
            Auction auction = snapshot.data!.first;

            // Check if currentBid has changed
            final profile = context.read<ProfileController>().userInfoModel;
            if (previousBid != null &&
                previousBid != auction.currentBid &&
                int.parse(auction.bids[auction.bids.length - 1].userId) !=
                    profile!.id) {
              _showBidChangeDialog(context, auction.currentBid);
            }

            // Update previousBid
            previousBid = auction.currentBid;

            // Determine if the auction is closed and has bids
            bool isAuctionClosed = auction.calculateAuctionState() == 'closed';
            Bid? winnerBid;
            if (isAuctionClosed && auction.bids.isNotEmpty) {
              // Sort bids to find the highest bid
              auction.bids.sort((a, b) => b.bidAmount.compareTo(a.bidAmount));
              winnerBid = auction.bids.last;
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  if (auction.imagesUrl.isNotEmpty) ...[
                    CarouselSlider(
                      items: auction.imagesUrl.map((imageUrl) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                      image: NetworkImage(imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.fullscreen,
                                      color: ColorResources.primaryMaterial,
                                      size: Dimensions.iconSizeExtraLarge,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              FullscreenImageGallery(
                                            images: auction.imagesUrl,
                                            initialIndex: _currentIndex,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 250.0,
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        scrollPhysics: auction.imagesUrl.length == 1
                            ? const NeverScrollableScrollPhysics()
                            : const AlwaysScrollableScrollPhysics(),
                        viewportFraction: 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                      carouselController: _carouselController,
                    ),
                    const SizedBox(height: 10),
                    AnimatedSmoothIndicator(
                      activeIndex: _currentIndex,
                      count: auction.imagesUrl.length,
                      effect: const ExpandingDotsEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: Colors.blue,
                        dotColor: Colors.grey,
                      ),
                      onDotClicked: (index) {
                        _carouselController.animateToPage(index);
                      },
                    ),
                  ],
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Container(
                    decoration: const BoxDecoration(
                      color: ColorResources.primaryMaterial,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeLarge),
                          child: Column(
                            children: [
                              const Row(),
                              Text(
                                auction.itemName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                auction.itemDescription,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        AuctionDataWidget(auction: auction),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeDefault),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.online_prediction,
                                    color: Colors.lightGreen,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    getTranslated('live_auction', context) ??
                                        '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                '${auction.bids.length} ${getTranslated('bids', context) ?? ''}',
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              auction.bids.length > 4 ? 4 : auction.bids.length,
                          itemBuilder: (context, index) {
                            auction.bids
                                .sort((a, b) => b.bidTime.compareTo(a.bidTime));
                            final bid = auction.bids[index];
                            return ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              leading: Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 1.5,
                                  ),
                                ),
                                child: CircleAvatar(
                                  foregroundColor: Colors.grey,
                                  backgroundImage: NetworkImage(
                                    bid.user.imageFullUrl?.path ??
                                        "https://firebasestorage.googleapis.com/v0/b/elmazraa-24ac0.appspot.com/o/mazrrattilogo.png?alt=media&token=8489de5a-7151-4875-8e66-1ae19b87b207",
                                  ),
                                ),
                              ),
                              title: Text(
                                "${bid.user.fName ?? ""} ${bid.user.lName ?? ""}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('SAR ${bid.bidAmount}' ?? ''),
                                ],
                              ),
                              subtitle: Text(
                                formatBidTime(
                                  bid.bidTime,
                                  locale: Provider.of<LocalizationController>(
                                              context,
                                              listen: false)
                                          .isLtr
                                      ? 'en'
                                      : 'ar',
                                ),
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          },
                        ),
                        if (auction.bids.length > 4)
                          TextButton(
                            onPressed: () {
                              // Navigate to another screen to show all bids
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllBidsScreen(
                                    auctionId: auction.auctionId,
                                  ),
                                ),
                              );
                            },
                            child:
                                Text(getTranslated("VIEW_ALL", context) ?? ""),
                          ),
                        if (isAuctionClosed && winnerBid != null) ...[
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: ColorResources.primaryMaterial,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              children: [
                                Text(
                                    getTranslated('auction_ended', context) ??
                                        "",
                                    style: titleHeader.copyWith(
                                        color: ColorResources.white)),
                                const SizedBox(height: 10),
                                Text(
                                    '${getTranslated('winner', context)}: ${winnerBid.user.fName ?? ""} ${winnerBid.user.lName ?? ""}',
                                    style: titleRegular.copyWith(
                                        color: ColorResources.white)),
                                Text(
                                    '${getTranslated('final_bid', context)}: SAR ${auction.currentBid}',
                                    style: titleRegular.copyWith(
                                        color: ColorResources.white)),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    child: Column(
                      children: [
                        CustomButton(
                          buttonText: getTranslated("place_a_new_bid", context),
                          backgroundColor: (auction.calculateAuctionState() ==
                                      "closed" ||
                                  auction.calculateAuctionState() == "Upcoming")
                              ? Colors.grey
                              : ColorResources.primaryMaterial,
                          onTap: () {
                            if (auction.calculateAuctionState() == "closed" ||
                                auction.calculateAuctionState() == "Upcoming") {
                              return;
                            }
                            _showAddBidDialog(context, auction);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _showBidChangeDialog(BuildContext context, double newBid) {
    bool isClosed = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dialog = showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(
              child: Text(getTranslated("new_bid_added", context) ?? "")),
          content: Text(
            '${getTranslated('current_bid', context)}: ${newBid.toStringAsFixed(2)}',
          ),
          actions: [
            CustomButton(
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              buttonText: getTranslated("ok", context) ?? "",
            ),
          ],
        ),
      );

      // Automatically close dialog after 1.5 seconds
      // Future.delayed(const Duration(seconds: 2), () {
      //   if (!isClosed) {
      //     Navigator.of(context).pop();
      //     isClosed = true;
      //   }
      // });
    });
  }

  void _showAddBidDialog(BuildContext context, Auction auction) {
    final formKey = GlobalKey<FormState>();
    double bidAmount = 0.0;
    var bidAmountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StreamBuilder<List<Auction>>(
            stream: Provider.of<AddAuctionController>(context, listen: false)
                .getACustomAuctionsStream(context, widget.customDocId),
            builder: (context, snapshot) {
              // if (snapshot.connectionState == ConnectionState.waiting) {
              //   return const Center(child: CircularProgressIndicator());
              // }
              Auction newauction = snapshot.data!.first;
              return AlertDialog(
                title: Center(
                    child: Column(
                  children: [
                    Text(getTranslated("place_a_new_bid", context) ?? ""),
                    Text(
                        "${getTranslated("Minimum_bid_amount_is_SAR", context)} ${newauction.bidIncrement + newauction.currentBid}",
                        style: const TextStyle(fontSize: 14)),
                  ],
                )),
                content: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextFieldWidget(
                        labelText: getTranslated("bid_amount", context) ?? "",
                        hintText:
                            getTranslated("enter_bid_amount", context) ?? "",
                        maxLines: 1,
                        inputType: const TextInputType.numberWithOptions(
                            decimal: true),
                        controller: bidAmountController,
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return getTranslated("enter_bid_amount", context);
                          } else if (double.parse(p0) <
                              newauction.bidIncrement + newauction.currentBid) {
                            return "${getTranslated('bid_amount_must_be_more_than', context)} ${newauction.bidIncrement + newauction.currentBid}";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  CustomButton(
                    onTap: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        Bid bid = Bid(
                          bidAmount:
                              double.parse(bidAmountController.text) ?? 0.0,
                          currentbid: newauction.currentBid +
                                  double.parse(bidAmountController.text) ??
                              0.0,
                          userId: context
                              .read<ProfileController>()
                              .userInfoModel!
                              .id
                              .toString(),
                          bidTime: DateTime.now(),
                          bidId: UniqueKey().toString(),
                          user: await context
                              .read<ProfileController>()
                              .getCurrentUserInfo(context),
                        );
                        newauction.bids.add(bid);
                        newauction.currentBid =
                            double.parse(bidAmountController.text) ?? 0.0;

                        context.read<AddAuctionController>().updateAuction(
                            auctionId: newauction.auctionId,
                            context: context,
                            auction: newauction);
                        Navigator.of(context).pop(); // Close the dialog
                        log(context
                            .read<ProfileController>()
                            .userInfoModel!
                            .toJson()
                            .toString());
                      }
                    },
                    buttonText: getTranslated("bid_now", context) ?? "",
                  ),
                  CustomButton(
                    onTap: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    buttonText: getTranslated("CANCEL", context) ?? "",
                  ),
                ],
              );
            });
      },
    );
  }
}
