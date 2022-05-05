import 'package:flutter/material.dart';
import 'package:meeter/Model/meetup_data.dart';
import 'package:meeter/View/Explore_Seller/detail_screen.dart';
import 'package:meeter/View/Explore_Seller/more_screen.dart';

class MainLists extends StatelessWidget {
  final Color? clr;
  final Color? clr1;
  final List<MeetupData> meetersCollection;
  final String? mainText;

  MainLists(
      {required this.meetersCollection, this.mainText, this.clr, this.clr1});

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      height: 156,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: w * 2.3, vertical: h * 2.2),
                  child: Text(
                    mainText!,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ButtonBar(
                  //alignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoreScreen(meetersCollection),
                          ),
                        );
                      },
                      child: Text(
                        '+ more',
                        style: TextStyle(
                          color: clr1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.3),
         meetersCollection.isNotEmpty
             ? Container(
            height: 156,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: meetersCollection.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: h * 2.4, vertical: w * 1.1),
                  child: GestureDetector(
                    child: Container(
                      height: 156,
                      width: 130,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          border: Border.all(color: clr!),
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 90,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                              child: Image.network(
                                meetersCollection[index].meetup_bannerImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: h * 0.7, vertical: w * 0.3),
                              child: Text(
                                meetersCollection[index].meetup_title!,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: h * 0.7, vertical: w * 0.3),
                              child: Text(
                                "\$${meetersCollection[index].meetup_price} per 30min",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) =>
                              DetailsScreen(meetersCollection[index])));
                    },
                  ),
                );
              },
            ),
          )
              : Container(
            height: 156,
            child: const Center(
              child: Text("No Services Right Now!"),
            ),
          ),
        ],
      ),
    );
  }
}
