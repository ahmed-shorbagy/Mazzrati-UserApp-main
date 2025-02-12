import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_loggedin_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/controllers/add_auction_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/domain/models/auction_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/widgets/auction_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/widgets/filter_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:provider/provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/not_loggedin_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/controllers/add_auction_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/domain/models/auction_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/widgets/auction_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:provider/provider.dart';

class AuctionListScreen extends StatefulWidget {
  bool showBackButton;
  AuctionListScreen({super.key, this.showBackButton = false});

  @override
  _AuctionListScreenState createState() => _AuctionListScreenState();
}

class _AuctionListScreenState extends State<AuctionListScreen> {
  String? selectedCategory;
  bool sortByNewest = true;
  bool isGuestMode = false;

  @override
  void initState() {
    super.initState();
    isGuestMode =
        !Provider.of<AuthController>(context, listen: false).isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppBar(
          title: getTranslated("auction_list", context) ?? "",
          isBackButtonExist: widget.showBackButton ? false : true,
          showResetIcon: true,
          reset: CupertinoButton(
            child: const Icon(Icons.filter_alt),
            onPressed: () async {
              showModalBottomSheet<Map<String, dynamic>>(
                context: context,
                builder: (context) => const FilterBottomSheet(),
              );
            },
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100.0),
            child: TabBar(
              labelPadding: const EdgeInsets.only(left: 5, right: 5),
              tabs: [
                Tab(
                    text: getTranslated("active_auction", context) ??
                        "Active Auction"),
                Tab(
                    text: getTranslated("closed_auction", context) ??
                        "Closed Auction"),
                Tab(
                    text: getTranslated("Upcoming_auction", context) ??
                        "Upcoming Auction"),
              ],
            ),
          ),
        ),
        body: isGuestMode
            ? NotLoggedInWidget(
                message: getTranslated("to_view_the_auctions", context))
            : Consumer<AddAuctionController>(
                builder: (context, controller, child) {
                  return TabBarView(
                    children: [
                      AuctionListTab(
                        key: ValueKey('$selectedCategory-$sortByNewest-active'),
                        controller: controller,
                        stream: controller.getAllActiveAuctionsStream(
                          context,
                          'active',
                          category: controller.selectedCategory,
                          sortByNewest: controller.selectedSortingOption ==
                                  SortingOption.Newest
                              ? true
                              : false,
                        ),
                      ),
                      AuctionListTab(
                        key: ValueKey('$selectedCategory-$sortByNewest-closed'),
                        controller: controller,
                        stream: controller.getAllEndedAuctionsStream(
                          context,
                          'closed',
                          category: controller.selectedCategory,
                          sortByNewest: controller.selectedSortingOption ==
                                  SortingOption.Newest
                              ? true
                              : false,
                        ),
                      ),
                      AuctionListTab(
                        key: ValueKey(
                            '$selectedCategory-$sortByNewest-upcoming'),
                        controller: controller,
                        stream: controller.getAllUpcomingAuctionsStream(
                          context,
                          'Upcoming',
                          category: controller.selectedCategory,
                          sortByNewest: controller.selectedSortingOption ==
                                  SortingOption.Newest
                              ? true
                              : false,
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}

class AuctionListTab extends StatelessWidget {
  final AddAuctionController controller;
  final Stream<List<Auction>>? stream;

  const AuctionListTab({
    super.key,
    required this.controller,
    required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Auction>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No auctions available'));
        } else {
          List<Auction> auctions = snapshot.data!;
          return ListView.builder(
            itemCount: auctions.length,
            itemBuilder: (context, index) {
              return AuctionWidget(auction: auctions[index]);
            },
          );
        }
      },
    );
  }
}
