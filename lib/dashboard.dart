import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:forui/theme.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return FTheme(
      data: FThemes.zinc.light,
      child: FScaffold(
          header: FHeader(
            title: Text('FlutterApp'),
            actions: [
              FHeaderAction(
                  icon: FIcon(FAssets.icons.circleUserRound), onPress: () {})
            ],
          ),
          content: Column()),
    );
  }
}
