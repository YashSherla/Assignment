import 'package:assignment/features/auth/controller/auth_controller.dart';
import 'package:assignment/features/auth/model/user_model.dart';
import 'package:assignment/features/chats/model/chat_model.dart';
import 'package:assignment/features/chats/model/message_model.dart';
import 'package:assignment/features/chats/repository/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

final allchatsProvider = FutureProvider<List<UserModel>>((ref) {
  final chatController = ref.watch(chatControllerProvider);
  return chatController.chatRepository.allContactList();
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  void sendMessage({
    required String receiverId,
    required String text,
  }) {
    ref.watch(getuserDataControllerProvider).whenData((value) {
      chatRepository.sendMessage(
        receiverId: receiverId,
        text: text,
        senderData: value!,
      );
    });
  }

  Stream<List<Message>> getMessage({required String recieverUserId}) {
    return chatRepository.getMessage(recieverUserId: recieverUserId);
  }

  Stream<List<ChatContact?>> getChatContact() {
    return chatRepository.getChatContact();
  }
}
