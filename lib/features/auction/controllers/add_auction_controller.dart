import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_snackbar_widget.dart';

import 'package:flutter_sixvalley_ecommerce/features/auction/domain/models/auction_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/widgets/filter_widget.dart';

import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';

class AddAuctionController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _selectedCategory;
  SortingOption _selectedSortingOption = SortingOption.Newest;

  String? get selectedCategory => _selectedCategory;
  set selectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  SortingOption get selectedSortingOption => _selectedSortingOption;

  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSortingOption(SortingOption option) {
    _selectedSortingOption = option;
    notifyListeners();
  }

  // Future<String> _uploadImage(File imageFile) async {
  //   log("Starting image upload");
  //   try {
  //     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //     Reference storageRef = _storage.ref().child('auction_images/$fileName');
  //     UploadTask uploadTask = storageRef.putFile(imageFile);

  //     // Track the progress of the upload
  //     uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
  //       log('Task state: ${snapshot.state}'); // e.g. running, paused, success
  //       log('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
  //     });

  //     TaskSnapshot taskSnapshot = await uploadTask;
  //     String downloadUrl = await taskSnapshot.ref.getDownloadURL();
  //     log("Ending image upload");
  //     return downloadUrl;
  //   } catch (e) {
  //     log("Error in image upload: $e");
  //     throw Exception('Image upload failed: $e');
  //   }
  // }

  // Future<void> createAuction({
  //   required String productName,
  //   required String productDescription,
  //   required double startingBid,
  //   required double bidIncrement,
  //   required DateTime startTime,
  //   required DateTime endTime,
  //   required List<File> images,
  //   required BuildContext context,
  // }) async {
  //   try {
  //     CollectionReference auctions = _firestore.collection('MazzrattiAuctions');
  //     String auctionId = auctions.doc().id;

  //     // Asynchronously upload images
  //     List<Future<String>> uploadFutures =
  //         images.map((image) => _uploadImage(image)).toList();
  //     List<String> imageUrls = await Future.wait(uploadFutures);
  //     ProfileInfoModel? user =
  //         Provider.of<ProfileController>(context, listen: false).userInfoModel;

  //     Map<String, dynamic> auctionData = {
  //       'ownerId': user?.id,
  //       'auctionId': auctionId,
  //       'itemName': productName,
  //       'itemDescription': productDescription,
  //       'startingBid': startingBid,
  //       'currentBid': startingBid,
  //       'bidIncrement': bidIncrement,
  //       'startTime': Timestamp.fromDate(startTime),
  //       'endTime': Timestamp.fromDate(endTime),
  //       'imagesUrl': imageUrls,
  //       'auctionStatus': 'active',
  //       'bids': [],
  //     };

  //     await auctions.doc(auctionId).set(auctionData);
  //     showCustomSnackBarWidget(
  //         getTranslated('auction_created_successfully', context), context,
  //         isError: false);
  //     Navigator.pop(context);
  //     notifyListeners();
  //   } catch (error) {
  //     showCustomSnackBarWidget(
  //         getTranslated('error_creating_auction', context), context,
  //         sanckBarType: SnackBarType.warning, isError: true);
  //     throw Exception('Error creating auction: $error');
  //   }
  // }

  Future<void> updateAuction(
      {required String auctionId,
      Auction? auction,
      required BuildContext context}) async {
    try {
      DocumentReference auctionDoc =
          _firestore.collection('MazzrattiAuctions').doc(auctionId);

      // Prepare the data to be updated
      Map<String, dynamic> updateData = auction!.toFirestore();
      log("Update data: $updateData");

      await auctionDoc.update(updateData);
      showCustomSnackBarWidget(
          getTranslated('auction_updated_successfully', context), context,
          isError: false);

      notifyListeners();
    } catch (error) {
      showCustomSnackBarWidget(
        getTranslated('error_updating_auction', context),
        context,
        isError: true,
        sanckBarType: SnackBarType.warning,
      );
      throw Exception('Error updating auction: $error');
    }
  }

  Future<void> deleteAuction(String auctionId, BuildContext context) async {
    try {
      DocumentReference auctionDoc =
          _firestore.collection('MazzrattiAuctions').doc(auctionId);

      // Fetch the auction to get image URLs
      DocumentSnapshot auctionSnapshot = await auctionDoc.get();
      if (auctionSnapshot.exists) {
        Map<String, dynamic>? auctionData =
            auctionSnapshot.data() as Map<String, dynamic>?;
        List<dynamic>? imageUrlsDynamic =
            auctionData?['imagesUrl'] as List<dynamic>?;

        // Convert List<dynamic> to List<String> if needed
        List<String> imageUrls =
            imageUrlsDynamic?.map((e) => e.toString()).toList() ?? [];

        // Delete images from Firebase Storage
      }

      // Delete the auction document
      await auctionDoc.delete();
      showCustomSnackBarWidget(
          getTranslated('auction_deleted_successfully', context), context,
          isError: false);

      notifyListeners();
    } catch (error) {
      showCustomSnackBarWidget(
          getTranslated('error_deleting_auction', context), context,
          sanckBarType: SnackBarType.warning, isError: true);
      throw Exception('Error deleting auction: $error');
    }
  }

  Stream<List<Auction>> getAllAuctionsStream(BuildContext context) {
    try {
      CollectionReference auctions = _firestore.collection('MazzrattiAuctions');

      // Stream to get all auctions
      return auctions.snapshots().map((querySnapshot) => querySnapshot.docs
          .map((doc) =>
              Auction.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList());
    } catch (error) {
      log("Error in getting all auctions: $error");
      throw Exception('Error fetching auctions: $error');
    }
  }

  // Stream<List<Auction>> getAllActiveAuctionsStream(
  //     BuildContext context, String status) {
  //   try {
  //     CollectionReference auctions = _firestore.collection('MazzrattiAuctions');

  //     // Stream to get auctions where ownerId equals user's ID
  //     return auctions.snapshots().map((querySnapshot) {
  //       return querySnapshot.docs
  //           .map((doc) {
  //             Auction auction =
  //                 Auction.fromFirestore(doc.data() as Map<String, dynamic>);
  //             auction.auctionStatus = auction.calculateAuctionState();
  //             return auction;
  //           })
  //           .where((auction) =>
  //               auction.auctionStatus == status) // Filter by auctionStatus
  //           .toList();
  //     });
  //   } catch (error) {
  //     log("Error in getting all auctions: $error");
  //     throw Exception('Error fetching auctions: $error');
  //   }
  // }
/*************  ✨ Codeium Command ⭐  *************/
  /// Stream to get all active auctions where auctionStatus equals [status].
  ///
  /// Optional parameters:
  /// - [category]: Filter auctions by category.
  /// - [sortByNewest]: Sort the auctions by startTime in descending order (newest first).
  ///   If false, the auctions will be sorted in ascending order (oldest first).
  /// ****  c982a1f8-99dc-4f60-b29d-641822eb922f  ******
  Stream<List<Auction>> getAllActiveAuctionsStream(
      BuildContext context, String status,
      {String? category, bool sortByNewest = false}) {
    try {
      CollectionReference auctions = _firestore.collection('MazzrattiAuctions');

      // Stream to get auctions where ownerId equals user's ID
      return auctions.snapshots().map((querySnapshot) {
        List<Auction> filteredAuctions = querySnapshot.docs
            .map((doc) {
              Auction auction =
                  Auction.fromFirestore(doc.data() as Map<String, dynamic>);
              auction.auctionStatus = auction.calculateAuctionState();
              return auction;
            })
            .where((auction) =>
                auction.auctionStatus == status) // Filter by auctionStatus
            .toList();

        // Filter by category if provided
        if (category != null) {
          filteredAuctions = filteredAuctions
              .where((auction) => auction.category == category)
              .toList();
        }

        // Sort the auctions based on startTime
        filteredAuctions.sort((a, b) {
          if (sortByNewest) {
            return b.startTime.compareTo(a.startTime); // Newest to oldest
          } else {
            return a.startTime.compareTo(b.startTime); // Oldest to newest
          }
        });

        return filteredAuctions;
      });
    } catch (error) {
      log("Error in getting all auctions: $error");
      throw Exception('Error fetching auctions: $error');
    }
  }

  Stream<List<Auction>> getAllEndedAuctionsStream(
      BuildContext context, String status,
      {String? category, bool sortByNewest = true}) {
    try {
      CollectionReference auctions = _firestore.collection('MazzrattiAuctions');

      return auctions.snapshots().map((querySnapshot) {
        List<Auction> filteredAuctions = querySnapshot.docs
            .map((doc) {
              Auction auction =
                  Auction.fromFirestore(doc.data() as Map<String, dynamic>);
              auction.auctionStatus = auction.calculateAuctionState();
              return auction;
            })
            .where((auction) => auction.auctionStatus == status)
            .toList();

        // Filter by category if provided
        if (category != null) {
          filteredAuctions = filteredAuctions
              .where((auction) => auction.category == category)
              .toList();
        }

        // Sort the auctions based on startTime
        filteredAuctions.sort((a, b) {
          if (sortByNewest) {
            return b.startTime.compareTo(a.startTime); // Newest to oldest
          } else {
            return a.startTime.compareTo(b.startTime); // Oldest to newest
          }
        });

        return filteredAuctions;
      });
    } catch (error) {
      log("Error in getting all auctions: $error");
      throw Exception('Error fetching auctions: $error');
    }
  }

  Stream<List<Auction>> getAllUpcomingAuctionsStream(
      BuildContext context, String status,
      {String? category, bool sortByNewest = true}) {
    try {
      CollectionReference auctions = _firestore.collection('MazzrattiAuctions');

      return auctions.snapshots().map((querySnapshot) {
        List<Auction> filteredAuctions = querySnapshot.docs
            .map((doc) {
              Auction auction =
                  Auction.fromFirestore(doc.data() as Map<String, dynamic>);
              auction.auctionStatus = auction.calculateAuctionState();
              return auction;
            })
            .where((auction) => auction.auctionStatus == status)
            .toList();

        // Filter by category if provided
        if (category != null) {
          filteredAuctions = filteredAuctions
              .where((auction) => auction.category == category)
              .toList();
        }

        // Sort the auctions based on startTime
        filteredAuctions.sort((a, b) {
          if (sortByNewest) {
            return b.startTime.compareTo(a.startTime); // Newest to oldest
          } else {
            return a.startTime.compareTo(b.startTime); // Oldest to newest
          }
        });

        return filteredAuctions;
      });
    } catch (error) {
      log("Error in getting all auctions: $error");
      throw Exception('Error fetching auctions: $error');
    }
  }
  // Stream<List<Auction>> getAllEndedAuctionsStream(
  //     BuildContext context, String status) {
  //   try {
  //     CollectionReference auctions = _firestore.collection('MazzrattiAuctions');

  //     // Stream to get auctions where ownerId equals user's ID
  //     return auctions.snapshots().map((querySnapshot) => querySnapshot.docs
  //         .map((doc) {
  //           Auction auction =
  //               Auction.fromFirestore(doc.data() as Map<String, dynamic>);
  //           auction.auctionStatus = auction.calculateAuctionState();
  //           return auction;
  //         })
  //         .where((auction) => auction.auctionStatus == status)
  //         .toList());
  //   } catch (error) {
  //     log("Error in getting all auctions: $error");
  //     throw Exception('Error fetching auctions: $error');
  //   }
  // }

  // Stream<List<Auction>> getAllUpcomingAuctionsStream(
  //     BuildContext context, String status) {
  //   try {
  //     CollectionReference auctions = _firestore.collection('MazzrattiAuctions');

  //     // Stream to get auctions where ownerId equals user's ID
  //     return auctions.snapshots().map((querySnapshot) => querySnapshot.docs
  //         .map((doc) {
  //           Auction auction =
  //               Auction.fromFirestore(doc.data() as Map<String, dynamic>);
  //           auction.auctionStatus = auction.calculateAuctionState();
  //           return auction;
  //         })
  //         .where((auction) => auction.auctionStatus == status)
  //         .toList());
  //   } catch (error) {
  //     log("Error in getting all auctions: $error");
  //     throw Exception('Error fetching auctions: $error');
  //   }
  // }

  Stream<List<Auction>> getACustomAuctionsStream(
      BuildContext context, String customDocId) {
    try {
      CollectionReference auctions = _firestore.collection('MazzrattiAuctions');

      // Stream to get auctions with a custom document ID
      return auctions.doc(customDocId).snapshots().map((docSnapshot) {
        if (docSnapshot.exists) {
          return [
            Auction.fromFirestore(docSnapshot.data() as Map<String, dynamic>)
          ];
        } else {
          return []; // Return an empty list if the document doesn't exist
        }
      });
    } catch (error) {
      log("Error in getting auctions with custom doc ID: $error");
      throw Exception('Error fetching auctions with custom doc ID: $error');
    }
  }

  Stream<List<Bid>> getBidsStream(BuildContext context, String auctionId) {
    try {
      CollectionReference auctions = _firestore.collection('MazzrattiAuctions');

      // Stream to get the auction document with a specific ID
      return auctions.doc(auctionId).snapshots().map((docSnapshot) {
        if (docSnapshot.exists) {
          final auction =
              Auction.fromFirestore(docSnapshot.data() as Map<String, dynamic>);
          return auction.bids; // Return the list of bids from the auction
        } else {
          return []; // Return an empty list if the document doesn't exist
        }
      });
    } catch (error) {
      log("Error getting bids for auction: $error");
      throw Exception('Error fetching bids for auction: $error');
    }
  }
}
