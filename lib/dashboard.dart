import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_challenge_koesnadi/create_data.dart';
import 'package:coding_challenge_koesnadi/database.dart';
import 'package:coding_challenge_koesnadi/edit_data.dart';
import 'package:coding_challenge_koesnadi/profile.dart';
import 'package:coding_challenge_koesnadi/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:forui/theme.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_challenge_koesnadi/create_data.dart';
import 'package:coding_challenge_koesnadi/database.dart';
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

  User? currentUser = FirebaseAuth.instance.currentUser;
  String userId = '';

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignIn()));
    }
  }

  @override
  void initState() {
    super.initState();

    userId = currentUser!.uid;

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
                      title: const Text('Profile'),
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Profile()),
                        );
                      },
                    ),
                    FTile(
                        prefixIcon: FIcon(FAssets.icons.logOut),
                        title: const Text('Logout'),
                        onPress: signOut),
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
              SizedBox(height: 20),
              Text(
                'Login as',
                style: TextStyle(fontSize: 15),
              ),
              Text(
                currentUser!.email.toString(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 25),
              Expanded(
                child: FutureBuilder<Stream<QuerySnapshot>>(
                  future: Database().getTasks(userId), // Fetch the stream
                  builder: (context, futureSnapshot) {
                    if (futureSnapshot.hasError) {
                      return Center(
                        child: Text(
                            'Something went wrong: ${futureSnapshot.error}'),
                      );
                    }
                    if (!futureSnapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return StreamBuilder<QuerySnapshot>(
                      stream: futureSnapshot.data,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child:
                                Text('Something went wrong: ${snapshot.error}'),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('No tasks available.'),
                                FButton(
                                  onPress: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CreateData()),
                                    );
                                  },
                                  label: Text('Create new'),
                                ),
                              ],
                            ),
                          );
                        }

                        return FTileGroup.builder(
                          label: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Todo List'),
                              FButton(
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreateData()),
                                  );
                                },
                                label: Text('Create new'),
                              ),
                            ],
                          ),
                          count: snapshot.data!.docs.length,
                          tileBuilder: (context, index) {
                            var data = snapshot.data!.docs[index];
                            Timestamp deadlineData = data['deadline'];
                            var deadlineDisplay =
                                DateTime.fromMicrosecondsSinceEpoch(
                              deadlineData.microsecondsSinceEpoch,
                            );

                            return FTile(
                              suffixIcon: FIcon(FAssets.icons.chevronRight),
                              onPress: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditData(
                                            deadline: data['deadline'] as Timestamp,
                                            task: data['todo'],
                                            id: data.id)));
                              },
                              details: Text(
                                  deadlineDisplay.toString().split(' ')[0]),
                              title: Text('${index + 1}. ${data['todo']}'),
                            );
                          },
                        );
                      },
                    );
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
