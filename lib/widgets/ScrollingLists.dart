import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../constants/AppImages.dart';

class ScrollingList extends StatefulWidget {
  final int initialIndex;
  const ScrollingList({Key? key, required this.initialIndex}) : super(key: key);

  @override
  State<ScrollingList> createState() => _ScrollingListState();
}

class _ScrollingListState extends State<ScrollingList> {
  late ScrollController _controller;
  late Timer _timer;
  final int _multiplier = 1000;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startInfiniteScrolling();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startInfiniteScrolling() {
    const duration = Duration(milliseconds: 30);
    const double step = 1.0;

    _timer = Timer.periodic(duration, (timer) {
      if (_controller.hasClients) {
        final currentOffset = _controller.offset;
        final maxOffset = _controller.position.maxScrollExtent;

        final nextOffset = currentOffset + step;
        if (nextOffset >= maxOffset) {
          _controller.jumpTo(currentOffset - MediaQuery.of(context).size.height);
        } else {
          _controller.jumpTo(nextOffset);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Transform.rotate(
      angle: 1.92 * pi,
      child: SizedBox(
        height: height * 0.65,
        width: width * 0.6,
        child: ListView.builder(
          controller: _controller,
          itemCount: contentImages.length * _multiplier,
          itemBuilder: (context, index) {
            final imageIndex = (index + widget.initialIndex) % contentImages.length;
            return Container(
              margin: EdgeInsets.only(top: 10, left: 8, right: 8),
              height: height * 0.4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: contentImages[imageIndex],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}