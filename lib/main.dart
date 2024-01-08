import 'package:flutter/material.dart';
import 'sqlite/todo_item.dart';
import 'sqlite/todo_provider.dart';

// ignore: constant_identifier_names
const IS_DONE = 1;

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  // State<MyHomePage> createState() => _MyHomePageState();
  State<MyHomePage> createState() => _TodoPageState();
}

class _TodoPageState extends State<MyHomePage> {
  List<TodoItemData> todoItemList = [];

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  _refreshList() async {
    List<TodoItemData> data = await todoItems();
    print(data);
    setState(() {
      todoItemList = data;
    });
  }

  final _todoController = TextEditingController();
  var showStatus = 0;

  _showStatus(int status) async {
    showStatus = status;
    setState(() {});
  }

  void _addTodoItem(String v) async {
    var data = await todoItems();
    var fido = TodoItemData(
      id: data.length + 1,
      title: v,
      status: 0,
    );
    insertTodoItem(fido);
    setState(() {});
  }

  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder(
  //       future: todoItems(showStatus: showStatus),
  //       builder:
  //           (BuildContext context, AsyncSnapshot<List<TodoItemData>> snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(child: CircularProgressIndicator());
  //         } else if (snapshot.hasError) {
  //           return Text('Error: ${snapshot.error}');
  //         } else if (!snapshot.hasData) {
  //           return const TextField(
  //               decoration: InputDecoration(
  //             hintText: "请输入待办事项",
  //             contentPadding: const EdgeInsets.all(10.0),
  //           ));
  //         } else if (snapshot.connectionState == ConnectionState.done) {
  //           final _todoItemList = snapshot.data ?? [];
  //           return Scaffold(
  //             body: Column(children: <Widget>[
  //               ButtonBar(
  //                 alignment: MainAxisAlignment.center,
  //                 children: <Widget>[
  //                   ElevatedButton(
  //                       // 选中的时候紫色
  //                       style: showStatus == 0
  //                           ? ButtonStyle(
  //                               backgroundColor:
  //                                   MaterialStateProperty.all<Color>(
  //                                       Colors.purple.shade200),
  //                             )
  //                           : null,
  //                       onPressed: () {
  //                         _showStatus(0);
  //                       },
  //                       child: const Text("进行中")),
  //                   ElevatedButton(
  //                       // 选中的时候紫色
  //                       style: showStatus == 1
  //                           ? ButtonStyle(
  //                               backgroundColor:
  //                                   MaterialStateProperty.all<Color>(
  //                                       Colors.purple.shade200),
  //                             )
  //                           : null,
  //                       onPressed: () {
  //                         _showStatus(IS_DONE);
  //                       },
  //                       child: const Text("已完成")),
  //                   ElevatedButton(
  //                     onPressed: () {
  //                       clear();
  //                       setState(() {});
  //                     },
  //                     child: const Text('重置'),
  //                   ),
  //                 ],
  //               ),
  //               Expanded(
  //                 child: ListView.builder(
  //                   itemCount: _todoItemList.length,
  //                   itemBuilder: (BuildContext context, int index) {
  //                     return CheckboxListTile(
  //                       title: Text(_todoItemList[index].title),
  //                       value: _todoItemList[index].status == IS_DONE,
  //                       onChanged: (bool? value) {
  //                         var data = _todoItemList[index];
  //                         var fido = TodoItemData(
  //                             id: data.id,
  //                             title: data.title,
  //                             status: data.status == IS_DONE ? 0 : IS_DONE);
  //                         updateTodoItem(fido);
  //                         setState(() {});
  //                       },
  //                     );
  //                   },
  //                 ),
  //               ),
  //               TextField(
  //                 decoration: InputDecoration(
  //                   hintText: "请输入待办事项",
  //                   contentPadding: const EdgeInsets.all(10.0),
  //                   border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(15.0),
  //                   ),
  //                 ),
  //                 controller: _todoController,
  //                 onSubmitted: (v) {
  //                   _addTodoItem(v);
  //                   // 清空text filed
  //                   _todoController.clear();
  //                   // focus 到 text filed
  //                   FocusScope.of(context).requestFocus(FocusNode());
  //                 },
  //               )
  //             ]),
  //           );
  //         } else {
  //           return const Center(child: Text("Error"));
  //         }
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: todoItemList.length,
              itemBuilder: (BuildContext context, int index) {
                return CheckboxListTile(
                  title: Text(todoItemList[index].title),
                  value: todoItemList[index].status == IS_DONE,
                  onChanged: (bool? value) {
                    var data = todoItemList[index];
                    var fido = TodoItemData(
                        id: data.id,
                        title: data.title,
                        status: data.status == IS_DONE ? 0 : IS_DONE);
                    updateTodoItem(fido);
                    setState(() {});
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
            print(v);
            _addTodoItem(v);
            // 清空text filed
            // _todoController.clear();
            // focus 到 text filed
            // FocusScope.of(context).requestFocus(FocusNode());
          },
        )
      ],
    ));
  }
}
