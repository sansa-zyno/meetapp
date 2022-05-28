import 'package:flutter/material.dart';
import 'package:meeter/Model/meetup_data.dart';
import 'package:meeter/View/Explore_Seller/detail_screen.dart';

class MoreLists extends StatelessWidget {
  final String? picture;
  final List<MeetupData> meetersCollection;

  MoreLists({this.picture, required this.meetersCollection});

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    return Column(
      children: <Widget>[
        GridView.builder(
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 16),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: meetersCollection.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 1.5,
                vertical: h * 1.2,
              ),
              child: GestureDetector(
                child: Container(
                  height: w * 30,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                          ),
                          height: w * 28,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              meetersCollection[index].meetup_bannerImage!,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(w * 1.5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  meetersCollection[index].meetup_title!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    fontSize: 17.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(w * 1.1),
                          child: Text(
                            "\$${meetersCollection[index].meetup_price} per 30min",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 17.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ]),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailsScreen(meetersCollection[index]),
                    ),
                  );
                },
              ),
            );
          },
        )
      ],
    );
  }
}
