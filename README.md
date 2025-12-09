# 🚀 Flutter Firebase Authentication App

A simple and clean Flutter application that integrates **Firebase Authentication** using **Email/Password login**.  
The app listens to real-time authentication state changes and automatically switches between **Login**, **Signup**, and **Dashboard** screens.

---

## 📋 Prerequisites

Before running this project, make sure you have:

- **Flutter SDK** installed  
- **Firebase CLI** installed  
- **An active Firebase project** created in the **Firebase Console**

---

## 🔧 Installation & Setup

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name

2️⃣ Install Dependencies
flutter pub get

3️⃣ Configure Firebase

Run the command below to link this Flutter project with your Firebase project.
This generates the firebase_options.dart file.

Then:

Go to Firebase Console → Authentication
Open Sign-in providers
Enable Email/Password

4️⃣ Run the App
flutter run

🧠 How It Works
main.dart

Initializes Firebase.

Loads the AuthWrapper widget.

AuthWrapper

Listens to Firebase's authentication state:

If User == null → Shows LoginScreen

If logged in → Shows DashboardScreen

Login / Signup

Calls methods inside AuthService.

On success, Firebase updates the auth state.

AuthWrapper automatically updates UI accordingly.

📁 Project Structure
lib/
 ├── main.dart
 ├── firebase_options.dart
 ├── services/
 │     └── auth_service.dart
 ├── wrappers/
 │     └── auth_wrapper.dart
 ├── screens/
 │     ├── login_screen.dart
 │     ├── signup_screen.dart
 │     └── dashboard_screen.dart
 └── widgets/
       └── custom_button.dart

