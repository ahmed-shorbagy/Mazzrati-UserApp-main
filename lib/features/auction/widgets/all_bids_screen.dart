import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_app_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/controllers/add_auction_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/domain/models/auction_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AllBidsScreen extends StatelessWidget {
  final String auctionId;

  const AllBidsScreen({super.key, required this.auctionId});

  String formatBidTime(DateTime dateTime, {String locale = 'en'}) {
    if (locale == 'en') {
      return DateFormat('dd/MM/yyyy hh:mm a', locale).format(dateTime);
    }
    return DateFormat('yyyy/MM/dd hh:mm a', locale).format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated("all_bids", context) ?? ""),
      body: StreamBuilder<List<Bid>>(
        stream: Provider.of<AddAuctionController>(context, listen: false)
            .getBidsStream(context, auctionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final bids = snapshot.data ?? [];

          return ListView.separated(
            separatorBuilder: (context, index) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(height: 0),
              );
            },
            itemCount: bids.length,
            itemBuilder: (context, index) {
              final bid = bids[index];
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('SAR ${bid.bidAmount}' ?? ''),
                    Text(
                      '${getTranslated('current_bid', context)}: ${bid.currentbid}',
                      style:
                          robotoRegular.copyWith(color: ColorResources.black),
                    ),
                  ],
                ),
                subtitle: Text(
                  formatBidTime(
                    bid.bidTime,
                    locale: Provider.of<LocalizationController>(context,
                                listen: false)
                            .isLtr
                        ? 'en'
                        : 'ar',
                  ),
                  style: const TextStyle(fontSize: 12),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
