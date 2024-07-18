import 'package:flutter/material.dart';

class ExploreSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(0.0, 10, 0, 0),
          child: Text('Explore Other Events',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Text('See what\'s happening around you',
              style: TextStyle(color: Colors.grey)),
        ),
        // Container(
        //   margin: EdgeInsets.all(16.0),
        //   height: 200,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(8.0),
        //     image: DecorationImage(
        //       image: AssetImage(
        //           'assets/explore_event.jpg'), // Replace with your own image
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        // ),
        // Image.network(
        //   'https://firebasestorage.googleapis.com/v0/b/hangout-ef87b.appspot.com/o/westfield-albany.jpg?alt=media',
        //   // Specify your Firebase Storage URL here
        //   loadingBuilder: (BuildContext context, Widget child,
        //       ImageChunkEvent? loadingProgress) {
        //     if (loadingProgress == null) return child;
        //     return CircularProgressIndicator(
        //       value: loadingProgress.expectedTotalBytes != null
        //           ? loadingProgress.cumulativeBytesLoaded /
        //               loadingProgress.expectedTotalBytes!
        //           : null,
        //     );
        //   },
        //   errorBuilder: (context, error, stackTrace) {
        //     return Text('Error loading image');
        //   },
        // ),
      ],
    );
  }
}
