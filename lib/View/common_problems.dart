import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommonProblems extends StatefulWidget {
  @override
  _CommonProblemsState createState() => _CommonProblemsState();
}

class _CommonProblemsState extends State<CommonProblems> {
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
                      "Common Problems",
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
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Common Problems")
              .snapshots(),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.docs.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    padding: EdgeInsets.only(top: 15),
                    itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 8),
                          child: Column(
                            children: [
                              Text(
                                "${index + 1}.  ${snapshot.data!.docs[index]['question']}",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "${snapshot.data!.docs[index]['answer']}",
                                style: TextStyle(
                                    fontSize: 16, fontStyle: FontStyle.italic),
                              )
                            ],
                          ),
                        ))
                : Container();
          }),
    );
  }
}
