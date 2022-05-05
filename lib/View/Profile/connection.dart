import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meeter/Widgets/MeeterAppBar/meeterAppBar.dart';
import 'package:meeter/Widgets/MeeterAppBar/meeterAppBar_buyer.dart';

class Connection extends StatefulWidget {
  final Color clr;
  const Connection({Key? key, required this.clr}) : super(key: key);

  @override
  State<Connection> createState() => _ConnectionState();
}

class _ConnectionState extends State<Connection> {
  FirebaseAuth? auth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth = FirebaseAuth.instance;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("connections")
                  .where("meeters", arrayContains: auth!.currentUser!.uid)
                  .snapshots(),
              builder: (ctx, snapshot) {
                QuerySnapshot? qdocs = snapshot.data as QuerySnapshot?;
                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: qdocs!.docs.length,
                        padding: EdgeInsets.symmetric(vertical: 8),
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (ctx, index) => qdocs.docs[index]
                                    ['seller_id'] ==
                                auth!.currentUser!.uid
                            ? Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.network(
                                            qdocs.docs[index]['buyer_image'],
                                            fit: BoxFit.fill,
                                            height: 60,
                                            width: 60,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Column(children: [
                                        ShaderMask(
                                          blendMode: BlendMode.srcIn,
                                          shaderCallback: (rect) =>
                                              LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                Colors.indigoAccent,
                                                Colors.blue,
                                                Colors.green
                                              ]).createShader(rect),
                                          child: Text(
                                            qdocs.docs[index]['title'],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        ShaderMask(
                                          blendMode: BlendMode.srcIn,
                                          shaderCallback: (rect) =>
                                              LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                Colors.indigoAccent,
                                                Colors.blue,
                                                Colors.green
                                              ]).createShader(rect),
                                          child: Text(
                                            qdocs.docs[index]['buyer_name'],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        ShaderMask(
                                          blendMode: BlendMode.srcIn,
                                          shaderCallback: (rect) =>
                                              LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                Colors.indigoAccent,
                                                Colors.blue,
                                                Colors.green
                                              ]).createShader(rect),
                                          child: Text(
                                            qdocs.docs[index]['date'],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                              )
                            : Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.network(
                                            qdocs.docs[index]['seller_image'],
                                            fit: BoxFit.fill,
                                            height: 60,
                                            width: 60,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Column(children: [
                                        ShaderMask(
                                          blendMode: BlendMode.srcIn,
                                          shaderCallback: (rect) =>
                                              LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                Colors.indigoAccent,
                                                Colors.blue,
                                                Colors.green
                                              ]).createShader(rect),
                                          child: Text(
                                            qdocs.docs[index]['title'],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        ShaderMask(
                                          blendMode: BlendMode.srcIn,
                                          shaderCallback: (rect) =>
                                              LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                Colors.indigoAccent,
                                                Colors.blue,
                                                Colors.green
                                              ]).createShader(rect),
                                          child: Text(
                                            qdocs.docs[index]['seller_name'],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        ShaderMask(
                                          blendMode: BlendMode.srcIn,
                                          shaderCallback: (rect) =>
                                              LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                Colors.indigoAccent,
                                                Colors.blue,
                                                Colors.green
                                              ]).createShader(rect),
                                          child: Text(
                                            qdocs.docs[index]['date'],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                              ))
                    : Container();
              }),
          widget.clr == Colors.blue
              ? MeeterAppbar(
                  title: "Connections",
                  icon: Icons.arrow_back_rounded,
                )
              : MeeterAppbarBuyer(
                  title: "Connections",
                  icon: Icons.arrow_back_rounded,
                )
        ],
      ),
    );
  }
}
