import 'package:flutter/material.dart';

class RouteItemWidget extends StatelessWidget {
  final String routeNumber;
  final String routeName;
  final String time;
  final String price;
  final String rating;

  RouteItemWidget({
    required this.routeNumber,
    required this.routeName,
    required this.time,
    required this.price,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            routeNumber,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(routeName),
        // subtitle: Row(
        //   children: [
        //     Icon(Icons.access_time, size: 16, color: Colors.grey),
        //     SizedBox(width: 4),
        //     Text(time),
        //     SizedBox(width: 16),
        //     Icon(Icons.monetization_on, size: 16, color: Colors.grey),
        //     SizedBox(width: 4),
        //     Text(price),
        //   ],
        // ),
        // trailing: Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Icon(Icons.favorite_border, color: Colors.grey),
        //     SizedBox(width: 8),
        //     Text(rating),
        //     Icon(Icons.star, color: Colors.grey, size: 16),
        //   ],
        // ),
      ),
    );
  }
}