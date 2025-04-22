
import 'package:flutter/material.dart';
import 'package:busmap/models/Admin/BaiViet.dart';
import 'package:busmap/service/Admin/api_baiviet.dart';

class AddArticleScreen extends StatefulWidget {
  @override
  _AddArticleScreenState createState() => _AddArticleScreenState();
}

class _AddArticleScreenState extends State<AddArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final ApiService apiService = ApiService();

  // Danh sách các đoạn nội dung
  List<TextEditingController> _contentControllers = [TextEditingController()];
  // Danh sách các ảnh (URL và mô tả)
  List<Map<String, TextEditingController>> _imageControllers = [
    {
      'url': TextEditingController(),
      'description': TextEditingController(),
    }
  ];

  // Thêm một đoạn nội dung mới
  void _addContentField() {
    setState(() {
      _contentControllers.add(TextEditingController());
    });
  }

  // Thêm một ảnh mới
  void _addImageField() {
    setState(() {
      _imageControllers.add({
        'url': TextEditingController(),
        'description': TextEditingController(),
      });
    });
  }

  // Xóa một đoạn nội dung
  void _removeContentField(int index) {
    setState(() {
      if (_contentControllers.length > 1) {
        _contentControllers[index].dispose();
        _contentControllers.removeAt(index);
      }
    });
  }

  // Xóa một ảnh
  void _removeImageField(int index) {
    setState(() {
      if (_imageControllers.length > 1) {
        _imageControllers[index]['url']?.dispose();
        _imageControllers[index]['description']?.dispose();
        _imageControllers.removeAt(index);
      }
    });
  }

  void _submitArticle() async {
    if (_formKey.currentState!.validate()) {
      // Tạo danh sách ArticleContent từ các đoạn nội dung
      List<ArticleContent> contents = _contentControllers
          .asMap()
          .entries
          .map((entry) => ArticleContent(
        id: 0, // API doesn't require this, set to 0
        articleId: 0, // API doesn't require this, set to 0
        order: entry.key + 1,
        content: entry.value.text,
      ))
          .toList();

      // Tạo danh sách ảnh từ các controller
      List<ArticleImage> images = _imageControllers
          .where((controller) =>
      controller['url']!.text.isNotEmpty &&
          controller['description']!.text.isNotEmpty)
          .map((controller) => ArticleImage(
        id: 0, // API doesn't require this, set to 0
        articleId: 0, // API doesn't require this, set to 0
        url: controller['url']!.text,
        description: controller['description']!.text,
      ))
          .toList();

      // Tạo bài viết mới
      Article newArticle = Article(
        id: 0, // API doesn't require this, set to 0
        title: _titleController.text,
        datePosted: DateTime.now(),
        author: _authorController.text,
        images: images,
        contents: contents,
      );

      bool success = await apiService.createArticle(newArticle);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thêm bài viết thành công!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi khi thêm bài viết!')),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    for (var controller in _contentControllers) {
      controller.dispose();
    }
    for (var controller in _imageControllers) {
      controller['url']?.dispose();
      controller['description']?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm bài viết mới')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Tiêu đề',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Nhập tiêu đề' : null,
                ),
                const SizedBox(height: 16),
                // Tác giả
                TextFormField(
                  controller: _authorController,
                  decoration: const InputDecoration(
                    labelText: 'Tác giả',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? 'Nhập tác giả' : null,
                ),
                const SizedBox(height: 16),
                // Nội dung
                const Text(
                  'Nội dung:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._contentControllers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final controller = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            decoration: InputDecoration(
                              labelText: 'Đoạn ${index + 1}',
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) =>
                            value!.isEmpty ? 'Nhập nội dung' : null,
                            maxLines: 5,
                            minLines: 3,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () => _removeContentField(index),
                        ),
                      ],
                    ),
                  );
                }),
                TextButton.icon(
                  onPressed: _addContentField,
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm đoạn nội dung'),
                ),
                const SizedBox(height: 16),
                // Ảnh
                const Text(
                  'Ảnh:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._imageControllers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final controller = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: controller['url'],
                                decoration: const InputDecoration(
                                  labelText: 'Tên file ảnh (ví dụ: image.jpg)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: controller['description'],
                                decoration: const InputDecoration(
                                  labelText: 'Mô tả ảnh',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () => _removeImageField(index),
                        ),
                      ],
                    ),
                  );
                }),
                TextButton.icon(
                  onPressed: _addImageField,
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm ảnh'),
                ),
                const SizedBox(height: 20),
                // Nút gửi
                ElevatedButton(
                  onPressed: _submitArticle,
                  child: const Text('Thêm bài viết'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
