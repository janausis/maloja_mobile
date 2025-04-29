

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:maloja_mobile/screens/setup_page.dart';
import 'package:maloja_mobile/widgets/status_bar.dart'; // Adjust as needed for your StatusBar widget

import '../utils/page_router.dart'; // Adjust import for SetupPage

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Box box;
  late List<String> urls = [];
  late String selected = "";

  @override
  void initState() {
    super.initState();
    _loadUrls();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadUrls() async {
    box = await Hive.openBox('settings');
    // Get the current list or an empty list if null
    setState(() {
      selected = box.get("selectedUrl", defaultValue: "");
      urls = box.get('serverUrls', defaultValue: [])!.cast<String>();
    });
  }

  Future<void> _deleteUrl(int index) async {
    setState(() {
      urls.removeAt(index);

      if (urls.isNotEmpty) {
        _selectUrl(urls.length - 1);
      }
    });

    // Save updated list to Hive
    await box.put('serverUrls', urls);

    // If list is empty, navigate to the SetupPage
    if (urls.isEmpty) {
      if (!mounted) return;
      NavigationUtil.pushReplacementPage(context, SetupPage());
    }
  }

  Future<void> _selectUrl(int index) async {
    setState(() {
      if (!mounted) return;
      selected = urls[index];
    });

    if (!mounted) return;
    // Save updated list to Hive
    await box.put('selectedUrl', urls[index]);

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StatusBar(
      child: Scaffold(
        appBar: AppBar(title: const Text("Domains")),
        body: SafeArea(
          child:
              urls.isEmpty
                  ? Center(
                    child: CircularProgressIndicator(),
                  ) // Show loading indicator while fetching
                  : ListView.builder(
                    itemCount: urls.length + 1,
                    itemBuilder: (innerContext, index) {
                      bool isLastItem = index == urls.length;

                      Widget listItem;

                      if (index == urls.length) {
                        listItem = IOSUrlListItem(
                          text: "New Domain",
                          textColor: theme.colorScheme.onSecondaryContainer,
                          icon: Icons.add,
                          onPressed: () => NavigationUtil.pushPage(context, SetupPage()),
                          onIconPressed: () => NavigationUtil.pushPage(context, SetupPage()),
                          selected: false,
                        );
                      } else if (urls[index] == selected) {
                        listItem =  IOSUrlListItem(
                          text: urls[index],
                          textColor: theme.colorScheme.onSecondaryContainer,
                          icon: Icons.delete,
                          onPressed: () => {},
                          onIconPressed: () => _deleteUrl(index),
                          selected: true,
                        );
                      } else {
                        listItem =  IOSUrlListItem(
                          text: urls[index],
                          textColor: theme.colorScheme.onSecondaryContainer,
                          icon: Icons.delete,
                          onPressed: () => _selectUrl(index),
                          onIconPressed: () => _deleteUrl(index),
                          selected: false,
                        );
                      }

                      return Column(
                        children: [
                          listItem,
                          if (!isLastItem)
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              height: 0.5,
                              color: CupertinoColors.systemGrey4, // Nice soft grey line
                            ),
                        ],
                      );
                    },
                  ),
        ),
      ),
    );
  }
}

class IOSUrlListItem extends StatelessWidget {
  final Color textColor;
  final String text;
  final IconData icon;
  final Function()? onPressed;
  final Function()? onIconPressed;
  final bool selected;

  const IOSUrlListItem({
    super.key,
    required this.text,
    required this.textColor,
    required this.icon,
    required this.onPressed,
    required this.onIconPressed,
    required this.selected
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: CupertinoButton(
          sizeStyle: CupertinoButtonSize.large,
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(10),
          onPressed: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                selected ? SizedBox(
                    width: 30,
                    height: 30,
                    child: IconButton(
                        icon: Icon(Icons.check),
                        color: textColor,
                        onPressed: onIconPressed

                    )
                ) : SizedBox(),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: IconButton(
                    icon: Icon(icon),
                    color: textColor,
                    onPressed: onIconPressed

                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}