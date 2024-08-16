import 'package:beni2_sqflit/db/curd.dart';
import 'package:beni2_sqflit/model/note.dart';
import 'package:beni2_sqflit/utils/context_extension.dart';
import 'package:beni2_sqflit/utils/date_time_manager.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();
  final GlobalKey<FormState> _editKey = GlobalKey();
  late TextEditingController _editingController;
  List<Note> _notes = [];
  List<Color> colors = [
    Colors.yellow[100]!,
    Colors.blue[100]!,
    Colors.pink[100]!,
    Colors.green[100]!,
    Colors.orange[100]!,
    Colors.deepPurple[100]!,
    Colors.teal[100]!,
    Colors.blueGrey[100]!,
    Colors.red[100]!,
    Colors.indigo[100]!
  ];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(
      () {
        // print('=====> ${_controller.value.text}');
      },
    );
    _getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _controller,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(color: Colors.yellow, width: 2)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(color: Colors.indigo, width: 2)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(color: Colors.green, width: 2)),
                            labelText: 'Write your note',
                            prefixIcon: Icon(Icons.note_alt)),
                        validator: (value) =>
                            value!.isEmpty ? 'Required field' : null,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: colors.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              color: colors[index],
                              child: Visibility(
                                visible: _selectedIndex == index,
                                child: const Icon(Icons.check),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (_key.currentState!.validate()) {
                              Note note = Note(
                                  text: _controller.value.text,
                                  createdDate: DateTimeManager.currentDate(),
                                  color: colors[_selectedIndex].value);
                              _saveNote(note);
                            }
                          },
                          child: Text('Add Note')),
                      _notes.isEmpty
                          ? SizedBox(
                              width: 100,
                              height: 200,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                        'https://icons.veryicon.com/png/o/business/financial-category/no-data-6.png'),
                                    Text(
                                      'No data found',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    )
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: _notes.length,
                              itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, left: 8.0, top: 16.0),
                                    child: ListTile(
                                      tileColor: Color(_notes[index].color ??
                                          colors[0].value),
                                      title: Text(_notes[index].text),
                                      subtitle: SizedBox(
                                          width: 200,
                                          child: Row(
                                            children: [
                                              Visibility(
                                                visible:
                                                    _notes[index].updatedDate !=
                                                        null,
                                                replacement: Text(
                                                    'created on: ${_notes[index].createdDate}'),
                                                child: Text(
                                                    'updated on: ${_notes[index].updatedDate ?? ''}'),
                                              )
                                            ],
                                          )),
                                      trailing: SizedBox(
                                        width: 100,
                                        child: Row(
                                          children: [
                                            IconButton(
                                                onPressed: () =>
                                                    _showEditDialog(
                                                        _notes[index]),
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: Colors.green,
                                                )),
                                            IconButton(
                                                onPressed: () => _deleteNote(
                                                    _notes[index].id!),
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))
                    ],
                  )),
            ),
          ],
        ),
      )),
    );
  }

  void _saveNote(Note note) {
    Curd.op.insert(note).then(
      (row) {
        //1-clear field
        _controller.clear();
        //2-notify user
        context.showBanner('Note is saved successfully');
        //3-update UI
        _getNotes();
      },
    );
  }

  void _getNotes() {
    Curd.op.select().then((notes) {
      setState(() {
        _notes = notes;
      });
    });
  }

  _deleteNote(int id) {
    Curd.op.delete(id).then(
      (row) {
        context.showBanner('Note is delete successfully');
        _getNotes();
      },
    );
  }

  _updateNote(Note note) {
    Curd.op.update(note).then(
      (row) {
        context.showBanner('Note is updated successfully');
        _getNotes();
      },
    );
  }

  _showEditDialog(Note note) {
    _editingController = TextEditingController(text: note.text);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Note'),
        content: Wrap(
          children: [
            Form(
                key: _editKey,
                child: TextFormField(
                  controller: _editingController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.yellow, width: 2)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.indigo, width: 2)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.red, width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide:
                              BorderSide(color: Colors.green, width: 2)),
                      labelText: 'Write your note',
                      prefixIcon: Icon(Icons.note_alt)),
                  validator: (value) =>
                      value!.isEmpty ? 'Required field' : null,
                ))
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          TextButton(
              onPressed: () {
                if (_editKey.currentState!.validate()) {
                  note.text = _editingController.value.text;
                  note.updatedDate = DateTimeManager.currentDate();
                  _updateNote(note);
                  Navigator.pop(context);
                }
              },
              child: Text('Update')),
        ],
      ),
    );
  }
}
