import 'package:chat_app/state/auth/providers/user_provider.dart';
import 'package:chat_app/state/chat/providers/create_chat_provider.dart';
import 'package:chat_app/state/user/providers/search_user_provider.dart';
import 'package:chat_app/utils/snackbar.dart';
import 'package:chat_app/views/components/user_tile.dart';
import 'package:chat_app/views/pages/chat/individual_chat.dart.dart';
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
                  if (user.userId == ref.read(userProvider)!.userId) {
                    return const SizedBox.shrink();
                  }
                  return GestureDetector(
                    onTap: () async {
                      //Get the userId of the user you want to chat with
                      final anotherUserId = user.userId;
                      //Read the createChatProvider
                      final chat = ref.watch(createChatProvider(anotherUserId));
                      chat.when(
                        data: (chat) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  IndividualChat(chat: chat)));
                        },
                        error: (e, s) {
                          FlutterSnackbar.showSnackbar(e.toString(), context);
                        },
                        loading: () =>
                            FlutterSnackbar.showSnackbar("Loading...", context),
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
