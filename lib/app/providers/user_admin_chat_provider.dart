import 'package:flutter/foundation.dart';
import 'package:project1/app/models/user_admin_chat.dart';
import 'package:project1/app/models/user_admin_message.dart';
import 'package:project1/app/services/user_admin_chat_service.dart';

class ChatProvider with ChangeNotifier {
  final UserAdminChatService _chatService = UserAdminChatService();
  List<UserAdminChat> _chats = [];
  List<UserAdminMessage> _messages = [];
  bool _isLoadingChats = false;
  bool _isLoadingMessages = false;
  String? _errorChats;
  String? _errorMessages;

  List<UserAdminChat> get chats => _chats;
  List<UserAdminMessage> get messages => _messages;
  bool get isLoadingChats => _isLoadingChats;
  bool get isLoadingMessages => _isLoadingMessages;
  String? get errorChats => _errorChats;
  String? get errorMessages => _errorMessages;

  Future<void> fetchChatsByUserId(int userId) async {
    try {
      _isLoadingChats = true;
      _errorChats = null;
      notifyListeners();

      _chats = await _chatService.getChatsByUserId(userId);
    } catch (e) {
      _errorChats = e.toString();
    } finally {
      _isLoadingChats = false;
      notifyListeners();
    }
  }

  Future<void> fetchChatsByAdminId(int adminId) async {
    try {
      _isLoadingChats = true;
      _errorChats = null;
      notifyListeners();

      _chats = await _chatService.getChatsByAdminId(adminId);
    } catch (e) {
      _errorChats = e.toString();
    } finally {
      _isLoadingChats = false;
      notifyListeners();
    }
  }

  Future<void> createChat(int userId, int adminId) async {
    try {
      _isLoadingChats = true;
      _errorChats = null;
      notifyListeners();

      final newChat = await _chatService.createChat(userId, adminId);
      _chats.add(newChat);
    } catch (e) {
      _errorChats = e.toString();
    } finally {
      _isLoadingChats = false;
      notifyListeners();
    }
  }

  Future<void> fetchMessagesByChatId(String chatId) async {
    try {
      _isLoadingMessages = true;
      _errorMessages = null;
      notifyListeners();

      _messages = await _chatService.getMessagesByChatId(chatId);
    } catch (e) {
      _errorMessages = e.toString();
    } finally {
      _isLoadingMessages = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String chatId, String senderRole, String content) async {
    try {
      _isLoadingMessages = true;
      _errorMessages = null;
      notifyListeners();

      final newMessage = await _chatService.sendMessage(chatId, senderRole, content);
      _messages.add(newMessage);
    } catch (e) {
      _errorMessages = e.toString();
    } finally {
      _isLoadingMessages = false;
      notifyListeners();
    }
  }

  Future<void> markMessageAsRead(String chatId, String readerRole) async {
    try {
      bool updated = await _chatService.markMessageAsRead(chatId, readerRole);
      if (updated) {
        _messages = _messages.map((msg) {
          if (msg.senderRole != readerRole) {
            return msg.copyWith(isRead: true);
          }
          return msg;
        }).toList();
        notifyListeners();
      }
    } catch (e) {
      _errorMessages = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteChat(String chatId) async {
    try {
      _isLoadingChats = true;
      _errorChats = null;
      notifyListeners();

      final success = await _chatService.deleteChat(chatId);
      if (success) {
        _chats.removeWhere((chat) => chat.id == chatId);
      }
    } catch (e) {
      _errorChats = e.toString();
    } finally {
      _isLoadingChats = false;
      notifyListeners();
    }
  }
}

extension UserAdminMessageExtension on UserAdminMessage {
  UserAdminMessage copyWith({
    String? id,
    String? chatId,
    String? senderRole,
    String? content,
    DateTime? sentAt,
    bool? isRead,
  }) {
    return UserAdminMessage(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderRole: senderRole ?? this.senderRole,
      content: content ?? this.content,
      sentAt: sentAt ?? this.sentAt,
      isRead: isRead ?? this.isRead,
    );
  }
}