import 'package:buah_app/buah_detail.dart';
import 'package:flutter/material.dart';
import 'package:buah_app/beranda.dart';

main() {
  // Inisialisasi dengan binding Service Locator
  WidgetsFlutterBinding.ensureInitialized();

  // Aplikasi utama
  runApp(const BuahApp());
}

class BuahApp extends StatelessWidget {
  const BuahApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Beranda(),
      routes: {
        "/Beranda": (context) => const Beranda(),
        "/BuahDetail": (context) => const BuahDetail(),
      },
    );
  }
}



