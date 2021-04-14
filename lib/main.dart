import 'package:flutter/material.dart';
import 'todo.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Todo App",
      home: App(),
    ),
  );
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

@override
Widget build(BuildContext context) {
  return Form(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Enter your email',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            onPressed: () {
              // Validate will return true if the form is valid, or false if
              // the form is invalid.

              // Process data.
            },
            child: Text('Submit'),
          ),
        ),
      ],
    ),
  );
}

class _AppState extends State<App> {
  int k;
  List<Todo> items = List.empty(growable: true);
  final _formKey = GlobalKey<FormState>();
  final _textcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    k = items.length;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ToDo List"),
        ),
        body: ReorderableListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            for (int i = 0; i < items.length; i++)
              Dismissible(
                key: ValueKey(items[i].key),
                background: Container(
                  color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(
                          12.0,
                        ),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                onDismissed: (d) {
                  setState(() {
                    items.removeAt(i);
                  });
                  for (Todo it in items) {
                    print(it.title);
                  }
                },
                child: CheckboxListTile(
                    value: items[i].isFin,
                    onChanged: (val) {
                      setState(() {
                        items[i].setIsFin(val);
                      });
                    },
                    title: Text(
                      items[i].title,
                      // key: Key(value),
                      style: TextStyle(
                        fontSize: 22,
                        decoration: items[i].isFin
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: items[i].isFin ? Colors.red : Colors.black,
                      ),
                    )),
              )
          ],
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              var getReplacedWidget = items.removeAt(oldIndex);
              items.insert(newIndex, getReplacedWidget);
            });
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text("Add Todo"),
                content: Container(
                  height: 150,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        // Add TextFormFields and ElevatedButton here.
                        TextFormField(
                          controller: _textcontroller,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, otherwise false.
                            if (_formKey.currentState.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.

                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Added todo')));
                              setState(() {
                                items.add(Todo(
                                  ++k,
                                  _textcontroller.text,
                                ));
                                _textcontroller.clear();
                              });
                              Navigator.of(ctx).pop();
                            }
                          },
                          child: Text('Add'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          label: Text('New ToDo'),
          icon: Icon(Icons.add),
          backgroundColor: Colors.pink,
        ));
  }
}
