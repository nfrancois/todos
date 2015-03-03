import 'package:polymer/polymer.dart';
import 'package:todos/model.dart';

@CustomTag('todos-app')
class TodosApp extends PolymerElement {
  
  @observable
  List<Item> todos = [new Item.fromName("Action 1"), new Item.fromName("Action 2")..done = true];
  
  TodosApp.created() : super.created();
  
  @observable
  int get remaining => todos.where((todo) => todo.done == true).length;

}