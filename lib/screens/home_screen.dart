import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/screens/add_task_screen.dart';
import 'package:task_manager/screens/profile_screen.dart';
import 'package:task_manager/services/auth_service.dart';
import 'package:task_manager/services/firestore_service.dart';
import 'package:task_manager/services/quote_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  String userName = "User";

  final FirestoreService firestoreService = FirestoreService();

  final AuthService authService = AuthService();

  final QuoteService quoteService = QuoteService();

  late Future<Map<String, dynamic>> quoteFuture;

  Future<void> fetchUserName() async {
    try {
      final userId = authService.getCurrentUserId();

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        setState(() {
          userName = doc['name'] ?? "User";
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    quoteFuture = quoteService.fetchQuote();

    fetchUserName();
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
          currentIndex == 0
              ? 'All Tasks'
              : currentIndex == 1
              ? 'Completed Tasks'
              : 'Profile',

          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      floatingActionButton: currentIndex == 2
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.deepPurple,

              elevation: 4,

              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddTaskScreen()),
                );
              },

              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),

      body: currentIndex == 2
          ? ProfileScreen(userName: userName)
          : StreamBuilder<List<TaskModel>>(
              stream: firestoreService.getTasks(),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<TaskModel> tasks = snapshot.data ?? [];

                if (currentIndex == 1) {
                  tasks = tasks.where((task) => task.status).toList();
                }

                return RefreshIndicator(
                  color: Colors.deepPurple,

                  onRefresh: () async {
                    setState(() {
                      quoteFuture = quoteService.fetchQuote();
                    });
                  },

                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,

                        margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              'Hello $userName 👋',

                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,

                                color: Colors.black87,
                              ),
                            ),

                            const SizedBox(height: 4),

                            const Text(
                              'Manage your daily tasks',

                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      FutureBuilder<Map<String, dynamic>>(
                        future: quoteFuture,

                        builder: (context, quoteSnapshot) {
                          if (quoteSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              margin: const EdgeInsets.all(16),

                              padding: const EdgeInsets.all(24),

                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.deepPurple,
                                    Color(0xff7E57C2),
                                  ],
                                ),

                                borderRadius: BorderRadius.circular(24),
                              ),

                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }

                          final quote = quoteSnapshot.data;

                          return Container(
                            width: double.infinity,

                            margin: const EdgeInsets.all(16),

                            padding: const EdgeInsets.all(24),

                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,

                                end: Alignment.bottomRight,

                                colors: [Colors.deepPurple, Color(0xff8E67E8)],
                              ),

                              borderRadius: BorderRadius.circular(28),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurple.withOpacity(0.25),

                                  blurRadius: 14,

                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                const Icon(
                                  Icons.format_quote,

                                  color: Colors.white,

                                  size: 38,
                                ),

                                const SizedBox(height: 16),

                                Text(
                                  quote?['content'] ?? '',

                                  style: const TextStyle(
                                    color: Colors.white,

                                    fontSize: 18,

                                    height: 1.5,

                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                Align(
                                  alignment: Alignment.centerRight,

                                  child: Text(
                                    '- ${quote?['author'] ?? ''}',

                                    style: const TextStyle(
                                      color: Colors.white70,

                                      fontSize: 14,

                                      fontStyle: FontStyle.italic,

                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      Expanded(
                        child: tasks.isEmpty
                            ? ListView(
                                children: const [
                                  SizedBox(height: 120),

                                  Icon(
                                    Icons.task_alt,

                                    size: 90,

                                    color: Colors.grey,
                                  ),

                                  SizedBox(height: 20),

                                  Center(
                                    child: Text(
                                      'No Tasks Available',

                                      style: TextStyle(
                                        fontSize: 20,

                                        fontWeight: FontWeight.bold,

                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 8),

                                  Center(
                                    child: Text(
                                      'Tap + button to add tasks',

                                      style: TextStyle(
                                        color: Colors.grey,

                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  bottom: 100,
                                ),

                                itemCount: tasks.length,

                                itemBuilder: (context, index) {
                                  TaskModel task = tasks[index];

                                  return Dismissible(
                                    key: Key(task.id),

                                    direction: DismissDirection.endToStart,

                                    background: Container(
                                      margin: const EdgeInsets.only(bottom: 18),

                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                      ),

                                      alignment: Alignment.centerRight,

                                      decoration: BoxDecoration(
                                        color: Colors.red,

                                        borderRadius: BorderRadius.circular(24),
                                      ),

                                      child: const Icon(
                                        Icons.delete,

                                        color: Colors.white,

                                        size: 32,
                                      ),
                                    ),

                                    onDismissed: (direction) async {
                                      await firestoreService.deleteTask(
                                        task.id,
                                      );

                                      Fluttertoast.showToast(
                                        msg: 'Task Deleted',
                                      );
                                    },

                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),

                                      margin: const EdgeInsets.only(bottom: 18),

                                      padding: const EdgeInsets.all(20),

                                      decoration: BoxDecoration(
                                        color: Colors.white,

                                        borderRadius: BorderRadius.circular(24),

                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.05,
                                            ),

                                            blurRadius: 12,

                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),

                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,

                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  task.title,

                                                  style: TextStyle(
                                                    fontSize: 21,

                                                    fontWeight: FontWeight.bold,

                                                    color: task.status
                                                        ? Colors.grey
                                                        : Colors.black87,

                                                    decoration: task.status
                                                        ? TextDecoration
                                                              .lineThrough
                                                        : null,
                                                  ),
                                                ),
                                              ),

                                              Transform.scale(
                                                scale: 1.1,

                                                child: Checkbox(
                                                  activeColor:
                                                      Colors.deepPurple,

                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                  ),

                                                  value: task.status,

                                                  onChanged: (value) async {
                                                    task.status = value!;

                                                    await firestoreService
                                                        .updateTask(task);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 10),

                                          Text(
                                            task.description,

                                            style: TextStyle(
                                              fontSize: 15,

                                              height: 1.5,

                                              color: Colors.grey.shade700,

                                              decoration: task.status
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                          ),

                                          const SizedBox(height: 20),

                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 14,

                                                      vertical: 8,
                                                    ),

                                                decoration: BoxDecoration(
                                                  color: Colors.deepPurple
                                                      .withOpacity(0.1),

                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),

                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.calendar_month,

                                                      size: 17,

                                                      color: Colors.deepPurple,
                                                    ),

                                                    const SizedBox(width: 6),

                                                    Text(
                                                      task.date,

                                                      style: const TextStyle(
                                                        color:
                                                            Colors.deepPurple,

                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              const Spacer(),

                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.deepPurple
                                                      .withOpacity(0.1),

                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),

                                                child: IconButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            AddTaskScreen(
                                                              task: task,
                                                            ),
                                                      ),
                                                    );
                                                  },

                                                  icon: const Icon(
                                                    Icons.edit,

                                                    color: Colors.deepPurple,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),

      bottomNavigationBar: Container(
        height: 78,

        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(18),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),

              blurRadius: 10,

              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            navItem(icon: Icons.home, label: 'Home', index: 0),

            navItem(icon: Icons.check_circle, label: 'Completed', index: 1),

            navItem(icon: Icons.person, label: 'Profile', index: 2),
          ],
        ),
      ),
    );
  }

  Widget navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    bool isSelected = currentIndex == index;

    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(50),

        splashColor: Colors.deepPurple.withOpacity(0.2),

        highlightColor: Colors.transparent,

        onTap: () {
          setState(() {
            currentIndex = index;
          });
        },

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Icon(
                icon,

                color: isSelected ? Colors.deepPurple : Colors.grey,

                size: 24,
              ),

              const SizedBox(height: 4),

              Text(
                label,

                style: TextStyle(
                  fontSize: 11,

                  fontWeight: FontWeight.w600,

                  color: isSelected ? Colors.deepPurple : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
