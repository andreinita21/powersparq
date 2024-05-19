import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBshk7kH-2Q2t29P_NG75gao2dzFcL2Sag",
            authDomain: "power-sparq-04gv8k.firebaseapp.com",
            projectId: "power-sparq-04gv8k",
            storageBucket: "power-sparq-04gv8k.appspot.com",
            messagingSenderId: "634036721171",
            appId: "1:634036721171:web:32af249ed13d12434591e6"));
  } else {
    await Firebase.initializeApp();
  }
}
