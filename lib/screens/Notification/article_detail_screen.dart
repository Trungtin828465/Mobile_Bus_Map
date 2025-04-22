import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:busmap/models/Khanh/article.dart';
import 'package:busmap/service/Khanh/article_service.dart';

class ArticleDetailScreen extends StatefulWidget {
  final int articleId;

  const ArticleDetailScreen({super.key, required this.articleId});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  late Future<Article> futureArticle;

  @override
  void initState() {
    super.initState();
    print('Article ID: ${widget.articleId}'); // In log để kiểm tra ID
    futureArticle = ArticleService().getArticleById(widget.articleId);
  }

  // Hàm để xen kẽ nội dung và ảnh
  List<Widget> buildContentWithImages(Article article) {
    List<Widget> widgets = [];
    final contents = article.noiDungBaiViets;
    final images = article.anhBaiViets;

    // Sắp xếp nội dung theo thứ tự thuTu
    contents.sort((a, b) => a.thuTu.compareTo(b.thuTu));

    // Tính toán vị trí để xen kẽ ảnh
    int contentCount = contents.length;
    int imageCount = images.length;
    double step = contentCount / (imageCount + 1); // Khoảng cách giữa các ảnh

    int contentIndex = 0;
    int imageIndex = 0;

    // Thêm khoảng cách trước khi hiển thị nội dung (giống code dưới)
    widgets.add(const SizedBox(height: 8));

    // Xen kẽ nội dung và ảnh
    for (int i = 0; i < contentCount + imageCount; i++) {
      // Kiểm tra xem có nên chèn ảnh tại vị trí này không
      if (imageIndex < imageCount && i == ((imageIndex + 1) * step).floor()) {
        final image = images[imageIndex];
        widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  image.duongDan,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'Không thể tải hình ảnh',
                      style: TextStyle(color: Colors.red),
                    );
                  },
                ),
              ),
              const SizedBox(height: 4),
              Text(
                image.moTa,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ));
        imageIndex++;
      } else if (contentIndex < contentCount) {
        // Thêm nội dung
        final content = contents[contentIndex];
        widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            ' ${content.noiDung}', // Thụt đầu dòng giống code dưới
            style: const TextStyle(fontSize: 16),
          ),
        ));
        contentIndex++;
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết bài viết'),
      ),
      body: FutureBuilder<Article>(
        future: futureArticle,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final article = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề bài viết
                  Text(
                    article.tieuDe,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Tác giả và ngày đăng
                  Text(
                    'Tác giả: ${article.tacGia} - Ngày: ${DateFormat('yyyy-MM-dd').format(article.ngayDang)}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 16),
                  // Hiển thị nội dung và ảnh xen kẽ
                  ...buildContentWithImages(article),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            String errorMessage = snapshot.error.toString();
            if (errorMessage.contains('Status 404')) {
              errorMessage = 'Bài viết không tồn tại hoặc đã bị xóa.';
            } else {
              errorMessage = 'Không thể tải bài viết: $errorMessage';
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    errorMessage,
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futureArticle = ArticleService().getArticleById(widget.articleId);
                      });
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}