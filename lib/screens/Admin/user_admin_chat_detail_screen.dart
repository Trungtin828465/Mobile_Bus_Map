import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:busmap/providers/user_admin_chat_provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAdminChatDetailScreen extends StatefulWidget {
  final String chatId;

  const UserAdminChatDetailScreen({super.key, required this.chatId});

  @override
  _UserAdminChatDetailScreenState createState() => _UserAdminChatDetailScreenState();
}

class _UserAdminChatDetailScreenState extends State<UserAdminChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  String _senderRole = "User"; // Mặc định là User
  bool _isSending = false;
  Timer? _refreshTimer; // Timer để tự động làm mới tin nhắn

  @override
  void initState() {
    super.initState();
    _loadSenderRole(); // Xác định vai trò khi khởi tạo
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.fetchMessagesByChatId(widget.chatId); // Lấy danh sách tin nhắn

    // Tự động làm mới mỗi 5 giây
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      chatProvider.fetchMessagesByChatId(widget.chatId);
    });
  }

  // Hàm xác định vai trò (Admin hay User)
  Future<void> _loadSenderRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int adminId = prefs.getInt('admin_id') ?? 0;
    setState(() {
      _senderRole = adminId != 0 ? "Admin" : "User";
    });
    print("Sender Role: $_senderRole"); // Debug log

    // Đánh dấu tin nhắn đã đọc sau khi xác định vai trò
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.markMessageAsRead(widget.chatId, _senderRole);
  }

  // Hàm gửi tin nhắn
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
      // Làm mới danh sách tin nhắn ngay sau khi gửi
      Provider.of<ChatProvider>(context, listen: false).fetchMessagesByChatId(widget.chatId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi gửi tin nhắn: $e')),
      );
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel(); // Hủy timer để tránh rò rỉ bộ nhớ
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trò chuyện ($_senderRole)',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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

                return RefreshIndicator(
                  onRefresh: () async {
                    await chatProvider.fetchMessagesByChatId(widget.chatId);
                  },
                  child: ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[messages.length - 1 - index];
                      final isSentByUser = message.senderRole == _senderRole;

                      return Align(
                        alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSentByUser ? Colors.green[100] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: isSentByUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              // Hiển thị vai trò người gửi
                              Text(
                                message.senderRole,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSentByUser ? Colors.green[800] : Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              // Nội dung tin nhắn
                              Text(
                                message.content,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 5),
                              // Thời gian và trạng thái đã đọc
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    DateFormat('dd/MM/yyyy HH:mm').format(message.sentAt),
                                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                                  ),
                                  if (isSentByUser && message.isRead)
                                    const Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Icon(
                                        Icons.check_circle,
                                        size: 16,
                                        color: Colors.green,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          // Thanh nhập tin nhắn
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    onSubmitted: (value) => _sendMessage(), // Gửi tin nhắn khi nhấn Enter
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(25),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: _isSending ? null : _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: _isSending
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}