import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:busmap/providers/user_admin_chat_provider.dart';
import 'package:busmap/screens/Admin/user_admin_chat_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:busmap/widgets/Admin/dashboard_appbar.dart';
import 'package:busmap/widgets//Admin/dashboard_drawer.dart';

class UserAdminChatListScreen extends StatefulWidget {
  const UserAdminChatListScreen({super.key});

  @override
  _UserAdminChatListScreenState createState() => _UserAdminChatListScreenState();
}

class _UserAdminChatListScreenState extends State<UserAdminChatListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _adminId = 0;

  @override
  void initState() {
    super.initState();
    _loadAdminId();
  }

  Future<void> _loadAdminId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _adminId = prefs.getInt('admin_id') ?? 0;
    });
    print("Admin ID: $_adminId");

    if (_adminId != 0) {
      Provider.of<ChatProvider>(context, listen: false).fetchChatsByAdminId(_adminId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy adminId. Vui lòng đăng nhập lại.')),
      );
    }
  }

  // Future<void> _createNewChat() async {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Chức năng tạo chat mới chỉ dành cho User.')),
  //   );
  // }

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
      key: _scaffoldKey,
      appBar: DashboardAppBar(scaffoldKey: _scaffoldKey),
      drawer: const DashboardDrawer(),
      body: Consumer<ChatProvider>(
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
                      chatProvider.fetchChatsByAdminId(_adminId);
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
              await chatProvider.fetchChatsByAdminId(_adminId);
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
                        builder: (context) => UserAdminChatDetailScreen(chatId: chat.id),
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
      // floatingActionButton: FloatingActionButton(
      //   // onPressed: _createNewChat,
      //   backgroundColor: Colors.green,
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}