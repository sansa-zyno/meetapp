import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 30.0),
          child: Text(
            'Categories',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
        Container(
          height: 150,
          child: ListView.builder(
            itemCount: 6,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(
                  (MediaQuery.of(context).size.width / 20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  height: 156,
                  width: 130,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: height / 30.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.music_note_outlined,
                          color: Colors.green,
                        ),
                        Text(
                          'Music',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }
}
