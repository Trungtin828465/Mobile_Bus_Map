import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:busmap/providers/user_admin_chat_provider.dart';
import 'package:busmap/screens/Home/user_chat_detail_admin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:busmap/widgets/Admin/dashboard_appbar.dart';
import 'package:busmap/widgets//Admin/dashboard_drawer.dart';

class UserChatUserListScreen extends StatefulWidget {
  const UserChatUserListScreen({super.key});

  @override
  _UserChatListScreenState createState() => _UserChatListScreenState();
}

class _UserChatListScreenState extends State<UserChatUserListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _userId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('user_id') ?? 0;
    });
    print("User ID: $_userId");

    if (_userId != 0) {
      Provider.of<ChatProvider>(context, listen: false).fetchChatsByUserId(_userId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy userId. Vui lòng đăng nhập lại.')),
      );
    }
  }

  Future<void> _createNewChat() async {
    if (_userId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy userId. Vui lòng đăng nhập lại.')),
      );
      return;
    }

    try {
      int adminId = 2; // ✅ Tạm thời dùng adminId cố định

      await Provider.of<ChatProvider>(context, listen: false).createChat(_userId, adminId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã tạo cuộc trò chuyện mới')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tạo cuộc trò chuyện: $e')),
      );
    }
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
      await Provider.of<ChatProvider>(context, listen: false).deleteChat(chatId);
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
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          print("isLoadingChats: ${chatProvider.isLoadingChats}");
          print("errorChats: ${chatProvider.errorChats}");
          print("chats: ${chatProvider.chats.length}");
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
                  title: Text('Cuộc trò chuyện với User ${chat.userId}'),
                  subtitle: Text('Tạo lúc: ${chat.createdAt.toString()}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserChatDetailScreen(chatId: chat.id),
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
