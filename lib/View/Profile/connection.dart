import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: h * 16),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("connections")
                      .where("type", isEqualTo: "service")
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
                                ? ListTile(
                                    leading: CircleAvatar(
                                      radius: 30,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          qdocs.docs[index]['buyer_image'],
                                          fit: BoxFit.fill,
                                          height: 60,
                                          width: 60,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      qdocs.docs[index]['title'],
                                      style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold,
                                          color: widget.clr == Color(0xff00AEFF)
                                              ? Color(0xff00AEFF)
                                              : Colors.green),
                                    ),
                                    subtitle: Text(
                                      qdocs.docs[index]['buyer_name'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: widget.clr == Color(0xff00AEFF)
                                              ? Color(0xff00AEFF)
                                              : Colors.green),
                                    ),
                                    trailing: Text(
                                      qdocs.docs[index]['date'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: widget.clr == Color(0xff00AEFF)
                                              ? Color(0xff00AEFF)
                                              : Colors.green),
                                    ),
                                  )
                                : ListTile(
                                    leading: CircleAvatar(
                                      radius: 30,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          qdocs.docs[index]['seller_image'],
                                          fit: BoxFit.fill,
                                          height: 60,
                                          width: 60,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      qdocs.docs[index]['title'],
                                      style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold,
                                          color: widget.clr == Color(0xff00AEFF)
                                              ? Color(0xff00AEFF)
                                              : Colors.green),
                                    ),
                                    subtitle: Text(
                                      qdocs.docs[index]['seller_name'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: widget.clr == Color(0xff00AEFF)
                                              ? Color(0xff00AEFF)
                                              : Colors.green),
                                    ),
                                    trailing: Text(
                                      qdocs.docs[index]['date'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: widget.clr == Color(0xff00AEFF)
                                              ? Color(0xff00AEFF)
                                              : Colors.green),
                                    ),
                                  ))
                        : Container();
                  }),
            ],
          ),
          widget.clr == Color(0xff00AEFF)
              ? SafeArea(
                  child: Container(
                    height: 90,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Color(0xff00AEFF),
                        width: 1,
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
                          flex: 1,
                          child: GestureDetector(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: w * 1.9, vertical: h * 0.8),
                                child: Icon(Icons.arrow_back_ios_outlined,
                                    color: Color(0xff00AEFF), size: 30),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Connections",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xff00AEFF),
                                fontSize: w * 6.0,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: w * 1.9, vertical: h * 0.8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SafeArea(
                  child: Container(
                    height: 90,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.green,
                        width: 1,
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
                          flex: 1,
                          child: GestureDetector(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: w * 1.9, vertical: h * 0.8),
                                child: Icon(Icons.arrow_back_ios_outlined,
                                    color: Colors.green, size: 30),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Connections",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: w * 6.0,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: w * 1.9, vertical: h * 0.8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
