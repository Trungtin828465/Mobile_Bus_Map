import 'package:flutter/material.dart';
import 'package:busmap/services/chat_api_service.dart';
import 'package:busmap/models/ChatBot/detail_chat_model.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  ChatScreen({required this.chatId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatApiService _chatApiService = ChatApiService();
  final TextEditingController _messageController = TextEditingController();
  List<DetailChatModel> _messages = [];
  int userId = 1;

  // Biến quản lý phân trang
  int _page = 1;
  final int _pageSize = 20;
  bool _isLoading = false;
  bool _hasMore = true;
  ScrollController _scrollController = ScrollController();

  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels <=
          _scrollController.position.minScrollExtent + 200 &&
          !_isLoading &&
          _hasMore) {
        _loadMoreMessages();
      }
    });
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
      _page = 1;
      _hasMore = true;
    });

    try {
      final messages = await _chatApiService.getDetailChatById(
        widget.chatId,
        page: _page,
        pageSize: _pageSize,
      );
      setState(() {
        _messages = messages;
        _hasMore = messages.length == _pageSize;
        _isLoading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.minScrollExtent);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading messages: $e")),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreMessages() async {
    setState(() {
      _isLoading = true;
      _page++;
    });

    try {
      final moreMessages = await _chatApiService.getDetailChatById(
        widget.chatId,
        page: _page,
        pageSize: _pageSize,
      );
      setState(() {
        _messages.insertAll(0, moreMessages);
        _hasMore = moreMessages.length == _pageSize;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading more messages: $e")),
      );
      setState(() {
        _isLoading = false;
        _page--;
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_isSending) return; // Ngăn gửi nếu đang xử lý request

    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    setState(() {
      _isSending = true; // Đánh dấu đang gửi
    });

    try {
      await _chatApiService.postRequestChat(widget.chatId, "User", content);
      setState(() {
        _messageController.clear(); // Làm trống TextField
      });
      await _loadMessages();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending message: $e")),
      );
      await _loadMessages();
    } finally {
      setState(() {
        _isSending = false; // Kết thúc trạng thái gửi
      });
    }
  }

  Future<void> _deleteChat() async {
    try {
      await _chatApiService.deleteChat(widget.chatId);
      setState(() {
        _messages.clear();
        _page = 1;
        _hasMore = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Chat deleted successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting chat: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chatbot"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteChat,
            tooltip: "Xóa chat",
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                final messageIndex = _isLoading ? index : index;
                final message = _messages[messageIndex];
                final isUser = message.role.toLowerCase() == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.green[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      message.content,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Nhập tin nhắn...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (value) {
                      if (!_isSending) { // Chỉ gửi nếu không đang xử lý
                        _sendMessage();
                      }
                    },
                    enabled: !_isSending, // Vô hiệu hóa TextField khi đang gửi
                  ),
                ),
                SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: _isSending ? Colors.grey : Colors.green, // Đổi màu khi đang gửi
                  ),
                  onPressed: _isSending ? null : _sendMessage, // Vô hiệu hóa nút khi đang gửi
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}