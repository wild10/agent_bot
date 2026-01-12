import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/suggestion_chip.dart';
import '../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class Message {
  final String text;
  final MessageType type;
  final DateTime timestamp;
  final bool isRich;
  final Widget? richContent;

  Message({
    required this.text,
    required this.type,
    required this.timestamp,
    this.isRich = false,
    this.richContent,
  });
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  
  // Initial dummy data
  // final List<Message> _messages = [
  //   Message(
  //     text: 'Minimum text check, Hide check icon',
  //     type: MessageType.user,
  //     timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
  //   ),
  //   Message(
  //     text: '',
  //     type: MessageType.bot,
  //     timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
  //     isRich: true,
  //   ),
  //   Message(
  //     text: 'More no. of lines text and showing complete list of features like time stamp + check icon READ',
  //     type: MessageType.user,
  //     timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
  //   ),
  // ];
  final List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    // Initialize rich content for the existing bot message
    // In a real app, this would be part of the data model or factory
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final userMessage = Message(
      text: _controller.text,
      type: MessageType.user,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _controller.clear();
    });

    _scrollToBottom();
    _scrollToBottom();
    _getBotResponse(userMessage.text);
  }

  void _getBotResponse(String userMessage) async {
    try {
      final botText = await _chatService.sendMessage(userMessage);
      
      if (!mounted) return;

      final botMessage = Message(
        text: botText,
        type: MessageType.bot,
        timestamp: DateTime.now(),
      );

      setState(() {
        _messages.add(botMessage);
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return ChatBubble(
                  message: msg.text,
                  time: "${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}",
                  type: msg.type,
                  isRead: true, // Always read for demo
                  isRich: msg.isRich,
                  richContent: msg.isRich ? _buildRichCard() : null,
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryBlue,
      elevation: 0,
      toolbarHeight: 80,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: AppTheme.primaryBlue,
              // CAMBIAR AQUI: Descomenta la línea de abajo para usar una imagen local
              backgroundImage: AssetImage('assets/images/logo_hotel.jpg'),
              // child: Icon(Icons.smart_toy, color: Colors.white, size: 24), // Comenta esto si usas imagen
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Agente Atención al cliente',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.onlineGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Online',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildRichCard() {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppTheme.deepPurple, // Using deep purple for the card
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0), // Pointing to bot avatar
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
              children: [
                TextSpan(text: 'Rapidly build stunning Web Apps with '),
                TextSpan(
                  text: 'Frest 🚀',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                    text:
                        '\nDeveloper friendly, Highly customizable & Carefully crafted HTML Admin Dashboard Template.'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.botPurple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.content_copy, color: Colors.white, size: 16),
                    SizedBox(width: 12),
                    Icon(Icons.thumb_up_outlined, color: Colors.white, size: 16),
                    SizedBox(width: 12),
                    Icon(Icons.thumb_down_outlined, color: Colors.white, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SuggestionChip(
                  label: 'Que es este bot?',
                  icon: Icons.emoji_objects_outlined,
                  onTap: () {
                     _controller.text = "What is WappGPT?";
                     _sendMessage();
                  },
                ),
                const SizedBox(width: 8),
                SuggestionChip(
                  label: 'Precios',
                  icon: Icons.monetization_on_outlined,
                  onTap: () {
                    _controller.text = "Pricing";
                    _sendMessage();
                  },
                ),
                const SizedBox(width: 8),
                SuggestionChip(
                  label: 'Preguntas',
                  icon: Icons.question_answer_outlined,
                  onTap: () {
                    _controller.text = "FAQs";
                    _sendMessage();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: const InputDecoration(
                      hintText: 'Type your message here...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: AppTheme.primaryBlue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
