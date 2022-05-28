import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Connection extends StatefulWidget {
  const Connection({
    Key? key,
  }) : super(key: key);

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
      appBar: AppBar(
        toolbarHeight: 90,
        flexibleSpace: SafeArea(
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
              ],
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("connections")
              .where("meeters", arrayContains: auth!.currentUser!.uid)
              .snapshots(),
          builder: (ctx, snapshot) {
            QuerySnapshot? qdocs = snapshot.data as QuerySnapshot?;
            return snapshot.hasData && qdocs!.docs.isNotEmpty
                ? ListView.builder(
                    physics: ClampingScrollPhysics(),
                    itemCount: qdocs!.docs.length,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    shrinkWrap: true,
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
                            title: ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (rect) => LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [Colors.indigoAccent, Colors.blue, Colors.green])
                                    .createShader(rect),
                                child: Text(qdocs.docs[index]['title'],
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))),
                            subtitle: ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (rect) => LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [Colors.indigoAccent, Colors.blue, Colors.green])
                                    .createShader(rect),
                                child: Text(
                                  qdocs.docs[index]['buyer_name'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            trailing: ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (rect) => LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.indigoAccent, Colors.blue, Colors.green]).createShader(rect),
                                child: Text(
                                  qdocs.docs[index]['date'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )))
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
                            title: ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (rect) => LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.indigoAccent, Colors.blue, Colors.green]).createShader(rect),
                                child: Text(
                                  qdocs.docs[index]['title'],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                            subtitle: ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (rect) => LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.indigoAccent, Colors.blue, Colors.green]).createShader(rect),
                                child: Text(
                                  qdocs.docs[index]['seller_name'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            trailing: ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (rect) => LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.indigoAccent, Colors.blue, Colors.green]).createShader(rect),
                                child: Text(
                                  qdocs.docs[index]['date'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ))))
                : Center(
                    child: Container(
                    child: Text("No connections to show"),
                  ));
          }),
    );
  }
}
