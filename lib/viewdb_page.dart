import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import './new_entry_page.dart';
import 'package:sqflite/sqflite.dart';
import './custom_dialogue_box.dart';

List list = [];
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
  print(await database2());
}

final del = TextEditingController();

class ViewDB extends StatelessWidget {
  const ViewDB({Key? key}) : super(key: key);

  static const String _title = 'EMPLOYEE DATABASE';


  @override
  Widget build(BuildContext context) {
    get_from_db();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.menu), onPressed: (){},),
          centerTitle: true,
          title: Text(_title),
          backgroundColor: Color(0xff3249ab),),
        body: const MyStatefulWidget(),
      ),
    );
  }
}


class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int counter=2;
  List employeeDetails = list;
  setState(value){
    employeeDetails = list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(15),
                  child: const Align(alignment: Alignment.topLeft,

                    child: Text('Project Information',
                      style:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Color(0xff3249ab)),
                    ),),
                ),
                Container(
                    height: 450,
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child:
                          createDataTable(),
                        )
                    )
                ),

                Container(
                  padding: EdgeInsets.all(10),
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: (){},
                          child: const Text("           Edit           ", style: TextStyle(color: Colors.white, fontSize: 18),),
                          color: Color(0xff3249ab),),

                        RaisedButton(onPressed: (){
                            delete_from_db(int.parse(del.text));

                            showDialog(context: context, builder: (context){
                              return CustomDialogBox(title: "Successful", descriptions: ("The details of the employee having ID - "+del.text+" has been deleted"), text: "Okay", img: Image.asset("assets/tick_mark.png"),);
                            }
                            );
                        },
                          child: const Text("     Remove     ", style: TextStyle(color: Colors.white, fontSize: 18)),
                          color: Colors.red,),

                      ],)
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                        hintText: 'Enter employee ID to delete',),
                      controller: del,
                      keyboardType: TextInputType.number,
                    ),

                  ),
                )
              ],
            )
        )
    );

  }

  DataTable  createDataTable() {
    return DataTable(columns: _createColumns(),
      rows: _createRows(),
      dividerThickness: 3,
      dataRowHeight: 50,
      showBottomBorder: true,
      headingTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white
      ),
      dataTextStyle: TextStyle(fontSize: 16, color: Colors.black),
      headingRowColor: MaterialStateProperty.resolveWith(
              (states) => Color(0xff3249ab)
      ),
    );
  }
  List<DataColumn> _createColumns() {
    return [
      const DataColumn(label: Text('Emp ID')),
      const DataColumn(label: Text('Full Name')),
      const DataColumn(label: Text('Designation')),
      const DataColumn(label: Text('Current Project')),
      const DataColumn(label: Text('Current Initiative')),
      const DataColumn(label: Text('Engagement Manager')),
      const DataColumn(label: Text('Start Date')),
      const DataColumn(label: Text('End Date')),

    ];
  }
  List<DataRow> _createRows() {
    //print(employeeDetails);
    return employeeDetails
        .map((employeeDetails) => DataRow(cells: [
      DataCell(Text(employeeDetails.id.toString())),
      DataCell(Text(employeeDetails.name)),
      DataCell(Text(employeeDetails.designation)),
      DataCell(Text(employeeDetails.project)),
      DataCell(Text(employeeDetails.initiative)),
      DataCell(Text(employeeDetails.engagement_manager)),
      DataCell(Text(employeeDetails.start_date)),
      DataCell(Text(employeeDetails.end_date)),
    ],))
        .toList();
  }
}