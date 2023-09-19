import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCI9Y1ZNAhz_7ADhe5VzsoC3qUZQ6MPAvk",
            authDomain: "smartpal-4b633.firebaseapp.com",
            projectId: "smartpal-4b633",
            storageBucket: "smartpal-4b633.appspot.com",
            messagingSenderId: "605278461285",
            appId: "1:605278461285:web:34993b7ec95ce661de158c",
            measurementId: "G-BJTLXJ8V46"));
  } else {
    await Firebase.initializeApp();
  }
}
