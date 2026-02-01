import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase/auth_page.dart';
import 'notes_page.dart';
import 'firebase/notif_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes Hybrid',
      theme: ThemeData(useMaterial3: true),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // 🔄 WAJIB: loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // ❌ belum login
          if (!snapshot.hasData) {
            return const AuthPage();
          }

          // ✅ sudah login
          return const HomePage();
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    // 🔔 NOTIF pindah ke sini (aman)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await NotifService.instance.init();
      await NotifService.instance.showNow(
        title: 'Login Berhasil',
        body: 'Selamat datang 👋',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes Hybrid'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await NotifService.instance.showNow(
                title: 'Logout',
                body: 'Berhasil keluar',
              );
            },
          ),
        ],
      ),
      body: const NotesPage(),
    );
  }
}
