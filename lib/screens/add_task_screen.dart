import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/services/firestore_service.dart';
import 'package:task_manager/widgets/custom_button.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskModel? task;

  const AddTaskScreen({super.key, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final titleController = TextEditingController();

  final descriptionController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String selectedDate = "";

  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      titleController.text = widget.task!.title;

      descriptionController.text = widget.task!.description;

      selectedDate = widget.task!.date;
    }
  }

  Future<void> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,

      firstDate: DateTime(2024),

      lastDate: DateTime(2100),

      initialDate: DateTime.now(),

      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.deepPurple),
          ),

          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = DateFormat('dd MMM yyyy').format(pickedDate);
      });
    }
  }

  Future<void> saveTask() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (selectedDate.isEmpty) {
      Fluttertoast.showToast(msg: "Please select date");

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      TaskModel task = TaskModel(
        id: widget.task?.id ?? '',

        title: titleController.text.trim(),

        description: descriptionController.text.trim(),

        date: selectedDate,

        status: widget.task?.status ?? false,
      );

      if (widget.task == null) {
        await firestoreService.addTask(task);

        Fluttertoast.showToast(msg: "Task Added");
      } else {
        await firestoreService.updateTask(task);

        Fluttertoast.showToast(msg: "Task Updated");
      }

      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  InputDecoration customDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,

      prefixIcon: Icon(icon, color: Colors.deepPurple),

      filled: true,

      fillColor: Colors.white,

      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),

        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),

        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),

        borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),

      appBar: AppBar(
        backgroundColor: Colors.deepPurple,

        elevation: 0,

        centerTitle: true,

        title: Text(
          widget.task == null ? "Add Task" : "Edit Task",

          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 10),

              const Text(
                "Create Your Task ✨",

                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,

                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Manage your daily work easily",

                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),

              const SizedBox(height: 30),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),

                      blurRadius: 12,

                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: TextFormField(
                  controller: titleController,

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter title";
                    }

                    return null;
                  },

                  decoration: customDecoration(
                    hint: "Task Title",

                    icon: Icons.task_alt,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),

                      blurRadius: 12,

                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: TextFormField(
                  controller: descriptionController,

                  maxLines: 6,

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter description";
                    }

                    return null;
                  },

                  decoration: customDecoration(
                    hint: "Task Description",

                    icon: Icons.description,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              GestureDetector(
                onTap: pickDate,

                child: Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurple.withOpacity(0.95),

                        const Color(0xff8E67E8),
                      ],
                    ),

                    borderRadius: BorderRadius.circular(24),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.25),

                        blurRadius: 12,

                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),

                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.calendar_month,

                          color: Colors.white,

                          size: 28,
                        ),
                      ),

                      const SizedBox(width: 18),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const Text(
                              "Select Task Date",

                              style: TextStyle(
                                color: Colors.white70,

                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              selectedDate.isEmpty
                                  ? "Choose Date"
                                  : selectedDate,

                              style: const TextStyle(
                                color: Colors.white,

                                fontSize: 20,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              CustomButton(
                text: widget.task == null ? "Add Task" : "Update Task",

                isLoading: isLoading,

                onPressed: saveTask,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
