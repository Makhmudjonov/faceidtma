import 'package:flutter/material.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/img/talon_bg.png")),
        ),
        child: Stack(children: [Positioned(child: Text("data"))]),
      ),
    );
  }
}
