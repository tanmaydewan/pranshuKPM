import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './login_page.dart';
import './new_entry_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  static const String _title = 'WELCOME';

  @override
  Widget build(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Container(
              alignment: Alignment.topRight,
              padding: const EdgeInsets.all(5),
              child: Image(
                  height: 100,
                  width: 250,
                  image: AssetImage('assets/KPMG_logo_2.png')
              )
          ),
          Container(
              padding: EdgeInsets.only(top: 100, left: 10),
              child: const Text(
                'Welcome!',
                style: TextStyle(fontSize: 60, color: Color(0xff3249ab), fontWeight: FontWeight.w200),
              )),
          Container(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                Users[check]['full_name']!,
                style: TextStyle(fontSize: 40, color: Color(0xff3249ab), fontWeight: FontWeight.w500),
              )),
          Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Row(
                  children: [ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Color(0xff3249ab), minimumSize: Size(60,50)),
                    child: const Text('    Add New Entry     ', style: TextStyle(fontSize: 20)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NewEntry()));
                    },
                  )]
              )
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Row(
                  children: [ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.white, minimumSize: Size(60,50),
                      side: BorderSide(
                        width: 1.0,
                        color: Color(0xff3249ab),
                      ),),
                    child: const Text('Review Past Entries', style: TextStyle(fontSize: 20, color: Color(0xff3249ab))),
                    onPressed: () {

                    },
                  )]
              )
          ),

          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.fromLTRB(10, 45, 10, 10),
            child: Text('© 2022 Copyright owned by one or more of the KPMG International entities.'
                ' KPMG International entities provide no services to clients. All rights reserved.',
                style: TextStyle(color: Color(0xff3249ab),)
            ),
          )
        ],
      ),);
  }
}