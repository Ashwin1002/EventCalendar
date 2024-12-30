import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_calendar/core/core.dart';
import 'package:google_calendar/src/schedule/widgets/widgets.dart';

DateTime firstDay = DateTime(2020);
DateTime lastDay = DateTime(DateTime.now().year + 5);
DateTimeRange dateRange = DateTimeRange(start: firstDay, end: lastDay);

const _appbarHeight = 52.0;
const _calendarHeight = 300.0;
const _maxAppbarHeight = _appbarHeight + _calendarHeight;
const _expandThreshold = 0.5;

class CalendarAppbar extends StatefulWidget {
  const CalendarAppbar({super.key});

  @override
  State<CalendarAppbar> createState() => _CalendarAppbarState();
}

class _CalendarAppbarState extends State<CalendarAppbar>
    with SingleTickerProviderStateMixin {
  final _isExpandedNotifier = ValueNotifier<bool>(false);
  late final ScrollController _scrollController;
  bool _isAnimating = false;
  double _lastScrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
  }

  void _handleScroll() {
    log('is scrolling');
    if (_isAnimating) return;

    final scrollOffset = _scrollController.offset;
    final delta = scrollOffset - _lastScrollOffset; // Detect scroll direction
    const expandThresholdPoint = _calendarHeight * _expandThreshold;

    log('Scroll stopped at: $scrollOffset');
    log('Threshold: $expandThresholdPoint');
    log('Delta: $delta'); // Log the scroll direction

    if (delta < 0 && scrollOffset < expandThresholdPoint) {
      // Scrolling upwards and below threshold
      log('Should expand');
      _snapToPosition(0);
    } else if (delta > 0 && scrollOffset >= expandThresholdPoint) {
      // Scrolling downwards and above threshold
      log('Should collapse');
      _snapToPosition(_calendarHeight);
    }

    _lastScrollOffset = scrollOffset;
  }

  Future<void> _snapToPosition(double position) async {
    if (_isAnimating) return;
    _isAnimating = true;

    try {
      _isExpandedNotifier.value = position == 0;

      if (_scrollController.hasClients) {
        await _scrollController.animateTo(
          position,
          duration: 300.ms,
          curve: Curves.easeOutCubic,
        );
      }
    } finally {
      _isAnimating = false;
    }
  }

  void _handleHeaderTap() {
    if (_isExpandedNotifier.value) {
      _snapToPosition(_calendarHeight);
    } else {
      _snapToPosition(0);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isExpandedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      mobile: (context) => NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification) {
            _handleScroll();
          }
          return true;
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: AppBarDelegate(
                isExpandedNotifier: _isExpandedNotifier,
                onHeaderTap: _handleHeaderTap,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => const SizedBox(
                  height: 100,
                  child: Placeholder(),
                ),
                childCount: 10,
              ),
            ),
          ],
        ),
      ),
      tablet: (context) => const Placeholder(),
    );
  }
}

class AppBarDelegate extends SliverPersistentHeaderDelegate {
  const AppBarDelegate({
    required ValueNotifier<bool> isExpandedNotifier,
    required VoidCallback onHeaderTap,
  })  : _isExpandedNotifier = isExpandedNotifier,
        _onHeaderTap = onHeaderTap;

  final ValueNotifier<bool> _isExpandedNotifier;
  final VoidCallback _onHeaderTap;

  @override
  double get minExtent => _appbarHeight;

  @override
  double get maxExtent => _maxAppbarHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final scrollPercent = (shrinkOffset / _calendarHeight).clamp(0.0, 1.0);
    final iconRotation = scrollPercent * 0.5;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: _isExpandedNotifier,
            builder: (context, isExpanded, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  InkWell(
                    onTap: _onHeaderTap,
                    child: SizedBox(
                      height: _appbarHeight,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: MonthHeader(
                          key: const ValueKey('month_scrolling_header'),
                          value: 0,
                          range: dateRange,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            size: 24.0,
                          ).animate(target: iconRotation).rotate(),
                        ),
                      ),
                    ),
                  ),
                  // Calendar
                  ClipRect(
                    child: Align(
                      heightFactor: 1.0 - scrollPercent,
                      child: Container(
                        height: _calendarHeight,
                        color: Colors.blueAccent,
                      )
                          .animate(target: isExpanded ? 1 : 0)
                          .fadeIn(duration: 300.ms)
                          .slideY(begin: -0.1, end: 0, duration: 300.ms),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant AppBarDelegate oldDelegate) {
    return oldDelegate._isExpandedNotifier != _isExpandedNotifier ||
        oldDelegate._onHeaderTap != _onHeaderTap;
  }
}
