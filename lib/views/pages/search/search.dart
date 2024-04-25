import 'package:chat_app/state/chat/providers/create_chat_provider.dart';
import 'package:chat_app/state/user/providers/search_user_provider.dart';
import 'package:chat_app/views/components/user_tile.dart';
import 'package:chat_app/views/loading/loading.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController controller = TextEditingController(text: "");
    final users = ref.watch(searchUserProvider(controller.text));
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search for friends'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // ignore: unused_result
                ref.refresh(searchUserProvider(controller.text));
              },
            ),
          ],
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(10),
            constraints: const BoxConstraints(
              minHeight: 0,
            ),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(20),
            ),
            child: users.when(
              data: (users) => ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users.elementAt(index);
                  return GestureDetector(
                    onTap: () async {
                      final anotherUserId = user.userId;
                      final chat = ref.read(createChatProvider(anotherUserId));
                      chat.when(
                        data: (chat) {
                          print(chat);
                        },
                        error: (e, s) => Center(child: Text("Error: $e")),
                        loading: () =>
                            LoadingScreen.instance().show(context: context),
                      );
                    },
                    child: UserTile(
                      user: user,
                    ),
                  );
                },
              ),
              error: (e, s) => Center(child: Text("Error: $e")),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ));
  }
}
