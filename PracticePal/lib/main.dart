import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practice Pal',
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
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Practice Pal'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Session {
  Session({
    this.name,
    this.date,
    this.dur,
    this.equipment,
    this.sets,
    this.key,
    // this.hasVideo = false,
  });

  String name;
  DateTime date;
  Duration dur;
  List<String> equipment;
  List<String> sets;
  Key key;
  // bool hasVideo;
}

// Initialize displayed session list
List<Session> initSessionList() {
  
  // Fetch database here
  // constant list for now
  List<Session> sessions =  <Session>[Session(name: "Sweet gainz",          date: new DateTime.utc(2020, 10, 18),  equipment: <String>["Pants"],           sets: List<String>(),  dur: new Duration(hours:0, minutes:5), key: Key("a")),
                                      Session(name: "Pumpin' Uranium",      date: new DateTime.utc(2020, 9, 22),   equipment: <String>["Shirt","Weights"], sets: List<String>(),  dur: new Duration(hours:0, minutes:5), key: Key("b")),
                                      Session(name: "Something else funny", date: new DateTime.utc(2020, 7, 2),    equipment: <String>["Shirt","Shoes"],   sets: List<String>(),  dur: new Duration(hours:0, minutes:5), key: Key("c"))];

  return sessions;
}

// add newSession to database
void addSession(sessions, newSession) {

  bool updateDBSuccess = true;

  // insert session at the top of the list (index 0)
  if (updateDBSuccess) {
    sessions.insert(0,newSession);
  }

}

Widget slideRightBackground() {
  return Container(
    color: Colors.green,
    margin: const EdgeInsets.all(4),
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          Text(
            " Edit",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
    ),
  );
}

Widget slideLeftBackground() {
  return Container(
    color: Colors.red,
    margin: const EdgeInsets.all(4),
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Text(
            " Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    ),
  );
}

class _MyHomePageState extends State<MyHomePage> {


  List<Session> _sessions;
  List<Session> _filteredSessions;

  // Text editing controllers for all text fields
  TextEditingController _searchController;

  void initState() {
    super.initState();
    // initialize list of sessions
    _sessions = initSessionList();
    _filteredSessions = _sessions;
    _searchController = TextEditingController();
  }

  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)} hrs $twoDigitMinutes min";
  }

  // search a list of strings
  bool _listContains (searchString, listString) {
    bool matchflag = false;

    for(var i=0;i<listString.length;i++) {
      if (listString[i].toLowerCase().contains(searchString)) {
        matchflag = true;
      }
    }
    return matchflag;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    //_filteredSessions = _sessions;
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _filteredSessions.length + 1,
          itemBuilder: (BuildContext context, int index) {

            // Search bar
            if (index == 0) {
              return TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                ),

                // When text changes, search in session names, equipment tags, and sets tags
                // _sessions is entire database, _filteredSessions is whats filtered based on search
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      _filteredSessions = _sessions;
                    }
                    else {
                      _filteredSessions = List.of(_sessions);
                      _filteredSessions.retainWhere((item) => ((_listContains(value.toLowerCase() ,item.equipment) || _listContains(value.toLowerCase() ,item.sets) || (item.name.toLowerCase().contains(value.toLowerCase())) )));
                    }
                  });
                },
              );
            }

            // List of sessions as Cards, filtered based on Search
            // [index -1] is because index 0 is the search bar (dumb way to build the widget list, oh well)
            else {
              return Dismissible(
                key: _filteredSessions[index-1].key,
                onDismissed: (direction) {
                  setState(() {
                    // delete Session
                    _sessions.remove(_filteredSessions[index-1]);
                  });
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("Session removed")));
                },
                background: slideRightBackground(),
                secondaryBackground: slideLeftBackground(),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirm"),
                          content: const Text("Are you sure you want to delete this session?"),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("DELETE")
                            ),
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("CANCEL"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  else {
                    _navigateAndDisplaySelection(context, _filteredSessions[index-1]);
                    _searchController.clear();
                    setState(() {
                      _filteredSessions = _sessions;
                    });
                  }
                },
                child: Card(
                  child: ListTile(
                    leading: FlutterLogo(),
                    title: Text(DateFormat("MM/dd/yyyy").format( _filteredSessions[index-1].date) + " " + _filteredSessions[index-1].name),
                    subtitle: Text(_printDuration(_filteredSessions[index-1].dur) + '\n' + "Equipment: " + _filteredSessions[index-1].equipment.join(", ") + '\n' + "Sets: " + _filteredSessions[index-1].sets.join(", ")),
                    trailing: Icon(Icons.more_vert),
                  ),
                ),
              );
            }
          }
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{

          //_addSession;
          switch (await showDialog<int>(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                title: const Text('Select option'),
                children: <Widget>[
                  SimpleDialogOption(
                    onPressed: () { Navigator.pop(context, 0); },
                    child: const Text('Start Session Now'),
                  ),
                  SimpleDialogOption(
                    onPressed: () { Navigator.pop(context, 1); },
                    child: const Text('Add Previous Session'),
                  ),
                ],
              );
            }
          )) {
            case 0:
              // Start new session
            break;
            case 1:
              _navigateAndDisplaySelection(context);
              _searchController.clear();
              setState(() {
                _filteredSessions = _sessions;
              });
            break;
          }
        },
        tooltip: 'Add Session',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  _navigateAndDisplaySelection(BuildContext context, [Session session = null]) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.

    // ?? and ??= will only happen if session is null, or not given
    bool editingSession = (session != null);
    session ??= new Session(name:null, date: new DateTime.now(), equipment: <String>["fitness"], sets: List<String>(), dur: Duration(minutes: 10), key: UniqueKey());

    final Session result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ManualAddScreen(this, "Add New Session", session, editingSession)),
    );
    //return result;
  }
}

// Build the list tags using Chip widgets
List<Widget> buildChips(widget, tags) {
  List<Widget> chips = new List();
  for (var i = 0; i < tags.length; i++) {
    Chip tagChip = Chip(
      label: Text(tags[i]),
      onDeleted: () {
        tags.removeAt(i);
        widget.setState(() {
          tags = tags;
        });
      },
    );
    chips.add(tagChip);
  }
  return chips;
}

// Build common tag widget textbox and chips
Widget buildTagEntry(widget, controller, focusNode, hintString, tagList) {
  return TextField(
    controller: controller,
    focusNode: focusNode,
    decoration: InputDecoration(
      hintText: hintString,
      suffixIcon: IconButton(
        onPressed: () {
          widget.setState(() {
              tagList.add(controller.text);
          });
          controller.clear();
          focusNode.requestFocus();
        },
        icon: Icon(Icons.add_circle_outlined),
      ),
    ),
    onEditingComplete: () {
      widget.setState(() {
        tagList.add(controller.text);
      });
      controller.clear();
      focusNode.requestFocus();
    },
  );
}

// Build submit button


class ManualAddScreen extends StatefulWidget {
  _MyHomePageState parent;
  final String title;
  Session session;
  bool editingSession;
  ManualAddScreen(this.parent, this.title, this.session, this.editingSession);

  @override
  _ManualAddScreenState createState() => _ManualAddScreenState();
}

class _ManualAddScreenState extends State<ManualAddScreen> {
 
  TextEditingController _nameController;
  TextEditingController _equipTagController;
  TextEditingController _setTagController;
  TextEditingController _dateController;

  FocusNode equipFocusNode;
  FocusNode setFocusNode;

  // Session newSession;

  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _equipTagController = TextEditingController();
    _setTagController = TextEditingController();
    _dateController = TextEditingController();
    // newSession = new Session(name:null, date: new DateTime.now(), equipment: <String>["fitness"], sets: List<String>(), dur: Duration(minutes: 10), key: UniqueKey());

    _nameController.text = widget.session.name;
  }

  void dispose() {
    _nameController.dispose();
    _equipTagController.dispose();
    _setTagController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[

            // Date picker
            // TODO: make this a pop-up or actually update on change
            InputDatePickerFormField (
              firstDate: new DateTime(0),
              lastDate: new DateTime.now(),
              initialDate: new DateTime.now(),
              onDateSubmitted: (date) {
                widget.session.date = date;
              },
            ),

            // Session duration
            CupertinoTimerPicker (
              mode: CupertinoTimerPickerMode.hm,
              minuteInterval: 1,
              initialTimerDuration: new Duration(minutes: 10),
              onTimerDurationChanged: (valuechanged) {
                widget.session.dur = valuechanged;
              },
            ),

            // Optional session name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Enter optional session name',
              ),
            ),

            // Equipment tag entry text field
            buildTagEntry(this, _equipTagController, equipFocusNode, 'Enter Equipment', widget.session.equipment),

            // Equipment tag chip display
            Wrap(
              spacing: 4.0, // gap between adjacent chips
              runSpacing: 2.0, // gap between lines
              children: buildChips(this, widget.session.equipment),
            ),
            
            // Text field for sets
            buildTagEntry(this, _setTagController, setFocusNode, 'Enter Sets', widget.session.sets),

            // Sets tag chip display
            Wrap(
              spacing: 4.0, // gap between adjacent chips
              runSpacing: 2.0, // gap between lines
              children: buildChips(this, widget.session.sets),
            ),

            // Submit button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  print(widget.editingSession);
                  if (widget.editingSession) {
                    // edit session in database
                    widget.parent.setState(() {
                      widget.session = widget.session;
                    });
                  }

                  else {
                    // if no name is entered, use default
                    if (_nameController.text.isEmpty) {
                      widget.session.name = "Fitness Session";
                    }
                    else {
                      widget.session.name = _nameController.text;
                    }

                    // add session to database and displayed list
                    widget.parent.setState(() {
                      addSession(widget.parent._sessions, widget.session);
                    });
                  }
                  Navigator.pop(context);
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}