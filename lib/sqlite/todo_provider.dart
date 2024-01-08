import 'database_helper.dart';
import 'todo_item.dart';

// Define a function that inserts dogs into the database
Future<int> insertTodoItem(TodoItemData todoItemData) async {
  final db = await DatabaseHelper.instance.database;
  return await db.insert(
    'todo_item',
    todoItemData.toMap(),
  );
}

Future<int> updateTodoItem(TodoItemData todoItemData) async {
  final db = await DatabaseHelper.instance.database;

  return await db.update(
    'todo_item',
    todoItemData.toMap(),
    // Ensure that the Dog has a matching id.
    where: 'id = ?',
    // Pass the Dog's id as a whereArg to prevent SQL injection.
    whereArgs: [todoItemData.id],
  );
}

clear() async {
  final db = await DatabaseHelper.instance.database;
  return await db.execute('DELETE FROM todo_item');
}

_reset() async {
  final db = await DatabaseHelper.instance.database;
  return await db.execute('DROP TABLE todo_item');
}

Future<List<TodoItemData>> todoItems({int showStatus = -1}) async {
  // Get a reference to the database.
  final db = await DatabaseHelper.instance.database;

  var maps;
  if (showStatus >= 0) {
    maps = await db
        .query('todo_item', where: 'status = ?', whereArgs: [showStatus]);
  } else {
    maps = await db.query('todo_item');
  }
  // Query the table for all The Dogs.

  // Convert the List<Map<String, dynamic> into a List<Dog>.
  return List.generate(maps.length, (i) {
    return TodoItemData(
      id: maps[i]['id'] as int,
      title: maps[i]['title'] as String,
      status: maps[i]["status"] as int,
    );
  });
}
