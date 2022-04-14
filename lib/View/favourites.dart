import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meeter/Widgets/MeeterAppBar/meeterAppBar.dart';
import 'package:meeter/View/Explore_Seller/detail_screen.dart';
import 'package:meeter/View/Explore_buyer/detail_buyer_screen.dart';
import 'package:meeter/Providers/user_controller.dart';
import 'package:provider/provider.dart';
import 'package:meeter/Model/demand_data.dart';
import 'package:meeter/Model/meetup_data.dart';

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width / 100;
    final h = MediaQuery.of(context).size.height / 100;
    UserController _currentUser = Provider.of<UserController>(context);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 100),
                Column(
                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('favourites')
                            .doc(_currentUser.getCurrentUser.uid)
                            .collection('favourite')
                            .snapshots(),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? GridView.builder(
                                  physics: ClampingScrollPhysics(),
                                  //padding: EdgeInsets.symmetric(vertical: 16),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                  ),
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    List<QueryDocumentSnapshot> favCollection =
                                        snapshot.data!.docs;
                                    return Stack(children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: w * 2.5,
                                          vertical: h * 1.2,
                                        ),
                                        child: GestureDetector(
                                          child: Container(
                                            height: w * 50,
                                            alignment: Alignment.centerLeft,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.blue),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                15.0),
                                                        topRight:
                                                            Radius.circular(
                                                                15.0),
                                                      ),
                                                    ),
                                                    height: w * 28,
                                                    width: double.infinity,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: favCollection[
                                                                      index]
                                                                  ['type'] ==
                                                              "service"
                                                          ? Image.network(
                                                              favCollection[
                                                                      index][
                                                                  "meetup_bannerImage"],
                                                              fit: BoxFit.fill,
                                                            )
                                                          : Image.network(
                                                              favCollection[
                                                                      index][
                                                                  "demand_bannerImage"],
                                                              fit: BoxFit.fill,
                                                            ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                          w * 1.5),
                                                      child: favCollection[
                                                                      index]
                                                                  ['type'] ==
                                                              "service"
                                                          ? Text(
                                                              favCollection[
                                                                      index][
                                                                  "meetup_title"],
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 17.0,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )
                                                          : Text(
                                                              favCollection[
                                                                      index][
                                                                  "demand_title"],
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 17.0,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                          w * 1.1),
                                                      child: favCollection[
                                                                      index]
                                                                  ['type'] ==
                                                              "service"
                                                          ? Text(
                                                              "\$${favCollection[index]['meetup_price']} per 30min",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontSize: 17.0,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )
                                                          : Text(
                                                              "\$${favCollection[index]['demand_price']} per 30min",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontSize: 17.0,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                    ),
                                                  ),
                                                ]),
                                          ),
                                          onTap: () {
                                            if (favCollection[index]['type'] ==
                                                "service") {
                                              MeetupData meetup =
                                                  MeetupData.fromSnap(
                                                      favCollection[index]);

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailsScreen(meetup),
                                                ),
                                              );
                                            } else {
                                              DemandData demand =
                                                  DemandData.fromSnap(
                                                      favCollection[index]);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailsBuyerScreen(
                                                          demand),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: InkWell(
                                            onTap: () async {
                                              await FirebaseFirestore.instance
                                                  .collection('favourites')
                                                  .doc(_currentUser
                                                      .getCurrentUser.uid)
                                                  .collection('favourite')
                                                  .doc(favCollection[index].id)
                                                  .delete();
                                            },
                                            child: Container(
                                              height: 30,
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]);
                                  },
                                )
                              : Container();
                        }),
                  ],
                )
              ],
            ),
          ),
          MeeterAppbar(
            title: "Favourites",
            icon: Icons.arrow_back_ios_outlined,
          ),
        ],
      ),
    );
  }
}
