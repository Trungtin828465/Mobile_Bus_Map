import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:busmap/providers/user_admin_chat_provider.dart';
import 'package:busmap/screens/Home/user_admin_chat_detail_screen.dart'; // Cập nhật import

class UserAdminChatListScreen extends StatefulWidget {
  const UserAdminChatListScreen({super.key});

  @override
  _UserAdminChatListScreenState createState() => _UserAdminChatListScreenState();
}

class _UserAdminChatListScreenState extends State<UserAdminChatListScreen> {
  final int _userId = 1; // Giả sử userId là 1
  final int _adminId = 3; // Giả sử adminId là 2

  @override
  void initState() {
    super.initState();
    Provider.of<UserAdminChatProvider>(context, listen: false).fetchChatsByUserId(_userId);
  }

  Future<void> _createNewChat() async {
    await Provider.of<UserAdminChatProvider>(context, listen: false).createChat(_userId, _adminId);
  }

  Future<void> _deleteChat(String chatId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc chắn muốn xóa cuộc trò chuyện này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await Provider.of<UserAdminChatProvider>(context, listen: false).deleteChat(chatId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xóa cuộc trò chuyện')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách trò chuyện'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Consumer<UserAdminChatProvider>(
        builder: (context, chatProvider, child) {
          if (chatProvider.isLoadingChats) {
            return const Center(child: CircularProgressIndicator());
          } else if (chatProvider.errorChats != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lỗi: ${chatProvider.errorChats}',
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      chatProvider.fetchChatsByUserId(_userId);
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          } else if (chatProvider.chats.isEmpty) {
            return const Center(
              child: Text(
                'Bạn chưa có cuộc trò chuyện nào',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          final chats = chatProvider.chats;

          return RefreshIndicator(
            onRefresh: () async {
              await chatProvider.fetchChatsByUserId(_userId);
            },
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ListTile(
                  title: Text('Cuộc trò chuyện với Admin ${chat.adminId}'),
                  subtitle: Text('Tạo lúc: ${chat.createdAt.toString()}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserAdminChatDetailScreen(chatId: chat.id), // Cập nhật tên class
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteChat(chat.id),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewChat,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}