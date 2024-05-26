import 'package:assignment/features/chats/widgets/bottom_chat_feild.dart';
import 'package:assignment/features/chats/widgets/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String receiverName;
  final String receiverId;
  const ChatScreen({
    super.key,
    required this.receiverName,
    required this.receiverId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(widget.receiverName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              uid: widget.receiverId,
            ),
          ),
          BottomChatFeild(
            uid: widget.receiverId,
          ),
          const SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }
}
