import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: const [
        SizedBox(
          height: 100,
        ),
        Center(
          child: Text(
            "Profile",
            style: TextStyle(
              fontFamily: 'SF-Pro',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Center(
        //   child: Image(image: AssetImage()),
        // )
      ]),
    );
  }
}
