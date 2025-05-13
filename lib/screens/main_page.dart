import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:maloja_mobile/screens/settings_page.dart';
import 'package:maloja_mobile/widgets/chart_widgets.dart';
import 'package:maloja_mobile/widgets/main_app_bar.dart';

import '../services/pulse_service.dart';
import '../utils/page_router.dart';
import '../widgets/app_snackbar.dart';
import 'chart_page.dart';

class MainPage extends StatefulWidget {
  final Box box;

  const MainPage({super.key, required this.box});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late List<Pulse> pulse = [];
  late String url;

  bool hasMorePages = true;
  bool loaded = false;
  bool isLoadingMore = false;
  int currentPage = 0;

  final List<String> _pages = ["days", "weeks", "months", "years"];
  int _selectedIndex = 2;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    url = widget.box.get("selectedUrl", defaultValue: "");
    _loadCharts();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadCharts({bool loadMore = false}) async {
    if (isLoadingMore || (!hasMorePages && loadMore)) return;

    setState(() {
      if (!loadMore) {
        hasMorePages = true;
        loaded = false;
        currentPage = 0;
      }
      isLoadingMore = true;
    });

    try {
      final data = await PulseService().fetchPulse(
        _pages[_selectedIndex],
        url,
        page: currentPage,
      );

      setState(() {
        if (loadMore) {
          print("Add");
          print(currentPage);

          pulse.addAll(data);
          currentPage++;
        } else {
          print("Set");
          print(currentPage);

          pulse = data;
          loaded = true;
          currentPage = 1;
        }

        // If empty, stop trying to fetch more pages
        if (data.isEmpty) {
          hasMorePages = false;
        }
      });
    } catch (e) {
      if (mounted) {
        AppSnackBar(message: e.toString()).build(context);
      }
    } finally {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _loadCharts();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300 &&
        !isLoadingMore &&
        hasMorePages) {
      _loadCharts(loadMore: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: MainAppBar(input: "Pulse", box: widget.box),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _loadCharts(),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: TimeframeSelector(
                  pages: _pages,
                  selectedIndex: _selectedIndex,
                  onTap: _onItemTapped,
                ),
              ),
              if (!loaded)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: pulse.length,
                        (sliverContext, index) {
                          final isLast = index == pulse.length - 1;

                          return Column(
                            children: [
                              SmallPulseData(pulse: pulse[index], theme: theme),
                              if (isLast) const SizedBox(height: 50),
                            ],
                          );

                    },
                  ),
                ),
              if (isLoadingMore)
                SliverToBoxAdapter(
                  child: Center(child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CircularProgressIndicator(),
                  )),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
