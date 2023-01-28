import 'package:dashboard_1/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import './dashboard/home.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final task = [
    Container(),
    Container(),
    const App(),
    const Profile(),
    Container(),
  ];
  int currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: task[currentIndex],
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: GNav(
            gap: 3,
            selectedIndex: currentIndex,
            backgroundColor: Colors.white,
            color: Colors.black,
            activeColor: Colors.black,
            tabBackgroundColor: Color(0xffDADEEC),
            padding: EdgeInsets.all(5),
            tabs: const [
              GButton(
                icon: Icons.add_chart,
                text: "Add System",
                iconSize: 24,
                textStyle: TextStyle(
                  fontFamily: 'SF-Pro',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GButton(
                icon: Icons.dashboard_customize,
                text: 'Add Pond',
                iconSize: 24,
              ),
              GButton(
                icon: Icons.home,
                text: 'Home',
                iconSize: 24,
              ),
              GButton(
                icon: Icons.account_circle,
                text: 'Profile',
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
                iconSize: 24,
              ),
            ],
            onTabChange: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
