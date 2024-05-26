import 'package:assignment/features/chats/model/message_model.dart';
import 'package:assignment/features/chats/repository/chat_repository.dart';
import 'package:assignment/features/chats/widgets/my_message.dart';
import 'package:assignment/features/chats/widgets/sender_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatList extends ConsumerStatefulWidget {
  final String uid;
  const ChatList({
    super.key,
    required this.uid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();
  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: ref
          .watch(chatRepositoryProvider)
          .getMessage(recieverUserId: widget.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          messageController.jumpTo(messageController.position.maxScrollExtent);
        });
        return ListView.builder(
          controller: messageController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            if (snapshot.data![index].senderId ==
                FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: snapshot.data![index].text,
                date: DateFormat.Hm().format(snapshot.data![index].timeSent),
              );
            }
            return SenderMessageCard(
              message: snapshot.data![index].text,
              date: DateFormat.Hm().format(snapshot.data![index].timeSent),
            );
          },
        );
      },
    );
  }
}
