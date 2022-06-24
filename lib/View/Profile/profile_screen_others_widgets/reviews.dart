import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Review extends StatelessWidget {
  String id;
  Review(this.id);
  String timesAgo = "";
  calcTimesAgo(DateTime other) {
    Duration dur = DateTime.now().difference(other);
    print(dur.inHours);
    if (dur.inHours < 24) {
      timesAgo = "moments ago";
    }
    if (dur.inDays > 0 && dur.inDays < 7) {
      timesAgo =
          dur.inDays == 1 ? "${dur.inDays} day ago" : "${dur.inDays} days ago";
    }
    if (dur.inDays >= 7 && dur.inDays < 30) {
      timesAgo = (dur.inDays / 7).truncate() == 1
          ? "${(dur.inDays / 7).truncate()} week ago"
          : "${(dur.inDays / 7).truncate()} weeks ago";
    }
    if (dur.inDays >= 30 && dur.inDays < 365) {
      timesAgo = (dur.inDays / 30).truncate() == 1
          ? "${(dur.inDays / 30).truncate()} month ago"
          : "${(dur.inDays / 30).truncate()} months ago";
    }
    if (dur.inDays >= 365) {
      timesAgo = (dur.inDays / 365).truncate() == 1
          ? "${(dur.inDays / 365).truncate()} year ago"
          : "${(dur.inDays / 365).truncate()} years ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('reviews')
          .doc(id)
          .collection('review')
          .orderBy("ts", descending: true)
          .snapshots(),
      builder: (ctx, snapshot) {
        QuerySnapshot? qdocs = snapshot.data as QuerySnapshot?;
        return snapshot.hasData
            ? qdocs!.docs.isNotEmpty
                ? ListView.builder(
                    itemCount: qdocs.docs.length,
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      calcTimesAgo(qdocs.docs[index]['ts'].toDate());
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 3),
                        child: Card(
                            child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                qdocs.docs[index]['raterImage'],
                                fit: BoxFit.fill,
                                height: 60,
                                width: 60,
                              ),
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
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
                                    child: Text(qdocs.docs[index]['raterName'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                              ),
                              SizedBox(width: 8),
                              Text("${qdocs.docs[index]['rating']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.orange,
                                  ))
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "${qdocs.docs[index]['comment']}",
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(height: 8),
                              qdocs.docs[index]['extra'] != ""
                                  ? Text(
                                      "${qdocs.docs[index]['extra']}",
                                      textAlign: TextAlign.start,
                                    )
                                  : Container(),
                              SizedBox(height: 8),
                              Text("Published $timesAgo",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic)),
                            ],
                          ),
                        )),
                      );
                    })
                : Column(
                    children: [
                      SizedBox(height: 100),
                      Center(child: Text("No reviews to show")),
                    ],
                  )
            : Container();
      },
    );
  }
}
