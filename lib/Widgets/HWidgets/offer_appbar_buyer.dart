import 'package:flutter/material.dart';

class OfferAppBarBuyer extends StatelessWidget {
  IconData? icon;
  final IconData? icon2;
  final IconData? icon3;
  final String? bartitle;
  final String? name;
  final String? work;
  final String? price;
  final String? price1;
  final String? picture;

  OfferAppBarBuyer(
      {this.icon,
      this.icon2,
      this.icon3,
      this.bartitle,
      this.name,
      this.work,
      this.price,
      this.price1,
      this.picture});

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width / 100;
    var h = MediaQuery.of(context).size.height / 100;
    return SafeArea(
      child: Container(
        height: h * 29,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.green,
            width: w * 0.2,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: w * 2.4, vertical: h * 1.1),
              child: Row(
                children: [
                  GestureDetector(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: w * 1.9, vertical: h * 0.8),
                        child: Icon(icon, color: Colors.green, size: w * 7.3),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 25),
                  Text(
                    bartitle!,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: w * 6.0,
                    ),
                  ),
                  GestureDetector(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: w * 1.9, vertical: h * 0.8),
                        child: Icon(icon2,
                            color: Color(0xff00AEFF), size: w * 7.3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: w * 2.4, vertical: h * 2.2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    height: h * 13.4,
                    width: w * 29.2,
                    child: picture == ""
                        ? Container()
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              picture!,
                              fit: BoxFit.fill,
                            ),
                          ),
                  ),
                ),
                Container(
                  height: h * 19,
                  width: 236,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 236,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              icon3,
                              color: Colors.green,
                              size: 28,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                name!,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: h * 1.1,
                      ),
                      Flexible(
                        child: Text(
                          work!,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: h * 1.1,
                      ),
                      RichText(
                        text: TextSpan(
                            text: price,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: price1,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: w * 4.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
