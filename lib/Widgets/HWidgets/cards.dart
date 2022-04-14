import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cards extends StatelessWidget {
  final List<DocumentSnapshot> docs;
  Cards({required this.docs});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 30.0),
            child: Text(
              'Trending',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 25),
            ),
          ),
          Container(
            height: 235,
            child: ListView.builder(
              itemCount: 6,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(
                    15,
                  ),
                  child: Container(
                    width: 380,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(
                        10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Padding(
                              padding: EdgeInsets.all(
                                10,
                              ),
                              child: Text(
                                'Creative UI/UX\nDesigner',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            height: 125,
                            width: width / 1.18,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/data/card.png',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: height / 100),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.greenAccent[700],
                                      borderRadius: BorderRadius.circular(80),
                                    ),
                                    height: 50,
                                    width: 50,
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    'Jesse ShowWalter',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints.tightFor(
                                  width: 80,
                                  height: 40,
                                ),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Meet',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.greenAccent[700],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
