import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:meeter/View/Profile/edit_demand_setup.dart';
import 'package:provider/provider.dart';

class Demands extends StatefulWidget {
  Demands({Key? key}) : super(key: key);

  @override
  _DemandsState createState() => _DemandsState();
}

class _DemandsState extends State<Demands> {
  late UserController _currentUser;

  bool show = true;

  @override
  Widget build(BuildContext context) {
    _currentUser = Provider.of<UserController>(context);
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('demands')
          .doc(_currentUser.getCurrentUser.uid)
          .collection('demand')
          .snapshots(),
      builder: (ctx, snapshot) {
        QuerySnapshot? query = snapshot.data as QuerySnapshot?;
        return snapshot.hasData
            ? ListView.builder(
                itemCount: query!.docs.length,
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  query.docs[index]['demand_title'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  query.docs[index]['demand_description'],
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(query.docs[index]['demand_location']),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(query.docs[index]['demand_price']
                                    .toString()),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: [
                              MaterialButton(
                                  color: Colors.blue,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) => EditDemandSetup(
                                                query.docs[index])));
                                  },
                                  child: Text(
                                    "Edit",
                                    style: TextStyle(color: Colors.white),
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              MaterialButton(
                                  color: Colors.red,
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('demands')
                                        .doc(_currentUser.getCurrentUser.uid)
                                        .collection('demand')
                                        .doc(query.docs[index].id)
                                        .delete();
                                  },
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ]),
                          )
                        ],
                      ),
                    ),
                  );
                })
            : Container();
      },
    );
  }
}
