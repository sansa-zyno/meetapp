import 'package:flutter/material.dart';
import 'package:meeter/Model/user.dart';
import 'package:meeter/Widgets/HWidgets/chat_appbar.dart';
import 'package:meeter/Widgets/HWidgets/chat_bottombar.dart';
import 'package:meeter/Widgets/HWidgets/chat_messages.dart';

class ChatScreen extends StatefulWidget {
  final OurUser recipient;
  ChatScreen(this.recipient);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width / 100;
    final h = MediaQuery.of(context).size.height / 100;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: h * 13.7),
                ChatMessages(widget.recipient),
              ],
            ),
          ),
          ChatAppBar(
            recipient: widget.recipient,
            icon: Icons.arrow_back,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ChatBottomBar(widget.recipient),
          ),
        ],
      ),
    );
  }
}
