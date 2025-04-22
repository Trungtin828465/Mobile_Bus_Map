
import 'package:flutter/material.dart';
import 'package:busmap/models/Admin/BaiViet.dart';
import 'package:busmap/service/Admin/api_baiviet.dart';
import 'package:busmap/widgets//Admin/dashboard_appbar.dart';
import 'package:busmap/widgets//Admin/dashboard_drawer.dart';
import 'package:busmap/widgets//Admin/dashboard_footer.dart';
import 'package:busmap/screens/Admin/ArticleScreen.dart';
import 'package:busmap/screens/Admin/CreateArticleScreen.dart';
import 'package:busmap/screens/Admin/EditArticleScreen.dart';

class ArticleScreen extends StatefulWidget {
  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<Article>> futureArticles;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureArticles = apiService.fetchArticles();
  }

  void _refreshArticles() {
    setState(() {
      futureArticles = apiService.fetchArticles(); // Cập nhật danh sách
    });
  }

  Future<void> _deleteArticle(int articleId) async {
    bool success = await apiService.deleteArticle(articleId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xóa bài viết thành công!')),
      );
      setState(() {
        futureArticles = apiService.fetchArticles(); // Cập nhật danh sách
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi xóa bài viết!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: DashboardAppBar(scaffoldKey: _scaffoldKey),
      drawer: const DashboardDrawer(),
      body: Column(
        children: [
          Expanded(child: ArticleBody(futureArticles: futureArticles, onRefresh: _refreshArticles, onDelete: _deleteArticle)),
          const DashboardFooter(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddArticleScreen()),
          );

          if (result == true) {
            _refreshArticles();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class ArticleBody extends StatelessWidget {
  final Future<List<Article>> futureArticles;
  final VoidCallback onRefresh;
  final Function(int) onDelete; // Thêm callback cho xóa

  const ArticleBody({
    Key? key,
    required this.futureArticles,
    required this.onRefresh,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: futureArticles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Không có bài viết nào.'));
        }

        List<Article> articles = snapshot.data!;
        return ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];

            return Card(
              margin: EdgeInsets.all(10),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  article.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text('Tác giả: ${article.author} - Ngày: ${article.datePosted}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleDetailScreen(article: article),
                    ),
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditArticleScreen(article: article),
                          ),
                        );

                        if (result == true) {
                          onRefresh();
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        // Xác nhận trước khi xóa
                        bool? confirm = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Xác nhận xóa'),
                            content: Text('Bạn có chắc muốn xóa bài viết "${article.title}"?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text('Hủy'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text('Xóa'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await onDelete(article.id); // Gọi hàm xóa
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}