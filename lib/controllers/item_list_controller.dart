import 'package:flutter_shopping_list/controllers/auth_controller.dart';
import 'package:flutter_shopping_list/models/item_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final itemListControllerProvider =
    StateNotifierProvider<ItemListController, AsyncValue<List<Item>>>((ref) {
  final user = ref.watch(authControllerProvider);
  return ItemListController(ref.read, user?.uid);
});

class ItemListController extends StateNotifier<AsyncValue<List<Item>>> {
  final Reader _read;
  final String? userId;

  ItemListController(this._read, this._userId) : super(AsyncValue.loading());
}
