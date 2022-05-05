import 'package:flutter/material.dart';

class Achievement extends StatelessWidget {
  const Achievement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              "Sorry, this function is still being updated! We\’ll get back to you soon with a new feature",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
