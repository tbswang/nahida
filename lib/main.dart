import 'package:flutter/material.dart';
import 'sqlite/todo_item.dart';
import 'sqlite/todo_provider.dart';

// ignore: constant_identifier_names
const IS_DONE = 1;
// ignore: constant_identifier_names
const IS_NOT_DONE = 0;

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'nahida do',
      theme: ThemeData(
// This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  // final String title;

  @override
  // State<MyHomePage> createState() => _MyHomePageState();
  TodoPageState createState() => TodoPageState();
}

class TodoPageState extends State<MyHomePage> {
  List<TodoItemData> _todoItemList = [];
  int _showStatus = IS_NOT_DONE;
  final _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshList();
    setState(() {
      _showStatus = IS_NOT_DONE;
    });
  }

  void _refreshList() async {
    List<TodoItemData> data = await todoItems(showStatus: _showStatus);
    setState(() {
      _todoItemList = data;
    });
  }

  showStatus(int status) async {
    setState(() {
      _showStatus = status;
    });
    _refreshList();
  }

  void _addTodoItem(String v) async {
    var data = await todoItems();
    var fido = TodoItemData(
      id: data.length + 1,
      title: v,
      status: 0,
    );
    insertTodoItem(fido);
    _refreshList();
    _todoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                // 选中的时候紫色
                style: _showStatus == 0
                    ? ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.purple.shade200),
                      )
                    : null,
                onPressed: () {
                  showStatus(0);
                },
                child: const Text("进行中")),
            ElevatedButton(
                // 选中的时候紫色
                style: _showStatus == 1
                    ? ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.purple.shade200),
                      )
                    : null,
                onPressed: () {
                  showStatus(IS_DONE);
                },
                child: const Text("已完成")),
            // ElevatedButton(
            //   onPressed: () {
            //     // clear();
            //     // do nothing
            //   },
            //   child: const Text('重置'),
            // ),
          ],
        ),
        Expanded(
          child: ListView.builder(
              itemCount: _todoItemList.length,
              itemBuilder: (BuildContext context, int index) {
                return CheckboxListTile(
                  title: Text(_todoItemList[index].title),
                  value: _todoItemList[index].status == IS_DONE,
                  onChanged: (bool? value) {
                    var data = _todoItemList[index];
                    var fido = TodoItemData(
                        id: data.id,
                        title: data.title,
                        status: data.status == IS_DONE ? IS_NOT_DONE : IS_DONE);
                    updateTodoItem(fido);
                    _refreshList();
                  },
                );
              }),
        ),
        TextField(
          decoration: InputDecoration(
            hintText: "请输入待办事项",
            contentPadding: const EdgeInsets.all(10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          controller: _todoController,
          onSubmitted: (v) {
            _addTodoItem(v);
          },
        )
      ],
    ));
  }
}
