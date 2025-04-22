import 'package:flutter/material.dart';
import 'package:busmap/service/Khanh/chat_api_service.dart';
import 'package:busmap/models/Khanh/ChatBot/chat_model.dart';
import 'package:busmap/screens/Home/chat_screen.dart'; // Import ChatScreen
import 'package:shared_preferences/shared_preferences.dart';

class ListChatScreen extends StatefulWidget {
  @override
  _ListChatScreenState createState() => _ListChatScreenState();
}

class _ListChatScreenState extends State<ListChatScreen> {
  final ChatApiService _chatApiService = ChatApiService();
  List<ChatModel> _chats = [];
  String? userEmail;
  int? userId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _loadChats();
  }



  // Future<void> _loadChats() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   int? id = prefs.getInt('user_id');
  //   String? email = prefs.getString('user_email');
  //
  //   print('user_id lấy được trong HomeContent: $id');
  //   print('user_email lấy được trong HomeContent: $email');
  //
  //   setState(() {
  //     userId = id;
  //     userEmail = email ?? 'Không có email';
  //     _isLoading = true;
  //   });
  //
  //
  //   try {
  //     final chats = await _chatApiService.getChatsByUserId(userId);
  //     setState(() {
  //       _chats = chats;
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Error loading chats: $e")),
  //     );
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }
  Future<void> _loadChats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? id = prefs.getInt('user_id');
    String? email = prefs.getString('user_email');

    print('user_id lấy được trong chat: $id');
    print('user_email lấy được trong chat: $email');

    setState(() {
      userId = id;
      userEmail = email ?? 'Không có email';
      _isLoading = true;
    });
  print('object chat : $id');
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Không tìm thấy user_id")),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final chats = await _chatApiService.getChatsByUserId(id); // id lúc này đã chắc chắn là int
      setState(() {
        _chats = chats;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading chats: $e")),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Hàm tạo chat mới
  // Future<void> _createNewChat() async {
  //   try {
  //     final newChat = await _chatApiService.createChat(userId, "New Chat");
  //     setState(() {
  //       _chats.add(newChat);
  //     });
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => ChatScreen(chatId: newChat.id),
  //       ),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Error creating chat: $e")),
  //     );
  //   }
  // }
  Future<void> _createNewChat() async {
    print(' creat chat: $userId');
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Không tìm thấy user_id")),
      );
      return;
    }

    try {
      final newChat = await _chatApiService.createChat(userId!, "New Chat"); // dùng userId! vì đã check null
      setState(() {
        _chats.add(newChat);
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(chatId: newChat.id),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error creating chat: $e")),
      );
    }
  }


  // Hàm hiển thị dialog để đổi tên chat
  Future<void> _renameChat(ChatModel chat, int index) async {
    final TextEditingController _titleController = TextEditingController(text: chat.title ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Đổi tên chat"),
        content: TextField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: "Tên mới",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Hủy
            child: Text("Hủy"),
          ),
          TextButton(
            onPressed: () {
              if (_titleController.text.trim().isNotEmpty) {
                Navigator.pop(context, _titleController.text.trim());
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Tên không được để trống")),
                );
              }
            },
            child: Text("Lưu"),
          ),
        ],
      ),
    );

    if (result != null) {
      try {
        final updatedChat = await _chatApiService.updateChatTitle(chat.id, result);
        setState(() {
          _chats[index] = updatedChat; // Cập nhật chat trong danh sách
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đổi tên chat thành công")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error renaming chat: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh Sách Chat"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _createNewChat,
            tooltip: "Tạo chat mới",
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _chats.isEmpty
          ? Center(child: Text("Không có cuộc trò chuyện nào."))
          : ListView.builder(
        itemCount: _chats.length,
        itemBuilder: (context, index) {
          final chat = _chats[index];
          return ListTile(
            title: Text(chat.title ?? "Chat ${chat.id}"),
            subtitle: Text("ID: ${chat.id}"),
            trailing: IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _renameChat(chat, index), // Gọi hàm đổi tên
              tooltip: "Đổi tên chat",
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(chatId: chat.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}