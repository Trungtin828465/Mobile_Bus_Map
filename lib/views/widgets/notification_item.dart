import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final bool isRead;
  final String date;
  final String title;

  NotificationItem({required this.isRead, required this.date, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      color: isRead ? Colors.white : Colors.grey[200],
      child: ListTile(
        leading: Icon(Icons.notifications, color: isRead ? Colors.grey : Colors.green),
        title: Text(
          title,
          style: TextStyle(fontWeight: isRead ? FontWeight.normal : FontWeight.bold),
        ),
        subtitle: Text(date, style: TextStyle(color: Colors.grey)),
        trailing: isRead ? null : Icon(Icons.circle, size: 12, color: Colors.red),
      ),
    );
  }
}
