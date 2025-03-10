import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_challenge_koesnadi/dashboard.dart';
import 'package:coding_challenge_koesnadi/database.dart';
import 'package:coding_challenge_koesnadi/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:toastification/toastification.dart';

class EditData extends StatefulWidget {
  final String id, task;
  final Timestamp deadline;

  const EditData(
      {required this.task,
      required this.deadline,
      required this.id,
      super.key});

  @override
  State<EditData> createState() => EditDataState();
}

class EditDataState extends State<EditData> with TickerProviderStateMixin {
  TextEditingController todoController = TextEditingController();
  late FDatePickerController deadlineController;

  User? currentUser = FirebaseAuth.instance.currentUser;
  String userId = '';

  @override
  void initState() {
    super.initState();

    userId = currentUser!.uid;

    deadlineController = FDatePickerController(
      vsync: this,
      initialDate: widget.deadline.toDate(),
      validator: (date) => date?.isBefore(DateTime.now()) ?? false
          ? 'Date must be in the future'
          : null,
    );

    todoController.text = widget.task;
  }

  final _formKey = GlobalKey<FormState>();

  Future<void> deleteTask() async {
    try {
      await Database().deleteTask(userId, widget.id);

      toastification.show(
        title: Text('Task removed'),
        autoCloseDuration: const Duration(seconds: 5),
        icon: const Icon(Icons.check),
        alignment: Alignment.bottomCenter,
      );
      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      toastification.show(
        title: Text(e.message.toString()),
        icon: const Icon(Icons.warning),
        autoCloseDuration: const Duration(seconds: 5),
        alignment: Alignment.bottomCenter,
      );
    }
  }

  Future<void> updateTask() async {
    try {
      if (!_formKey.currentState!.validate()) {
        // If the form is invalid, stop further execution.
        return;
      }

      Map<String, dynamic> taskMap = {
        'todo': todoController.text.trim(),
        'deadline': deadlineController.value
      };

      await Database().updateTask(taskMap, userId, widget.id);

      toastification.show(
        title: Text('Edit task success'),
        autoCloseDuration: const Duration(seconds: 5),
        icon: const Icon(Icons.check),
        alignment: Alignment.bottomCenter,
      );
      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      toastification.show(
        title: Text(e.message.toString()),
        icon: const Icon(Icons.warning),
        autoCloseDuration: const Duration(seconds: 5),
        alignment: Alignment.bottomCenter,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FTheme(
      data: FThemes.zinc.light,
      child: FScaffold(
        header: FHeader(
          title: Text('FlutterApp'),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 30),
                FCard(
                  title: Row(
                    spacing: 10,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: FIcon(FAssets.icons.arrowLeft),
                      ),
                      Text(
                        'Edit task',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ],
                  ),
                  subtitle: const Text(
                    'Change the task detail.',
                  ),
                  child: Form(
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        FTextField(
                          controller: todoController,
                          label: Text('Task'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Todo can\'t empty';
                            }
                            return null;
                          },
                          hint: 'Create new project',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FDatePicker(
                          controller: deadlineController,
                          label: const Text('Deadline Date'),
                        ),
                        const SizedBox(height: 25),
                        FButton(
                          label: const Text('Update'),
                          onPress: () => updateTask(),
                        ),
                        const SizedBox(height: 15),
                        FButton(
                          label: const Text('Delete'),
                          style: FButtonStyle.destructive,
                          onPress: () => deleteTask(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
