import 'package:flutter/material.dart';

import '../controllers/kitchen_controller.dart';
import '../models/chat_message.dart';
import '../services/assistant_response_service.dart';
import '../theme/app_colors.dart';
import '../widgets/section_header.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key, required this.controller});

  final KitchenController controller;

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  static const _assistantService = AssistantResponseService();

  final _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    const ChatMessage(
      text:
          'Hi, I can help with expiry checks, recipe ideas, grocery planning, and your kitchen inventory.',
      isUser: false,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            children: [
              const SectionHeader(
                title: 'AI Assistant',
                subtitle:
                    'Ask about recipes, expiry dates, or grocery planning.',
              ),
              const SizedBox(height: 16),
              _QuickPromptRow(onPromptSelected: _sendMessage),
              const SizedBox(height: 16),
              ..._messages.map(
                (message) => _ChatBubble(
                  text: message.text,
                  isUser: message.isUser,
                ),
              ),
            ],
          ),
        ),
        _ChatInput(
          controller: _messageController,
          onSend: () => _sendMessage(_messageController.text),
        ),
      ],
    );
  }

  void _sendMessage(String text) {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) {
      return;
    }

    final response = _assistantService.respond(
      question: trimmedText,
      inventory: widget.controller.ingredients,
    );

    setState(() {
      _messages.add(ChatMessage(text: trimmedText, isUser: true));
      _messages.add(ChatMessage(text: response, isUser: false));
      _messageController.clear();
    });
  }
}

class _QuickPromptRow extends StatelessWidget {
  const _QuickPromptRow({required this.onPromptSelected});

  final ValueChanged<String> onPromptSelected;

  @override
  Widget build(BuildContext context) {
    const prompts = [
      'What expires soon?',
      'What can I cook?',
      'What should I buy?',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: prompts
            .map(
              (prompt) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  backgroundColor: AppColors.darkGreen,
                  side: BorderSide.none,
                  label: Text(
                    prompt,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  avatar: const Icon(
                    Icons.auto_awesome,
                    size: 16,
                    color: Colors.white,
                  ),
                  onPressed: () => onPromptSelected(prompt),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  const _ChatInput({
    required this.controller,
    required this.onSend,
  });

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: TextField(
          controller: controller,
          textInputAction: TextInputAction.send,
          onSubmitted: (_) => onSend(),
          decoration: InputDecoration(
            hintText: 'Ask about your kitchen...',
            suffixIcon: IconButton(
              tooltip: 'Send',
              onPressed: onSend,
              icon: const Icon(Icons.send),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.text,
    required this.isUser,
  });

  final String text;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUser ? AppColors.darkGreen : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: isUser
              ? null
              : Border.all(color: const Color(0xFFDDEFE1)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : AppColors.ink,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}
