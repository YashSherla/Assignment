import 'package:assignment/features/chats/controller/chat_controller.dart';
import 'package:assignment/features/chats/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllContactList extends ConsumerStatefulWidget {
  const AllContactList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllContactListState();
}

class _AllContactListState extends ConsumerState<AllContactList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Contacts"),
      ),
      body: ref.watch(allchatsProvider).when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final user = data[index];
              if (user.uid == FirebaseAuth.instance.currentUser!.uid) {
                return const SizedBox.shrink();
              }
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            receiverId: user.uid,
                            receiverName: user.name,
                          ),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePic),
                      radius: 40,
                    ),
                    title: Text(
                      user.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(user.email),
                  ),
                  const Divider(),
                ],
              );
            },
          );
        },
        error: (error, stackTrace) {
          return Text(error.toString());
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
