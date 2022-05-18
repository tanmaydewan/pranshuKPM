import 'package:flutter/material.dart';
import 'package:kpmg_employees/viewdb_page.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import './new_entry_page.dart';
import './custom_dialogue_box.dart';

var lolol='';
List list = [];
List stringlist =[];

class AdminPage extends StatefulWidget {
  @override
  AdminPageState createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
  final del = TextEditingController();
  void delete_from_db(int id) async{
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      join(await getDatabasesPath(), 'database2.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE database2(id INTEGER PRIMARY KEY, name TEXT, designation TEXT, project TEXT, initiative TEXT, engagement_manager TEXT, start_date TEXT, end_date TEXT)',
        );
      },
      version: 1,
    );
    //Future<void> deleteEmployee(int id) async {
    final db = await database;
    await db.delete(
      'database2',
      where: 'id = ?',
      whereArgs: [id],
    );
    //}
  }
  void get_from_db() async{
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      join(await getDatabasesPath(), 'database2.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE database2(id INTEGER PRIMARY KEY, name TEXT, designation TEXT, project TEXT, initiative TEXT, engagement_manager TEXT, start_date TEXT, end_date TEXT)',
        );
      },
      version: 1,
    );
    Future<List<Employee_details>> database2() async {
      // Get a reference to the database.
      final db = await database;

      // Query the table for all The Dogs.
      final List<Map<String, dynamic>> maps = await db.query('database2');

      // Convert the List<Map<String, dynamic> into a List<Dog>.
      return List.generate(maps.length, (i) {
        return Employee_details(
          id: maps[i]['id'],
          name: maps[i]['name'],
          designation: maps[i]['designation'],
          project: maps[i]['project'],
          initiative: maps[i]['initiative'],
          engagement_manager: maps[i]['engagement_manager'],
          start_date: maps[i]['start_date'],
          end_date: maps[i]['end_date'],
        );
      });
    }
    list = await database2();
    lolol = list.toString();
    print(await database2());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ADMIN PAGE"),
        leading: IconButton(icon: Icon(Icons.menu), onPressed: (){},),
        centerTitle: true,
        backgroundColor: Color(0xff3249ab),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Column(
              children: <Widget>[
                //view button
                  Container(
                    height: 150,
                    padding: const EdgeInsets.all(10),
                  ),
                  ButtonTheme(
                      minWidth: double.infinity,
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: RaisedButton(
                        color: Color(0xff3249ab),
                        child: const Text('View Database', style: TextStyle(fontSize: 20, color: Colors.white)),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ViewDB()));
                          //put_into_db(int.parse(emp_id.text),name.text,lol,project.text,init.text,EM.text,start_date_rev,end_date_rev);
                          get_from_db();
                          print(list);
                        },
                      )
                  ),
                Text(''),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Align(
                    alignment: Alignment.topLeft,
                  child: Text(
                    'Which ID do you want to delete?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                    hintText: 'Enter text',),
                  controller: del,
                  keyboardType: TextInputType.number,
                ),
                Text(''),
                //delete button
                Container(
                  padding: const EdgeInsets.all(10),
                ),
                ButtonTheme(
                    minWidth: double.infinity,
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      color: Color(0xff3249ab),
                      child: const Text('Delete from database', style: TextStyle(fontSize: 20, color: Colors.white)),
                      onPressed: () {
                        //put_into_db(int.parse(emp_id.text),name.text,lol,project.text,init.text,EM.text,start_date_rev,end_date_rev);
                        delete_from_db(int.parse(del.text));

                        showDialog(context: context, builder: (context){
                          return CustomDialogBox(title: "Successfull", descriptions: ("The details of the employee having ID "+del.text+" has been deleted"), text: "Okay", img: Image.asset("assets/tick_mark.png"),);
                        }
                        );
                      },
                    )
                ),

              ],
            ),
          ),
        ),
      ),

    );
  }
}