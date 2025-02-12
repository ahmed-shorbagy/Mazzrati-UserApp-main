import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/widgets/auction_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/domain/models/auction_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/auction_widget.dart';

class HorizontalAuctionListView extends StatelessWidget {
  final List<Auction> auctions;

  const HorizontalAuctionListView({super.key, required this.auctions});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: PageView.builder(
        itemCount: auctions.length,
        controller: PageController(
            viewportFraction: 1), // Adjusts the size of the items
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: PageController(),
            builder: (context, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ActiveAuctionWidget(auction: auctions[index]),
              );
            },
          );
        },
      ),
    );
  }
}
