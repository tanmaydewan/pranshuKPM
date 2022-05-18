import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kpmg_employees/custom_dialogue_box.dart';
import 'package:kpmg_employees/signup_page.dart';
import 'package:kpmg_employees/welcome_page.dart';
import 'package:path/path.dart';
import './new_entry_page.dart';
import 'package:sqflite/sqflite.dart';

import 'viewdb_page.dart';

int check = -1;
int search_name_in_list(String name,List list){
  for(int i=0;i<list.length;i++){
    if(list[i]['full_name']==name||list[i]['user_name']==name||list[i]['email']==name)
      {
        return i;
      }
  }
  return -1;
}

var Users = [
  {'full_name':'Akhilesh Manikandan','user_name':'akhilesh_mani','password':'kpmg','email':'akhileshm1@kpmg.com'},
  {'full_name':'Devanshi Aggarwal','user_name':'devanshi_a','password':'kpmg', 'email':'devanshia@kpmg.com.com'},
  {'full_name':'Devanshi Aggarwal','user_name':'devanshi_a','password':'kpmg','email':'prathits@kpmg.com'}
];
List employee_list = [];
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
  employee_list = await database2();
  //print(await database2());
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const String _title = 'LOGIN';

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


TextEditingController nameController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  bool validate_name = false;
  //bool validate_username = true;
  bool isHiddenPassword = true;
  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5),
                child: Image(
                    height: 150,
                    width: 200,
                    image: AssetImage('assets/KPMG_logo.png')
                )
            ),

            Container(
                padding: const EdgeInsets.all(5),
                child: const Text(
                  'Username',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                )),
            Container(
              padding: EdgeInsets.all(5),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  errorText: validate_name ? 'Value Can\'t Be Empty' : null,
                  border: OutlineInputBorder(),
                  labelText: 'Phone no, Username or Email',
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(5),
                child: const Text(
                  'Password',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                )),

            Container(

              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(

                  obscureText: isHiddenPassword,
                  controller: passwordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Password',
                      suffixIcon: InkWell(
                          onTap: _togglepasswordView,
                          child: Icon(
                            isHiddenPassword ? Icons.visibility : Icons.visibility_off,)
                      )
                  )
              ),
            ),

            TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: const Text('Forgot Password ?',
                  style: TextStyle(fontSize: 17,color: Color(0xff3249ab), fontWeight: FontWeight.bold)),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Color(0xff3249ab)),
                  child: const Text('Login', style: TextStyle(fontSize: 20),),
                  onPressed: () {
                      setState(() {
                        nameController.text.isEmpty ? validate_name = true :validate_name = false;
                      });
                    if(nameController.text=='admin'){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ViewDB()));
                    }
                    else {
                      check = search_name_in_list(nameController.text, Users);
                      if(check==-1)
                        {
                          showDialog(context: context, builder: (context){
                            return CustomDialogBox(title: "Oops!", descriptions: "It seems like the username you have entrered does not exist. Kindly check the username once again.\n\n If you do not have an account, tap Sign Up to create one", text: "Okay", img: Image.asset("assets/exclamation_mark.png"));
                          });
                        }
                      else {
                        if(passwordController.text == Users[check]['password']){
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => WelcomePage()));}
                        else{
                          showDialog(context: context, builder: (context){
                            return CustomDialogBox(title: "Oops!", descriptions: "It seems like the password you have entered does not match with the username. Kindly check the username/password once again.\n\n If you do not have an account, tap Sign Up to create one", text: "Okay", img: Image.asset("assets/exclamation_mark.png"));
                          });
                        }
                      }
                    }
                    //print(nameController.text);
                    //print(passwordController.text);
                  },
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Do not have an account?'),
                TextButton(
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 17, color: Color(0xff3249ab), fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Signup()));
                    //signup screen
                  },
                )
              ],

            ),
          ],
        ));
  }
  void _togglepasswordView(){
    if(isHiddenPassword == true){
      isHiddenPassword = false;
    }else{
      isHiddenPassword = true;
    }
    setState(() {});
  }
}

