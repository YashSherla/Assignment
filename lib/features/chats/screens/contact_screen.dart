import 'package:assignment/features/auth/model/user_model.dart';
import 'package:assignment/features/chats/model/chat_model.dart';
import 'package:assignment/features/chats/repository/chat_repository.dart';
import 'package:assignment/features/chats/widgets/all_contact_list.dart';
import 'package:assignment/features/chats/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MyContactsScreen extends ConsumerStatefulWidget {
  final UserModel? userModel;
  const MyContactsScreen({super.key, required this.userModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<MyContactsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllContactList(),
                ));
          },
          child: const Icon(Icons.message),
        ),
        appBar: AppBar(
          title: const Text('Chats'),
        ),
        body: StreamBuilder<List<ChatContact?>>(
          stream: ref.watch(chatRepositoryProvider).getChatContact(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return snapshot.data!.isEmpty || snapshot.data == null
                ? const Center(child: Text('No contacts'))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      ChatContact chatContact = snapshot.data![index]!;
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    receiverId: chatContact.contactId,
                                    receiverName: chatContact.name,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ListTile(
                                title: Text(
                                  chatContact.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    chatContact.lastMessage,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    chatContact.profilePic,
                                  ),
                                  radius: 30,
                                ),
                                trailing: Text(
                                  DateFormat.Hm().format(chatContact.timeSent),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(color: Colors.black, indent: 85),
                        ],
                      );
                    },
                  );
          },
        ));
  }
}
