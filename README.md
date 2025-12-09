🚀 Getting Started
Prerequisites
Before running this project, ensure you have:

Flutter SDK installed.

Firebase CLI installed.

An active Firebase Project created on the Firebase Console.

Installation
Clone the repository:

Bash

git clone [https://github.com/your-username/your-repo-name.git](https://github.com/your-username/your-repo-name.git)
cd your-repo-name
Install Dependencies:

Bash

flutter pub get
Configure Firebase: Run the following command to link this app to your Firebase project (this generates firebase_options.dart):

Bash

flutterfire configure
Select "Authentication" in the Firebase Console and enable "Email/Password" sign-in provider.

Run the App:

Bash

flutter run
🧠 How It Works
main.dart: Initializes Firebase and loads the AuthWrapper.

AuthWrapper: Listens to the authStateChanges stream from Firebase.

If User is null → Shows LoginScreen.

If User is logged in → Shows DashboardScreen.

Login/Signup: Calls methods in AuthService. upon success, Firebase updates the stream, and AuthWrapper automatically handles the navigation.

📦 Dependencies
firebase_core - Connection to Firebase.

firebase_auth - Authentication logic.

provider - (Optional/Included for future scalability).
