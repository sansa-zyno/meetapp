import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meeter/View/Profile/profile_screen_others.dart';

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
              .orderBy("ts", descending: true)
              .snapshots(),
          builder: (ctx, snapshot) {
            QuerySnapshot? qdocs = snapshot.data as QuerySnapshot?;
            return snapshot.hasData
                ? qdocs!.docs.isNotEmpty
                    ? ListView.builder(
                        physics: ClampingScrollPhysics(),
                        itemCount: qdocs.docs.length,
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) {
                          return qdocs.docs[index]['seller_id'] ==
                                  auth!.currentUser!.uid
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  ProfileScreenOther(
                                                      id: qdocs.docs[index]
                                                          ['buyer_id'])));
                                    },
                                    child: Card(
                                      elevation: 3,
                                      child: ListTile(
                                          leading: CircleAvatar(
                                            radius: 30,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.network(
                                                qdocs.docs[index]
                                                    ['buyer_image'],
                                                fit: BoxFit.fill,
                                                height: 60,
                                                width: 60,
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                              qdocs.docs[index]['buyer_name'],
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xff00AEFF),
                                              )),
                                          subtitle: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                ListView.builder(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: qdocs
                                                        .docs[index]["items"]
                                                        .length,
                                                    itemBuilder:
                                                        (context, idx) {
                                                      return Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              qdocs.docs[index]
                                                                      ['items']
                                                                  [idx]["item"],
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 25,
                                                          ),
                                                          Text(
                                                            qdocs.docs[index]
                                                                    ['items']
                                                                [idx]["date"],
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                              ]),
                                          trailing: Text(
                                            "${qdocs.docs[index]['meetingCount']}X",
                                            style: TextStyle(
                                              color: Color(0xff00AEFF),
                                            ),
                                          )),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  ProfileScreenOther(
                                                      id: qdocs.docs[index]
                                                          ['seller_id'])));
                                    },
                                    child: Card(
                                      elevation: 3,
                                      child: ListTile(
                                          leading: CircleAvatar(
                                            radius: 30,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.network(
                                                qdocs.docs[index]
                                                    ['seller_image'],
                                                fit: BoxFit.fill,
                                                height: 60,
                                                width: 60,
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            qdocs.docs[index]['seller_name'],
                                            style: TextStyle(
                                              color: Color(0xff00AEFF),
                                              fontSize: 18,
                                            ),
                                          ),
                                          subtitle: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                ListView.builder(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: qdocs
                                                        .docs[index]["items"]
                                                        .length,
                                                    itemBuilder:
                                                        (context, idx) {
                                                      return Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              qdocs.docs[index]
                                                                      ['items']
                                                                  [idx]["item"],
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 25,
                                                          ),
                                                          Text(
                                                            qdocs.docs[index]
                                                                    ['items']
                                                                [idx]["date"],
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                              ]),
                                          trailing: Text(
                                            "${qdocs.docs[index]['meetingCount']}X",
                                            style: TextStyle(
                                              color: Color(0xff00AEFF),
                                            ),
                                          )),
                                    ),
                                  ),
                                );
                        })
                    : Center(
                        child: Container(
                        child: Text("No connections to show"),
                      ))
                : Center(child: Container(child: CircularProgressIndicator()));
          }),
    );
  }
}
