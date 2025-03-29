import 'package:flutter/material.dart';
import 'package:busmap/widgets//notification_item.dart';
import 'article_list_screen.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Tin tức và thông báo',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Thông báo'),
              Tab(text: 'Tin tức'),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: const TabBarView(
          children: [
            ArticleListScreen(), // Thay NotificationTab bằng ArticleListScreen
            NewsTab(),
          ],
        ),
      ),
    );
  }
}

class NewsTab extends StatelessWidget {
  const NewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        NotificationItem(
          isRead: false,
          date: '28/12/23',
          title: 'Bản của Giáp Thin đã đến rồi 🎉',
        ),
      ],
    );
  }
}