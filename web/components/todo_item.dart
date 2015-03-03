import 'package:polymer/polymer.dart';
import 'package:todos/model.dart';

@CustomTag('todo-item')
class TodoItem extends PolymerElement {
  
  @published Item todo; 
  
  TodoItem.created() : super.created();

}