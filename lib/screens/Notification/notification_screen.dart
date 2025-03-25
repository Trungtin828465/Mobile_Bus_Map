import 'package:flutter/material.dart';
import '../../widgets/notification_item.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tin tức và thông báo', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Thông báo'),
              Tab(text: 'Tin tức'),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[300],
          ),
        ),
        body: TabBarView(
          children: [
            NotificationTab(),
            NewsTab(),
          ],
        ),
      ),
    );
  }
}

class NotificationTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: [
        NotificationItem(isRead: false, date: '02/02/24', title: 'Tết đến rồi, bạn vé chưa chùa?'),
      ],
    );
  }
}

class NewsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: [
        NotificationItem(isRead: false, date: '28/12/23', title: 'Bản của Giáp Thin đã đến rồi 🎉'),
      ],
    );
  }
}
