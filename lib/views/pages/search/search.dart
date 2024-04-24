import 'package:chat_app/state/user/providers/search_user_provider.dart';
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
                  return ListTile(
                    title: Text(user.displayName),
                    subtitle: Text(user.email ?? ""),
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
