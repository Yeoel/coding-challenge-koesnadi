import 'package:coding_challenge_koesnadi/create_data.dart';
import 'package:coding_challenge_koesnadi/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:forui/theme.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late FPopoverController controller;
  late FRadioSelectGroupController<String> groupController;

  @override
  void initState() {
    super.initState();
    controller = FPopoverController(vsync: this);
    groupController = FRadioSelectGroupController<String>();
  }

  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return FTheme(
      data: FThemes.zinc.light,
      child: FScaffold(
          header: FHeader(
            title: Text('FlutterApp'),
            actions: [
              FPopoverMenu(
                popoverController: controller,
                menuAnchor: Alignment.topRight,
                childAnchor: Alignment.bottomRight,
                menu: [
                  FTileGroup(
                    children: [
                      FTile(
                        prefixIcon: FIcon(FAssets.icons.user),
                        title: const Text('Personalization'),
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Profile()));
                        },
                      ),
                    ],
                  ),
                ],
                child: FHeaderAction(
                  icon: FIcon(FAssets.icons.ellipsis),
                  onPress: controller.toggle,
                ),
              ),
            ],
          ),
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Login as',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Text(
                  currentUser!.email.toString(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 25,
                ),
                FTileGroup(
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Todo List'),
                        FButton(onPress: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateData()));
                        }, label: Text('Create new')),
                      ],
                    ),
                    children: [
                      FTile(
                        title: const Text('Personalization'),
                        suffixIcon: FIcon(FAssets.icons.chevronRight),
                        onPress: () {},
                      ),
                      FTile(
                        title: const Text('Personalization'),
                        suffixIcon: FIcon(FAssets.icons.chevronRight),
                        onPress: () {},
                      ),
                    ])
              ],
            ),
          )),
    );
  }
}
