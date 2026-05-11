import 'package:flutter/material.dart';
import 'package:task_manager/screens/login_screen.dart';
import 'package:task_manager/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;

  const ProfileScreen({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final AuthService authService =
        AuthService();

    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [
          Container(
            padding:
                const EdgeInsets.all(6),

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              border: Border.all(
                color:
                    Colors.deepPurple,

                width: 3,
              ),
            ),

            child: const CircleAvatar(
              radius: 45,

              backgroundColor:
                  Colors.deepPurple,

              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            userName,

            style: const TextStyle(
              fontSize: 28,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Flutter Internship Project',

            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 40),

          ElevatedButton.icon(
            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.deepPurple,

              elevation: 4,

              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 28,
                vertical: 16,
              ),

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius
                        .circular(18),
              ),
            ),

            onPressed: () async {
              await authService.logout();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const LoginScreen(),
                ),
              );
            },

            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),

            label: const Text(
              'Logout',

              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}