import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kpmg_employees/custom_dialogue_box.dart';
import 'package:kpmg_employees/login_page.dart';

class Signup extends StatelessWidget {
  const Signup({Key? key}) : super(key: key);

  static const String _title = 'SIGN UP';

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

  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  bool isHiddenPassword = true;
  bool isHiddenConfirmPassword = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child:SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 30),
        child: Column(
            children: <Widget>[

              //name container

              Container(
                  padding: const EdgeInsets.all(5),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Full Name',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      )
                  )
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: TextField(
                  style: TextStyle(fontSize: 18),
                  controller: fullnameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Full Name',
                  ),
                ),
              ),

              //email container

              Container(
                  padding: const EdgeInsets.all(5),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'E-mail',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      )
                  )),
              Container(
                padding: const EdgeInsets.all(5),
                child: TextField(
                  style: TextStyle(fontSize: 18),
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'abc@kpmg.com',
                  ),
                ),
              ),

              //username container

              Container(
                  padding: const EdgeInsets.all(5),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Username',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                  )),
              Container(
                padding: const EdgeInsets.all(5),
                child: TextField(
                  style: TextStyle(fontSize: 18),
                  controller: usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'e.g.- william_smith',
                  ),
                ),
              ),

              //phone container

              Container(
                  padding: const EdgeInsets.all(5),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Phone Number',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                  )),
              Container(
                padding: const EdgeInsets.all(5),
                child: TextField(
                  style: TextStyle(fontSize: 18),
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '+91 - XXXXXXXXXX',
                  ),
                ),
              ),

              //create password container

              Container(
                  padding: const EdgeInsets.all(5),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Create Password',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                  )),
              Container(
                padding: const EdgeInsets.all(5),
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

              //confirm password container

              Container(
                  padding: const EdgeInsets.all(5),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Re-enter Password',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                  )),
              Container(
                padding: const EdgeInsets.all(5),
                child: TextField(
                    obscureText: isHiddenConfirmPassword,
                    controller: confirmpasswordController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        suffixIcon: InkWell(
                            onTap: _toggleconfirmpasswordView,
                            child: Icon(
                              isHiddenConfirmPassword ? Icons.visibility : Icons.visibility_off,)
                        )
                    )
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
              ),
              ButtonTheme(
                  minWidth: double.infinity,
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RaisedButton(
                    color: Color(0xff3249ab),
                    child: const Text('Create Account', style: TextStyle(fontSize: 20, color: Colors.white)),
                    onPressed: () {
                      if(passwordController.text==confirmpasswordController.text) {
                        Users.add({
                          'full_name': fullnameController.text,
                          'user_name': usernameController.text,
                          'password': passwordController.text,
                          'email': emailController.text,
                        });
                        //print(Users[0]['full_name']);
                        showDialog(context: context, builder: (context) {
                          return CustomDialogBox(title: "Congrats!",
                            descriptions: "Your account has been created\n\nKindly go back to the login page to continue",
                            text: "Okay",
                            img: Image.asset("assets/tick_mark.png"),
                          );
                        });
                      }
                      else{
                        showDialog(context: context, builder: (context) {
                          return CustomDialogBox(title: "Hold up!",
                            descriptions: "The password you have entered in the two tabs do not match!\n\nKindly check if they are the exact same password",
                            text: "Okay",
                            img: Image.asset("assets/exclamation_mark.png"),
                          );
                        });
                      }
                      },
                  )
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Already have an account?', style: TextStyle(fontSize: 18),),
                  TextButton(
                    child: const Text(
                      'Log In',
                      style: TextStyle(fontSize: 20, color: Color(0xff3249ab), fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginPage()));
                    },
                  )
                ],

              ),

            ]
        ),

      ),

    );
  }
  void _togglepasswordView(){
    if(isHiddenPassword == true){
      isHiddenPassword = false;
    }else{
      isHiddenPassword = true;
    }
    setState(() {});
  }
  void _toggleconfirmpasswordView(){
    if(isHiddenConfirmPassword == true){
      isHiddenConfirmPassword = false;
    }else{
      isHiddenConfirmPassword = true;
    }
    setState(() {});
  }
}