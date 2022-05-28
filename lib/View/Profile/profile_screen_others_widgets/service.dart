import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Services extends StatelessWidget {
  String id;
  Services(this.id);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('meeters')
          .doc(id)
          .collection('meeter')
          .snapshots(),
      builder: (ctx, snapshot) {
        QuerySnapshot? query = snapshot.data as QuerySnapshot?;
        return snapshot.hasData
            ? ListView.builder(
                itemCount: query!.docs.length,
                padding: EdgeInsets.symmetric(vertical: 8),
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
                                  query.docs[index]['meetup_title'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  query.docs[index]['meetup_description'],
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(query.docs[index]['meetup_location']),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(query.docs[index]['meetup_price']
                                    .toString()),
                              ],
                            ),
                          ),
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
