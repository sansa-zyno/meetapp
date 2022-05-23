import 'package:flutter/material.dart';

class DetailsData extends StatefulWidget {
  String? bannerImage;
  String? titleText;
  String? picture;
  String? priceText;
  String? priceText1;
  String? availability;
  int? likesText;
  // String categoryText;
  String? detailText;
  String? location;

  DetailsData(
      {this.bannerImage,
      this.titleText,
      this.picture,
      this.priceText,
      this.priceText1,
      this.availability,
      this.likesText,
      // this.categoryText,
      this.detailText,
      this.location});

  @override
  _DetailsDataState createState() => _DetailsDataState();
}

class _DetailsDataState extends State<DetailsData> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    return SafeArea(
      child: Column(
        children: [
          Container(
            height: 810,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 315,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Image.network(
                        widget.bannerImage!,
                        width: double.infinity,
                        height: 315,
                        fit: BoxFit.fill,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_outlined,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: w * 3.6, vertical: h * 1.6),
                  child: Text(
                    widget.titleText!,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontSize: 36,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 3.6),
                  child: RichText(
                    text: TextSpan(
                        text: widget.priceText,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: 32,
                        ),
                        children: [
                          TextSpan(
                              text: widget.priceText1,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 24,
                              )),
                        ]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: w * 3.6, vertical: h * 1.1),
                  child: Row(
                    children: [
                      Icon(
                        Icons.timelapse,
                      ),
                      SizedBox(
                        width: w * 1.2,
                      ),
                      Text(
                        widget.availability!,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: w * 3.6, vertical: h * 0.5),
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite_border_outlined,
                      ),
                      SizedBox(
                        width: w * 1.2,
                      ),
                      Text(
                        "${widget.likesText}",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: w * 3.6, vertical: h * 0.5),
                  child: Row(
                    children: [
                      Icon(Icons.location_city),
                      SizedBox(
                        width: w * 1.2,
                      ),
                      Text(
                        widget.location!,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: w * 3.6, vertical: h * 0.5),
                    child: Text(
                      widget.detailText!,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
