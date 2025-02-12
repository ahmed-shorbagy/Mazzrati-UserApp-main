import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/auction/domain/models/auction_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:provider/provider.dart';

class AuctionTimer extends StatefulWidget {
  final Auction auction;

  const AuctionTimer({super.key, required this.auction});

  @override
  _AuctionTimerState createState() => _AuctionTimerState();
}

class _AuctionTimerState extends State<AuctionTimer> {
  late Timer _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String getAuctionDuration(BuildContext context) {
    final bool isLtr =
        Provider.of<LocalizationController>(context, listen: false).isLtr;

    if (_currentTime.isBefore(widget.auction.startTime)) {
      // Auction has not started yet
      final Duration timeToStart =
          widget.auction.startTime.difference(_currentTime);

      final int days = timeToStart.inDays;
      final int hours = timeToStart.inHours % 24;
      final int minutes = timeToStart.inMinutes % 60;
      final int seconds = timeToStart.inSeconds % 60;

      if (isLtr) {
        return 'Upcoming: $days days, $hours hours, $minutes minutes $seconds seconds';
      } else {
        return 'قادم: $days يوم, $hours ساعة, $minutes دقيقة, $seconds ثانية';
      }
    } else {
      // Auction has started, calculate remaining time until it ends
      final Duration duration = widget.auction.endTime.difference(_currentTime);

      final int days = duration.inDays;
      final int hours = duration.inHours % 24;
      final int minutes = duration.inMinutes % 60;
      final int seconds = duration.inSeconds % 60;

      if (duration.isNegative) {
        return isLtr ? 'Auction ended' : 'انتهى المزاد';
      }

      if (isLtr) {
        return '$days days, $hours hours, $minutes minutes $seconds seconds';
      } else {
        return '$days يوم, $hours ساعة, $minutes دقيقة, $seconds ثانية';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      getAuctionDuration(context),
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
