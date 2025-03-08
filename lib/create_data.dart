import 'package:coding_challenge_koesnadi/dashboard.dart';
import 'package:coding_challenge_koesnadi/database.dart';
import 'package:coding_challenge_koesnadi/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:toastification/toastification.dart';

class CreateData extends StatefulWidget {
  const CreateData({super.key});

  @override
  State<CreateData> createState() => _CreateDataState();
}

class _CreateDataState extends State<CreateData> with TickerProviderStateMixin {
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
      initialDate: DateTime.now(),
      validator: (date) =>
      date?.isBefore(DateTime.now()) ?? false
          ? 'Date must be in the future'
          : null,
    );
  }

  final _formKey = GlobalKey<FormState>();




  Future<void> createNewTask() async {
    try {
      if (!_formKey.currentState!.validate()) {
        // If the form is invalid, stop further execution.
        return;
      }

      Map<String, dynamic> taskMap = {
        'todo': todoController.text.trim(),
        'deadline': deadlineController.value
      };

      await Database().createTask(taskMap, userId);

      toastification.show(
        title: Text('Create new task success'),
        autoCloseDuration: const Duration(seconds: 5),
        icon: const Icon(Icons.check),
        alignment: Alignment.bottomCenter,
      );
      if (mounted) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
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
        header: FHeader(title: Text('FlutterApp')),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 30),
                FCard(
                  title: const Text(
                    'Create new task',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  subtitle: const Text(
                    'Add a new task with a deadline.',
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
                          label: const Text('Create'),
                          onPress: () => createNewTask(),
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
