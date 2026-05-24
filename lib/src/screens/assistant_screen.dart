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
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [
    const ChatMessage(
      text:
          'Hi, I can help with expiry checks, recipe ideas, grocery planning and your kitchen inventory',
      isUser: false,
    ),
  ];
  bool _isThinking = false;
  bool _isResponding = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            children: [
              const SectionHeader(
                title: 'AI Assistant',
                subtitle:
                    'Ask about food waste, recipes, storage and grocery planning',
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
              if (_isThinking) const _ThinkingBubble(),
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

  Future<void> _sendMessage(String text) async {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty || _isResponding) {
      return;
    }

    final response = _assistantService.respond(
      question: trimmedText,
      inventory: widget.controller.ingredients,
      recipes: widget.controller.recipes,
      knowledgeBase: widget.controller.assistantKnowledge,
      preferences: widget.controller.preferences,
    );

    setState(() {
      _messages.add(ChatMessage(text: trimmedText, isUser: true));
      _messageController.clear();
      _isThinking = true;
      _isResponding = true;
    });
    _scrollToBottom();

    await Future<void>.delayed(_thinkingDuration(response));
    if (!mounted) {
      return;
    }

    setState(() {
      _isThinking = false;
      _messages.add(const ChatMessage(text: '', isUser: false));
    });

    for (var index = 0; index <= response.length; index += 1) {
      if (!mounted) {
        return;
      }

      setState(() {
        _messages[_messages.length - 1] = ChatMessage(
          text: response.substring(0, index),
          isUser: false,
        );
      });

      if (index % 12 == 0) {
        _scrollToBottom();
      }

      await Future<void>.delayed(const Duration(milliseconds: 18));
    }

    if (!mounted) {
      return;
    }

    setState(() => _isResponding = false);
    _scrollToBottom();
  }

  Duration _thinkingDuration(String response) {
    if (response.length > 140) {
      return const Duration(milliseconds: 900);
    }
    if (response.length > 80) {
      return const Duration(milliseconds: 650);
    }
    return const Duration(milliseconds: 400);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
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
      'How can I reduce food waste?',
      'Can I freeze this?',
      'Give me healthy meal ideas',
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

class _ThinkingBubble extends StatefulWidget {
  const _ThinkingBubble();

  @override
  State<_ThinkingBubble> createState() => _ThinkingBubbleState();
}

class _ThinkingBubbleState extends State<_ThinkingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFDDEFE1)),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                final phase = ((_controller.value + index * 0.22) % 1.0);
                final opacity = phase < 0.5 ? 0.35 + phase : 1.35 - phase;

                return Container(
                  width: 7,
                  height: 7,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: AppColors.forestGreen.withValues(alpha: opacity),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            );
          },
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
          color: isUser
              ? AppColors.darkGreen
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: isUser ? null : Border.all(color: const Color(0xFFDDEFE1)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color:
                isUser ? Colors.white : Theme.of(context).colorScheme.onSurface,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}
