import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';

export 'app.dart' show MyApp;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDgsuLNAaNqitL0nTp0SYDo9OH2vHFaMFY',
      appId: '1:654520686782:android:c85f495b23d24f5bd4e6ef',
      messagingSenderId: '654520686782',
      projectId: 'loan-form-app',
      storageBucket: 'loan-form-app.firebasestorage.app',
    ),
  );

  runApp(const MyApp());
}
