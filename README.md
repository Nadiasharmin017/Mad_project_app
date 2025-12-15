# 📱 Philosophy App  
*A Flutter & Firebase based mobile application*

---

## 📖 Project Description

The **Philosophy App** is a mobile application developed using **Flutter** that helps users engage in **self-reflection and philosophical learning**.  
The app provides daily philosophical quotes, personal journaling, book recommendations, and philosophical locations with maps.

User authentication is handled using **Firebase**, ensuring that only logged-in users can access personal features like journaling.

---

## 🎯 Purpose of the Project

- Encourage **self-reflection** through journaling  
- Provide **daily philosophy content**  
- Recommend **philosophy books** using public APIs  
- Explore **philosophical locations** with map images  
- Demonstrate **real-world mobile app development** using Flutter & Firebase  

---

## ✨ Features

- 🔐 Firebase Email & Password Authentication (Login & Register)
- 🧠 Daily Philosophical Quotes (Public API)
- ✍️ Personal Journal (Stored securely per user)
- 📚 Philosophy Book Recommendations (Google Books API)
- 🌍 Philosophical Locations with Map Images
- 🔔 Daily Notifications
- ⭐ Favorite Books (Local Storage)
- 🌙 Dark Theme UI
- 📱 Bottom Navigation Bar

---

## 🛠️ Tech Stack

- **Frontend:** Flutter (Dart)
- **Backend / Auth:** Firebase Authentication
- **Database:** Firebase Firestore, Local SQLite
- **APIs Used:**
  - ZenQuotes API
  - Google Books API
  - Wikipedia API
  - Google Static Maps API
- **Notifications:** flutter_local_notifications

---

## 📂 Project Structure (Simplified)

```
lib/
 ├─ main.dart
 ├─ firebase_options.dart
 ├─ screens/
 ├─ ui/
 │   ├─ tabs/
 │   └─ auth_gate.dart
 ├─ services/
 ├─ models/
 ├─ db/
 └─ core/
```

---

## ⚙️ Installation & Setup Guide

### 🔹 Prerequisites

- Flutter SDK  
- Dart SDK  
- Android Studio / VS Code  
- Firebase account  
- Android Emulator or Physical Device  

Check Flutter installation:
```bash
flutter doctor
```

---

### 🔹 Clone the Repository

```bash
git clone https://github.com/your-username/philosophy_app.git
cd philosophy_app
```

---

### 🔹 Install Dependencies

```bash
flutter pub get
```

---

### 🔹 Firebase Setup

1. Create a Firebase project
2. Enable **Email/Password Authentication**
3. Add Android app and download `google-services.json`
4. Place it inside:
```
android/app/google-services.json
```

---

### 🔹 Configure Firebase for Flutter

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This generates:
```
lib/firebase_options.dart
```

---

### 🔹 Run the App

```bash
flutter run
```

> ⚠️ Firebase authentication works fully on Android/iOS.

---

## 🔐 Firestore Security Rules

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/journals/{doc} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

## 🎓 Academic Note

This project is developed as part of a **Mobile Application Development (MAD)** course.

---

## 👩‍💻 Developer

**Nadia Sharmin**
