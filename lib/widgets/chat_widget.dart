import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../controllers/chathistory_controller.dart';
import '../models/chathistory_model.dart';

const String OPENAI_API_KEY =
    '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';

class ChatWidget extends StatefulWidget {
  final String userId;
  const ChatWidget({Key? key, required this.userId}) : super(key: key);

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatHistoryController>().getUserChatHistory(widget.userId); // Fetch user-specific chat history
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleChat() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final chatController = context.read<ChatHistoryController>();
    final newChat = ChatHistoryModel(
      message: message,
      userId: widget.userId, // Ensure the userId is passed
      response: "Processing...",
    );

    await chatController.addChatHistory(newChat);
    _messageController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    ));

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $OPENAI_API_KEY',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content": "You are FitBingo Assistant, a fitness and health expert. Your role is to provide fitness, workout, diet, and wellness advice. Make sure to give friendly and helpful responses."
            },
            {
              "role": "user",
              "content": message
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        newChat.response = data['choices'][0]['message']['content'];
      } else {
        newChat.response = "Failed to fetch response.";
      }
    } catch (e) {
      newChat.response = "Error: $e";
    }

    if (newChat.id != null) {
      await chatController.updateChatHistory(newChat.id!, newChat);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatHistoryController>(
      builder: (context, chatController, child) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              if (isExpanded)
                GestureDetector(
                  onTap: _toggleChat,
                  child: Container(
                    color: Colors.black54,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              Positioned(
                right: 16,
                bottom: 16,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizeTransition(
                      sizeFactor: _animation,
                      axisAlignment: 1.0,
                      child: Container(
                        width: 300,
                        height: 400,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.smart_toy, size: 20),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'ChatBot',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.white),
                                    onPressed: _toggleChat,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: chatController.isLoading
                                  ? const Center(child: CircularProgressIndicator())
                                  : ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.all(16),
                                itemCount: chatController.chatHistory.length,
                                itemBuilder: (context, index) {
                                  final chat = chatController.chatHistory[index];
                                  return Column(
                                    children: [
                                      if (chat.message != null)
                                        ChatBubble(
                                          message: chat.message!,
                                          isUser: true,
                                        ),
                                      if (chat.response != null)
                                        ChatBubble(
                                          message: chat.response!,
                                          isUser: false,
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(20),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _messageController,
                                      decoration: InputDecoration(
                                        hintText: 'Type a message...',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(25),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey[100],
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                      ),
                                      onSubmitted: _sendMessage,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  CircleAvatar(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    child: IconButton(
                                      icon: const Icon(Icons.send, color: Colors.white),
                                      onPressed: () => _sendMessage(_messageController.text),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: _toggleChat,
                      child: Icon(isExpanded ? Icons.close : Icons.chat_bubble),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey,
              child: Icon(Icons.smart_toy, size: 16, color: Colors.white),
            ),
          const SizedBox(width: 8),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.4, // Prevents overflow
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isUser ? Theme.of(context).primaryColor : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black87,
              ),
              overflow: TextOverflow.clip,
              softWrap: true,
            ),
          ),
          const SizedBox(width: 8),
          if (isUser)
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
        ],
      ),
    );
  }
}