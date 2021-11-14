import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_shopping_list/controllers/auth_controller.dart';
import 'package:flutter_shopping_list/controllers/item_list_controller.dart';
import 'package:flutter_shopping_list/models/item_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Riverpod',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends HookWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authControllerState = useProvider(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
          title: const Text('Shopping List'),
          leading: authControllerState != null
              ? IconButton(
                  onPressed: () =>
                      context.read(authControllerProvider.notifier).signOut(),
                  icon: const Icon(Icons.logout),
                )
              : null),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddItemDialog.show(context, Item.empty()),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddItemDialog extends HookWidget {
  const AddItemDialog({Key? key, required this.item}) : super(key: key);

  static void show(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (context) => AddItemDialog(item: item),
    );
  }

  final Item item;

  bool get isUpdating => item.id != null;

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController(text: item.name);
    return Dialog(
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Item Name'),
              ),
              const SizedBox(
                height: 12.0,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: isUpdating
                          ? Colors.orange
                          : Theme.of(context).primaryColor),
                  onPressed: () {
                    isUpdating
                        ? context
                            .read(itemListControllerProvider.notifier)
                            .updateItem(
                                updatedItem: item.copyWith(
                                    name: textController.text.trim(),
                                    obtained: item.obtained))
                        : context
                            .read(itemListControllerProvider.notifier)
                            .addItem(name: textController.text.trim());
                    Navigator.of(context).pop();
                  },
                  child: Text(isUpdating ? 'Update' : 'Add'),
                ),
              ),
            ],
          )),
    );
  }
}
