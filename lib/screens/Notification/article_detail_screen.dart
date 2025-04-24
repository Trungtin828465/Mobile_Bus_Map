// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:busmap/models/Khanh/article.dart';
// import 'package:busmap/service/Khanh/article_service.dart';
//
// class ArticleDetailScreen extends StatefulWidget {
//   final int articleId;
//
//   const ArticleDetailScreen({super.key, required this.articleId});
//
//   @override
//   State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
// }
//
// class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
//   late Future<Article> futureArticle;
//
//   @override
//   void initState() {
//     super.initState();
//     print('Article ID: ${widget.articleId}'); // In log để kiểm tra ID
//     futureArticle = ArticleService().getArticleById(widget.articleId);
//   }
//
//   // Hàm để xen kẽ nội dung và ảnh
//   List<Widget> buildContentWithImages(Article article) {
//     List<Widget> widgets = [];
//     final contents = article.noiDungBaiViets;
//     final images = article.anhBaiViets;
//
//     // Sắp xếp nội dung theo thứ tự thuTu
//     contents.sort((a, b) => a.thuTu.compareTo(b.thuTu));
//
//     // Tính toán vị trí để xen kẽ ảnh
//     int contentCount = contents.length;
//     int imageCount = images.length;
//     double step = contentCount / (imageCount + 1); // Khoảng cách giữa các ảnh
//
//     int contentIndex = 0;
//     int imageIndex = 0;
//
//     // Thêm khoảng cách trước khi hiển thị nội dung (giống code dưới)
//     widgets.add(const SizedBox(height: 8));
//
//     // Xen kẽ nội dung và ảnh
//     for (int i = 0; i < contentCount + imageCount; i++) {
//       // Kiểm tra xem có nên chèn ảnh tại vị trí này không
//       if (imageIndex < imageCount && i == ((imageIndex + 1) * step).floor()) {
//         final image = images[imageIndex];
//         widgets.add(Padding(
//           padding: const EdgeInsets.only(bottom: 8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.network(
//                   image.duongDan,
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                   height: 200,
//                   errorBuilder: (context, error, stackTrace) {
//                     return const Text(
//                       'Không thể tải hình ảnh',
//                       style: TextStyle(color: Colors.red),
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 image.moTa,
//                 style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//               ),
//             ],
//           ),
//         ));
//         imageIndex++;
//       } else if (contentIndex < contentCount) {
//         // Thêm nội dung
//         final content = contents[contentIndex];
//         widgets.add(Padding(
//           padding: const EdgeInsets.only(bottom: 8.0),
//           child: Text(
//             ' ${content.noiDung}', // Thụt đầu dòng giống code dưới
//             style: const TextStyle(fontSize: 16),
//           ),
//         ));
//         contentIndex++;
//       }
//     }
//
//     return widgets;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chi tiết bài viết'),
//       ),
//       body: FutureBuilder<Article>(
//         future: futureArticle,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final article = snapshot.data!;
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Tiêu đề bài viết
//                   Text(
//                     article.tieuDe,
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   // Tác giả và ngày đăng
//                   Text(
//                     'Tác giả: ${article.tacGia} - Ngày: ${DateFormat('yyyy-MM-dd').format(article.ngayDang)}',
//                     style: TextStyle(color: Colors.grey[700]),
//                   ),
//                   const SizedBox(height: 16),
//                   // Hiển thị nội dung và ảnh xen kẽ
//                   ...buildContentWithImages(article),
//                 ],
//               ),
//             );
//           } else if (snapshot.hasError) {
//             String errorMessage = snapshot.error.toString();
//             if (errorMessage.contains('Status 404')) {
//               errorMessage = 'Bài viết không tồn tại hoặc đã bị xóa.';
//             } else {
//               errorMessage = 'Không thể tải bài viết: $errorMessage';
//             }
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(
//                     Icons.error_outline,
//                     color: Colors.red,
//                     size: 60,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     errorMessage,
//                     style: TextStyle(fontSize: 18, color: Colors.grey[700]),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         futureArticle = ArticleService().getArticleById(widget.articleId);
//                       });
//                     },
//                     child: const Text('Thử lại'),
//                   ),
//                 ],
//               ),
//             );
//           }
//           return const Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }
// }
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
    futureArticle = ArticleService().getArticleById(widget.articleId);
  }

  // ---------- BUILD UI ----------
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: FutureBuilder<Article>(
        future: futureArticle,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final article = snapshot.data!;

            return CustomScrollView(
              slivers: [
                // Ảnh cover co giãn khi cuộn
                SliverAppBar(
                  pinned: true,
                  stretch: true,
                  expandedHeight: 240,
                  leading: BackButton(color: Colors.white),
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    collapseMode: CollapseMode.parallax,
                    background: Stack(
                      fit: StackFit.expand,
                      children: [

                        // lớp mờ để chữ trắng nổi bật
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black54],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Tiêu đề
                      Text(
                        article.tieuDe,
                        style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      // Meta data
                      Text(
                        'Tác giả: ${article.tacGia}  •  '
                            '${DateFormat('dd/MM/yyyy').format(article.ngayDang)}',
                        style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),

                      // Nội dung + ảnh xen kẽ
                      ..._buildContent(article, textTheme),
                      const SizedBox(height: 40),
                    ]),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return _buildError(snapshot.error.toString());
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  // ---------- CONTENT & IMAGE MIX ----------
  List<Widget> _buildContent(Article article, TextTheme textTheme) {
    final contents = [...article.noiDungBaiViets]..sort((a, b) => a.thuTu.compareTo(b.thuTu));
    final images = article.anhBaiViets;

    final widgets = <Widget>[];
    final step = contents.length / (images.length + 1);

    int c = 0, i = 0;
    for (int idx = 0; idx < contents.length + images.length; idx++) {
      if (i < images.length && idx == ((i + 1) * step).floor()) {
        // ảnh
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    images[i].duongDan,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(height: 200, color: Colors.grey.shade300),
                  ),
                ),
                if (images[i].moTa.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    images[i].moTa,
                    style: textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                  ),
                ],
              ],
            ),
          ),
        );
        i++;
      } else if (c < contents.length) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              ' ${contents[c].noiDung}', // kí tự khoảng trắng cho thụt dòng đầu
              style: textTheme.bodyMedium?.copyWith(height: 1.6, fontSize: 16),
            ),
          ),
        );
        c++;
      }
    }
    return widgets;
  }

  // ---------- ERROR ----------
  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              error.contains('404')
                  ? 'Bài viết không tồn tại hoặc đã bị xoá.'
                  : 'Không thể tải bài viết: $error',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => setState(() => futureArticle =
                  ArticleService().getArticleById(widget.articleId)),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}
