# Task Manager App

A modern Flutter Task Manager application built for the Flutter Development Internship Assignment.

The app allows users to:
- Sign Up & Login using Firebase Authentication
- Manage daily tasks using Cloud Firestore
- Add, Edit, Delete, and Complete tasks
- View motivational quotes using REST API integration
- Experience a clean and responsive modern UI

---

# Features

## Authentication
- User Sign Up
- User Login
- Logout Functionality
- Password Visibility Toggle
- Confirm Password Validation

## Task Management
- Add Tasks
- Edit Tasks
- Delete Tasks
- Mark Tasks as Completed
- Swipe to Delete
- Real-time Firestore Updates

## Task Fields
Each task contains:
- Title
- Description
- Date
- Status

## REST API Integration
Motivational quotes are fetched from:
https://api.quotable.io/random

Displays:
- Quote
- Author

## UI Features
- Clean Responsive UI
- Bottom Navigation Bar
- Personalized Greeting
- Modern Task Cards
- Pull To Refresh
- Loading Indicators
- Error Handling
- Empty Task State UI

---

# Tech Stack

- Flutter
- Dart
- Firebase Authentication
- Cloud Firestore
- REST API
- Android Support

---

# Folder Structure

```txt
lib/
├── screens/
├── services/
├── models/
├── widgets/
└── main.dart

# Dependencies
firebase_core:
firebase_auth:
cloud_firestore:
http:
intl:
fluttertoast:

Firebase Setup
1. Create Firebase Project

Go to:
https://console.firebase.google.com/

Create a new Firebase project.

2. Enable Authentication

Firebase Console → Authentication → Sign-in Method

Enable:

Email/Password
3. Enable Firestore Database

Firebase Console → Firestore Database

Create database in test mode.

4. Configure FlutterFire

Run:

dart pub global activate flutterfire_cli

Then:

flutterfire configure
Installation & Run
Clone Repository
git clone <your-github-repository-link>
Open Project
cd task_manager
Install Dependencies
flutter pub get
Run App
flutter run
APK Build

Generate APK using:

flutter build apk

APK Location:

build/app/outputs/flutter-apk/app-release.apk
Screens
Login Screen
Signup Screen
Home Screen
Add/Edit Task Screen
Completed Tasks Section
Profile Section
Notes
Firebase Authentication is fully integrated
Cloud Firestore CRUD operations are implemented
REST API integration is implemented
Reusable widgets are used
Clean coding practices are followed
App is tested on Android
Author

Pranay Das
Flutter Developer
