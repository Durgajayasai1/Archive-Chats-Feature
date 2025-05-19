import 'package:archive_chats/pages/chat_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Archive Chats',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade900,
        appBarTheme: AppBarTheme(color: Colors.blueGrey.shade700),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey.shade900),
      ),
      home: const ChatScreen(),
    );
  }
}
