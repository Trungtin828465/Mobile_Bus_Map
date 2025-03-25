import 'package:flutter/material.dart';
import 'package:busmap/services/chat_api_service.dart';
import 'package:busmap/models/ChatBot/chat_model.dart';
import 'package:busmap/screens/Home/chat_screen.dart'; // Import ChatScreen

class ListChatScreen extends StatefulWidget {
  @override
  _ListChatScreenState createState() => _ListChatScreenState();
}

class _ListChatScreenState extends State<ListChatScreen> {
  final ChatApiService _chatApiService = ChatApiService();
  List<ChatModel> _chats = [];
  int userId = 1; // Giả sử userId là 1
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final chats = await _chatApiService.getChatsByUserId(userId);
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
  Future<void> _createNewChat() async {
    try {
      final newChat = await _chatApiService.createChat(userId, "New Chat");
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