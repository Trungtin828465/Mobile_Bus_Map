import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:busmap/providers/user_admin_chat_provider.dart';
import 'package:intl/intl.dart';

class UserAdminChatDetailScreen extends StatefulWidget {
  final String chatId;

  const UserAdminChatDetailScreen({super.key, required this.chatId});

  @override
  _UserAdminChatDetailScreenState createState() => _UserAdminChatDetailScreenState();
}

class _UserAdminChatDetailScreenState extends State<UserAdminChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final int _userId = 1; // Giả sử userId là 1
  final String _senderRole = "User"; // Giả sử người dùng là "User"
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.fetchMessagesByChatId(widget.chatId);
    chatProvider.markMessageAsRead(widget.chatId, _senderRole);
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _isSending = true;
    });
    try {
      await Provider.of<ChatProvider>(context, listen: false).sendMessage(
        widget.chatId,
        _senderRole,
        _messageController.text.trim(),
      );
      _messageController.clear();
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trò chuyện'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                if (chatProvider.isLoadingMessages) {
                  return const Center(child: CircularProgressIndicator());
                } else if (chatProvider.errorMessages != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lỗi: ${chatProvider.errorMessages}',
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            chatProvider.fetchMessagesByChatId(widget.chatId);
                          },
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  );
                } else if (chatProvider.messages.isEmpty) {
                  return const Center(
                    child: Text(
                      'Chưa có tin nhắn nào',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }

                final messages = chatProvider.messages;

                return ListView.builder(
                  reverse: true, // Hiển thị tin nhắn mới nhất ở dưới cùng
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[messages.length - 1 - index];
                    final isSentByUser = message.senderRole == _senderRole;

                    return Align(
                      alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSentByUser ? Colors.green[100] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: isSentByUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.content,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisSize: MainAxisSize.min, // Đảm bảo Row chỉ chiếm không gian cần thiết
                              children: [
                                Text(
                                  DateFormat('HH:mm').format(message.sentAt),
                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                                if (isSentByUser && message.isRead) // Hiển thị dấu tích bên phải thời gian
                                  const Padding(
                                    padding: EdgeInsets.only(left: 5), // Khoảng cách giữa thời gian và dấu tích
                                    child: Icon(
                                      Icons.check, // Dấu tích
                                      size: 16,
                                      color: Colors.green, // Màu xanh
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
                    decoration: const InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _isSending ? null : _sendMessage,
                  icon: _isSending
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.send, color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}