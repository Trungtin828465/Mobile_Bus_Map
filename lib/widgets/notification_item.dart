// import 'package:flutter/material.dart';
//
// class NotificationItem extends StatelessWidget {
//   final bool isRead;
//   final String date;
//   final String title;
//
//   NotificationItem({required this.isRead, required this.date, required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8.0),
//       color: isRead ? Colors.white : Colors.grey[200],
//       child: ListTile(
//         leading: Icon(Icons.notifications, color: isRead ? Colors.grey : Colors.green),
//         title: Text(
//           title,
//           style: TextStyle(fontWeight: isRead ? FontWeight.normal : FontWeight.bold),
//         ),
//         subtitle: Text(date, style: TextStyle(color: Colors.grey)),
//         trailing: isRead ? null : Icon(Icons.circle, size: 12, color: Colors.red),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final bool isRead;
  final String date;   // dd/MM/yyyy hoặc HH:mm, tuỳ bạn
  final String title;

  const NotificationItem({
    super.key,
    required this.isRead,
    required this.date,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Màu nền theo trạng thái
    final bgColor = isRead
        ? colorScheme.surfaceVariant   // Đã đọc
        : colorScheme.primaryContainer; // Chưa đọc

    // Icon chủ đề
    final leadingIcon = isRead ? Icons.notifications_none : Icons.notifications_active;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          // TODO: handle tap
        },
        child: Material(
          elevation: 2,
          shadowColor: Colors.black26,
          borderRadius: BorderRadius.circular(20),
          color: bgColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  leadingIcon,
                  color: isRead ? colorScheme.outline : colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                // Nội dung
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tiêu đề + dot đỏ chưa đọc + ngày
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight:
                                isRead ? FontWeight.w400 : FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!isRead)
                            const Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Icon(Icons.circle, size: 10, color: Colors.red),
                            ),
                          const SizedBox(width: 8),
                          Text(
                            date,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

