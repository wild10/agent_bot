import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum MessageType { user, bot }

class ChatBubble extends StatelessWidget {
  final String message;
  final String time;
  final MessageType type;
  final bool isRead;
  final bool isRich;
  final Widget? richContent;

  const ChatBubble({
    super.key,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
    this.isRich = false,
    this.richContent,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = type == MessageType.user;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildBotAvatar(),
          if (!isUser) const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (isRich && richContent != null)
                  richContent!
                else
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isUser
                          ? AppTheme.bubbleGrey.withOpacity(0.5) // User bubble slightly transparent or white
                          : AppTheme.bubbleGrey,
                      borderRadius: BorderRadius.only(
                        topLeft: isUser
                            ? const Radius.circular(16)
                            : const Radius.circular(0), // Bot: Sharp at Top Left
                        topRight: isUser
                            ? const Radius.circular(0) // User: Sharp at Top Right
                            : const Radius.circular(16),
                        bottomLeft: const Radius.circular(16),
                        bottomRight: const Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      message,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (isUser) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.done_all,
                        size: 14,
                        color: isRead ? AppTheme.botPurple : Colors.grey,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (isUser) const SizedBox(width: 8),
          if (isUser) _buildUserAvatar(),
        ],
      ),
    );
  }

  Widget _buildBotAvatar() {
    return const CircleAvatar(
      radius: 18,
      backgroundColor: AppTheme.botPurple,
      // CAMBIAR AQUI: Descomenta la línea de abajo para usar una imagen local
      backgroundImage: AssetImage('assets/images/bot_avatar.png'),
      // child: Icon(Icons.smart_toy_outlined, color: Colors.white, size: 20), // Comenta esto si usas imagen
    );
  }

  Widget _buildUserAvatar() {
    return const CircleAvatar(
      radius: 18,
      // CAMBIAR AQUI: Para usar una foto de internet:
      // backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
      
      // CAMBIAR AQUI: Para usar una foto local (asegúrate de agregarla a pubspec.yaml):
      backgroundImage: AssetImage('assets/images/user_avatar.png'),
    );
  }
}
