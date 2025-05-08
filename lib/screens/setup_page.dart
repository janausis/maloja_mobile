import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import services package
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:maloja_mobile/widgets/app_snackbar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../widgets/loading_button.dart';
import '../services/setup_service.dart';
import '../widgets/status_bar.dart';
import '../widgets/status_bar_with_bottom_nav.dart';
import 'main_page.dart';

class SetupPage extends StatefulWidget {
  final Box box;
  const SetupPage({super.key, required this.box});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  String _appVersion = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = 'v${info.version}';
    });
  }

  void _setStatusBar() {
    final theme = Theme.of(context);
    // Set the status bar to be fully transparent and adjust text color based on theme
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Make status bar transparent
        statusBarIconBrightness: theme.brightness == Brightness.dark
            ? Brightness.light // White icons for dark mode
            : Brightness.dark, // Black icons for light mode
      ),
    );
  }

  void _saveServerUrl() async {
    final input = _controller.text.trim();
    final uri = Uri.tryParse(input);
    if (uri == null || !(uri.isAbsolute && (uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https')))) {
      _showError('Please enter a valid URL starting with http:// or https://');
      return;
    }

    final testUri = uri.replace(
      path: uri.path.endsWith('/')
          ? '${uri.path}apis/mlj_1/test'
          : '${uri.path}/apis/mlj_1/test',
    );

    setState(() {
      _isLoading = true;
    });

    try {
      final isValid = await ServerService().pingServer(testUri);
      if (!mounted) return;

      if (isValid) {
        final box = await Hive.openBox('settings');

        // get current list or empty list if null
        List<String> urls = box.get('serverUrls', defaultValue: [])!.cast<String>();

        if (!urls.contains(input)) { // optional: avoid duplicates
          urls.add(input);
          await box.put('serverUrls', urls);
          await box.put('selectedUrl', input);
        }

        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (context) => BottomNav(box: widget.box),
          ),
        );

      } else {
        if (!mounted) return;
        _showError('Server responded with invalid status');
      }
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    AppSnackBar(message: message).build(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    _setStatusBar();

    return StatusBar(
        child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Spacer(flex: 1),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/favicon_large.png',
                            height: 200,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'maloja',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 40),
                          TextField(
                            controller: _controller,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              hintText: 'Maloja Server Domain',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          LoadingButton(
                            isLoading: _isLoading,
                            onPressed: _isLoading ? null : _saveServerUrl,
                          ),
                        ],
                      ),
                      const Spacer(flex: 3),
                    ],
                  ),
                ),
                if (_appVersion.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      _appVersion,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
