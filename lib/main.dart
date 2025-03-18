import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:inventory_management/app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  await Supabase.initialize(
    url:
        'https://nxxwcksyybzmhhrrvjij.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im54eHdja3N5eWJ6bWhocnJ2amlqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIwNDQyNTksImV4cCI6MjA1NzYyMDI1OX0.R52nC9_AFMc73jwarVqCedf9SX8dU3aYtD8Qo3OU97w',
  );

  // Inisialisasi Supabase Client
  final supabase = Supabase.instance.client;
  if (supabase == null) {
    print('Gagal menginisialisasi Supabase');
    return;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory Management',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: AppRoutes.login,
      getPages: AppRoutes.routes,
    );
  }
}
