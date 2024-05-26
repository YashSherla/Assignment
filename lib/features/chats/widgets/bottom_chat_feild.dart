import 'package:assignment/features/chats/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomChatFeild extends ConsumerStatefulWidget {
  final String uid;
  const BottomChatFeild({
    super.key,
    required this.uid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BottomChatFeildState();
}

class _BottomChatFeildState extends ConsumerState<BottomChatFeild> {
  TextEditingController messageController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  void sendMessage() {
    ref.read(chatControllerProvider).sendMessage(
          text: messageController.text.trim(),
          receiverId: widget.uid,
        );
    setState(() {
      messageController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                filled: true,
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Icon(
                    Icons.payment,
                    color: Colors.grey,
                  ),
                ),
                hintText: 'Type a message!',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                contentPadding: const EdgeInsets.all(10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xff128C7E),
              radius: 25,
              child: IconButton(
                onPressed: () => sendMessage(),
                icon: const Icon(Icons.send),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
