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

  bool loaded = false;

  final List<String> _pages = ["days", "weeks", "months", "years"];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    url = widget.box.get("selectedUrl", defaultValue: "");
    _loadCharts();
  }

  Future<void> _loadCharts() async {
    try {

      var data = await PulseService().fetchPulse(_pages[_selectedIndex], url);
      setState(() {
        pulse = data;
        loaded = true;
      });
    } catch (e) {
      if (mounted) {
        AppSnackBar(message: e.toString()).build(context);
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      loaded = false;
    });
    _loadCharts();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: MainAppBar(input: "Pulse", box: widget.box),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadCharts, // This is where the refresh action happens
          child: CustomScrollView(
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
                      return SmallPulseData(pulse: pulse[index], theme: theme);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
