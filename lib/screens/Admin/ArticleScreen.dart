import 'package:flutter/material.dart';
import 'package:busmap/models/Admin/BaiViet.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;
  const ArticleDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Hàm xây dựng nội dung và ảnh theo thứ tự
    List<Widget> buildContentWithImages() {
      List<Widget> widgets = [];
      final contents = article.contents;
      final images = article.images;

      // Sắp xếp nội dung theo thứ tự
      contents.sort((a, b) => a.order.compareTo(b.order));

      // Ghép đôi nội dung và ảnh theo thứ tự
      int imageIndex = 0;

      for (int contentIndex = 0; contentIndex < contents.length; contentIndex++) {
        final content = contents[contentIndex];

        // Thêm nội dung với animation
        widgets.add(
          AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 500),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                content.content,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5, // Khoảng cách dòng
                  fontFamily: 'Roboto', // Font chữ dễ đọc
                ),
              ),
            ),
          ),
        );

        // Thêm ảnh nếu có ảnh tương ứng
        if (imageIndex < images.length) {
          final image = images[imageIndex];
          final String localImagePath = 'assets/img/${image.url}';
          widgets.add(
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 500),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 4), // Đổ bóng
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          localImagePath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 250, // Tăng chiều cao ảnh để nổi bật hơn
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 250,
                              color: Colors.grey[200],
                              child: const Center(
                                child: Text(
                                  'Không thể tải hình ảnh',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      image.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          imageIndex++;
        }
      }

      return widgets;
    }

    // Lấy ảnh bìa (ảnh đầu tiên)
    Widget buildCoverImage() {
      if (article.images.isNotEmpty) {

        final coverImage = article.images[0];
        final String coverImagePath = 'assets/img/${coverImage.url}';
        return Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Image.asset(
              coverImagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 300,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Text(
                      'Không thể tải ảnh bìa',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar với ảnh bìa
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  buildCoverImage(),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          style: const TextStyle(
                            fontSize: 28,

                            color: Colors.black,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                offset: Offset(1, 1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Tác giả: ${article.author}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.black,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Ngày: ${article.datePosted.toString().substring(0, 10)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.blueAccent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          // Nội dung bài viết
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  ...buildContentWithImages(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}