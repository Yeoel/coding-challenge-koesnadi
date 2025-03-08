import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_challenge_koesnadi/create_data.dart';
import 'package:coding_challenge_koesnadi/database.dart';
import 'package:coding_challenge_koesnadi/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:forui/theme.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late FPopoverController controller;
  late FRadioSelectGroupController<String> groupController;

  User? currentUser = FirebaseAuth.instance.currentUser;
  String userId = '';

  Stream<QuerySnapshot<Object?>> tasksStream = Stream.empty();

  Future<void> fetchTasks() async {
    tasksStream = await Database().getTasks(userId);
  }

  @override
  void initState() {
    super.initState();

    userId = currentUser!.uid;

    fetchTasks();

    controller = FPopoverController(vsync: this);
    groupController = FRadioSelectGroupController<String>();
  }

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
                Expanded(
                    child: StreamBuilder(
                        stream: tasksStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  spacing: 20,
                                  children: [
                                    Text(
                                      'No tasks yet.',
                                    ),
                                    FButton(
                                        onPress: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateData()));
                                        },
                                        label: Text('Create new')),
                                  ],
                                ),
                              ),
                            );
                          }

                          return FTileGroup.builder(
                              label: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Todo List'),
                                  FButton(
                                      onPress: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CreateData()));
                                      },
                                      label: Text('Create new')),
                                ],
                              ),
                              count: snapshot.data!.docs.length,
                              tileBuilder: (context, index) {
                                var data = snapshot.data!.docs[index];
                                Timestamp deadlineData = data['deadline'];
                                var deadlineDisplay = DateTime.fromMicrosecondsSinceEpoch(deadlineData.microsecondsSinceEpoch);


                                return FTile(
                                  suffixIcon: FIcon(FAssets.icons.chevronRight),
                                  onPress: () {},
                                  details: Text(deadlineDisplay.toString().split(' ')[0],),
                                  title: Text('${index + 1}. ${data['todo']}'),
                                );
                              });
                        }))
              ],
            ),
          )),
    );
  }
}
