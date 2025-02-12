import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/domain/models/profile_model.dart';

class Auction {
  String auctionId;
  String itemName;
  String itemDescription;
  double startingBid;
  double currentBid;
  double bidIncrement;
  String category;
  int categoryIndex;
  DateTime createdAt;
  DateTime startTime;
  DateTime endTime;
  List<String> imagesUrl;
  String auctionStatus;
  List<Bid> bids; // List of bids associated with the auction

  Auction({
    required this.auctionId,
    required this.itemName,
    required this.itemDescription,
    required this.startingBid,
    required this.currentBid,
    required this.category,
    required this.categoryIndex,
    required this.createdAt,
    required this.bidIncrement,
    required this.startTime,
    required this.endTime,
    required this.imagesUrl,
    required this.auctionStatus,
    required this.bids,
  });

  // Convert a Firestore document to an Auction object
  factory Auction.fromFirestore(Map<String, dynamic> data) {
    var bidList = (data['bids'] as List<dynamic>)
        .map((bid) => Bid.fromFirestore(bid as Map<String, dynamic>))
        .toList();

    // Ensure imagesUrl is a list of strings
    var imagesUrlList = List<String>.from(data['imagesUrl'] ?? []);

    return Auction(
      auctionId: data['auctionId'],
      itemName: data['itemName'],
      itemDescription: data['itemDescription'],
      startingBid: (data['startingBid'] as num).toDouble(),
      currentBid: (data['currentBid'] as num).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      category: data['category'] ?? "اعلاف",
      categoryIndex: data['categoryIndex'] ?? 1,
      bidIncrement: (data['bidIncrement'] as num).toDouble(),
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      imagesUrl: imagesUrlList,
      auctionStatus: data['auctionStatus'],
      bids: bidList,
    );
  }

  // Convert an Auction object to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'imagesUrl': imagesUrl,
      'auctionId': auctionId,
      'itemName': itemName,
      'itemDescription': itemDescription,
      'startingBid': startingBid,
      'currentBid': currentBid,
      'bidIncrement': bidIncrement,
      'startTime': startTime,
      'endTime': endTime,
      'auctionStatus': auctionStatus,
      'bids': bids.map((bid) => bid.toFirestore()).toList(),
    };
  }

  // Calculate auction state based on current time
  String calculateAuctionState() {
    final now = DateTime.now();

    if (now.isBefore(startTime)) {
      return "Upcoming";
    } else if (now.isAfter(endTime)) {
      return "closed";
    } else {
      return "active";
    }
  }
}

class Bid {
  String bidId;
  String userId;
  double currentbid;
  ProfileModel user;
  double bidAmount;
  DateTime bidTime;

  Bid({
    required this.bidId,
    required this.userId,
    required this.user,
    required this.currentbid,
    required this.bidAmount,
    required this.bidTime,
  });

  // Convert a Firestore document to a Bid object
  factory Bid.fromFirestore(Map<String, dynamic> data) {
    return Bid(
      user: ProfileModel.fromJson(data['customer'] as Map<String, dynamic>),
      bidId: data['bidId'],
      userId: data['userId'],
      currentbid: (data['currentBid'] as num).toDouble(),
      bidAmount: (data['bidAmount'] as num).toDouble(),
      bidTime: (data['bidTime'] as Timestamp).toDate(),
    );
  }

  // Convert a Bid object to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'bidId': bidId,
      'customer': user.toJson(),
      'userId': userId,
      'currentBid': currentbid,
      'bidAmount': bidAmount,
      'bidTime': bidTime,
    };
  }
}
