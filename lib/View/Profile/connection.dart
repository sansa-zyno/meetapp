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
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: h * 16),
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
                                        shaderCallback: (rect) =>
                                            LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.indigoAccent,
                                                  Colors.blue,
                                                  Colors.green
                                                ]).createShader(rect),
                                        child: Text(qdocs.docs[index]['title'],
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold))),
                                    subtitle: ShaderMask(
                                        blendMode: BlendMode.srcIn,
                                        shaderCallback: (rect) => LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.indigoAccent, Colors.blue, Colors.green]).createShader(rect),
                                        child: Text(
                                          qdocs.docs[index]['buyer_name'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    trailing: ShaderMask(
                                        blendMode: BlendMode.srcIn,
                                        shaderCallback: (rect) => LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.indigoAccent, Colors.blue, Colors.green]).createShader(rect),
                                        child: Text(
                                          qdocs.docs[index]['date'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
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
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    trailing: ShaderMask(
                                        blendMode: BlendMode.srcIn,
                                        shaderCallback: (rect) => LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.indigoAccent, Colors.blue, Colors.green]).createShader(rect),
                                        child: Text(
                                          qdocs.docs[index]['date'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ))))
                        : Container();
                  }),
            ],
          ),
          SafeArea(
            child: Container(
              height: 90,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white54,
                border: Border.all(
                  color: Colors.grey,
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
                              color: Colors.grey, size: 30),
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
                      child: ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (rect) => LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.indigoAccent,
                              Colors.blue,
                              Colors.green
                            ]).createShader(rect),
                        child: Text(
                          'Connections',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
