import 'package:flutter/material.dart';
import 'routers/app_router.dart'; // Ensure you have this router setup properly

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Telemedicine App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
      home: HomeScreen(), // Use the HomeScreen widget as the root
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), // Rounded corners
            border: Border.all(color: Colors.blue, width: 2), // Blue border
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // Shadow position
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
            child: Image.asset(
              'imges/first.png', // Corrected the image path
              width: 200, // Set the width of the image
              height: 200, // Set the height of the image
            ),
          ),
        ),
      ),
    );
  }
}
