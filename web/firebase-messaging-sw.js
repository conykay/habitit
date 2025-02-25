importScripts("https://www.gstatic.com/firebasejs/9.6.10/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.6.10/firebase-messaging-compat.js");

const firebaseConfig = {
  apiKey: "AIzaSyAeL6_7zZrr_KjKgq9pxV8xcGtNOJiSYV8",
  authDomain: "habitit-ef892.firebaseapp.com",
  projectId: "habitit-ef892",
  storageBucket: "habitit-ef892.firebasestorage.app",
  messagingSenderId: "447620558965",
  appId: "1:447620558965:web:cbf5e47aa5882da2ef483c",
  measurementId: "G-V9N6Y4P7RQ"
};

firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();

// todo Set up background message handler