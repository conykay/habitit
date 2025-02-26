# Habitit

Habitit is a Flutter application designed to help users build and maintain habits. The app utilizes Firebase for authentication, Firestore for data storage, and a Node.js backend for periodic and user-triggered notifications. Due to time constraints, the development approach was feature-driven rather than test-driven, meaning tests are demonstrational rather than exhaustive.

## Features
- User authentication via Firebase
- Habit tracking and management
- Notification system powered by a Node.js backend
- Web and Android support (No iOS support due to lack of testing tools)

---

## Setup Instructions

### Prerequisites
Ensure you have the following installed:
- Flutter (latest stable version)
- Dart
- Firebase CLI
- Node.js (for backend notifications, if needed locally)

### Clone the Repository
```sh
  git clone https://github.com/conykay/habitit.git
  cd habitit
```

### Install Dependencies
```sh
  flutter pub get
```

### Setup Firebase
1. Create a Firebase project.
2. Enable Firestore, Authentication, and Firebase Hosting.
3. Download the `google-services.json` file and place it in `android/app/`.
4. Run Firebase emulators locally if needed:
```sh
  firebase emulators:start
```

### Run the App
For Android/Web:
```sh
  flutter run
```

---

## Testing
Since the project was developed with a feature-driven approach, tests are included for demonstration purposes but do not cover the entire functionality.

Run tests with:
```sh
  flutter test
```

---

## CI/CD Pipeline
The project utilizes GitHub Actions to automate testing, building, and deployment.

### Workflow Overview
1. **On push to production branch:**
   - Runs tests
   - Builds and deploys the web app to Firebase Hosting
   - Generates an APK for Android
2. **On pull request:**
   - Runs tests

### Firebase Deployment
Ensure Firebase CLI is installed and authenticated:
```sh
  firebase login
  firebase use --add
```
To deploy manually:
```sh
  firebase deploy --only hosting
```

### GitHub Actions Workflow
The workflow is defined in `.github/workflows/main.yml` and automates:
- Running tests
- Deploying the web app
- Building an APK

---

## Deployment Links

- **Web App:** [Habitit Web](https://habitit-ef892.web.app/)
- **Latest APK:** [Habitit App](https://github.com/conykay/habitit/actions/runs/13538676952/artifacts/2654119751)]

---

## Backend
The app relies on a Node.js server (hosted on Render) for handling scheduled and user-triggered notifications. If needed, clone and set up the backend from:
```sh
  git clone https://github.com/conykay/HabititService.git
```

Run the server locally:
```sh
  npm install
  node server.js
```

---

## Limitations & Future Improvements
- **No iOS support** due to the lack of necessary tools for testing.
- **Test coverage is limited** as the project focused on feature-driven development over test-driven development.
- **Improved notification scheduling** could enhance user experience.

---

## License
MIT License

---

## Author
Cornelius Korir

