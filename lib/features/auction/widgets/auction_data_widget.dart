import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/domain/models/auction_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/widgets/auction_timer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:provider/provider.dart';

class AuctionDataWidget extends StatelessWidget {
  const AuctionDataWidget({
    super.key,
    required this.auction,
  });

  final Auction auction;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
        builder: (context, themeController, child) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: themeController.darkTheme ? Colors.black : Colors.white,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: themeController.darkTheme
                    ? Theme.of(context).cardColor
                    : Theme.of(context)
                        .primaryColor
                        .withOpacity(.1), // Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getTranslated('starting_price', context) ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'SAR ${auction.startingBid}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                        child: VerticalDivider(
                          color: Colors.grey,
                          thickness: 3,
                          indent: 1,
                          endIndent: 1,
                          width: 10,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getTranslated('current_bid', context) ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'SAR ${auction.currentBid}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "${getTranslated('bid_amount', context) ?? ''} : ${auction.bidIncrement} ",
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "${getTranslated('category', context) ?? ''} : ${auction.category} ",
                  ),
                  const SizedBox(height: 20),
                  AuctionTimer(auction: auction),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }
}
