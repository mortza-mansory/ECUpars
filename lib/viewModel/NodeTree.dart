import 'package:get/get.dart';

enum NodeType { category, issue, step, article, saved }

class NavigationNode {
  final NodeType type;
  final int id;
  NavigationNode({required this.type, required this.id});

  @override
  String toString() => '{type: $type, id: $id}';
}

final RxList<NavigationNode> globalNavigationStack = <NavigationNode>[].obs;