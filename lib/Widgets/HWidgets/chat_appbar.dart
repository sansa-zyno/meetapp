import 'package:flutter/material.dart';
import 'package:meeter/Model/user.dart';

class ChatAppBar extends StatelessWidget {
  final OurUser recipient;
  final IconData icon;

  ChatAppBar({
    required this.recipient,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    return SafeArea(
      child: Container(
        height: h * 13.2,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color(0xff00AEFF),
            width: w * 0.2,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: GestureDetector(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: w * 1.9, vertical: h * 0.8),
                    child: Icon(icon, color: Color(0xff00AEFF), size: w * 7.3),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Expanded(
              flex: 5,
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    CircleAvatar(
                        radius: 30,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              recipient.avatarUrl!,
                              height: 60,
                              width: 60,
                              fit: BoxFit.fill,
                            ))),
                    SizedBox(width: w * 3.6),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: w * 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              recipient.displayName!,
                              style: TextStyle(
                                color: Color(0xff00AEFF),
                                fontSize: w * 4.8,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              recipient.occupation!,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: w * 4.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
