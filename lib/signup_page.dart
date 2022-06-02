import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:kpmg_employees/login_page.dart';
import 'package:kpmg_employees/widget/device_utils.dart';
import 'package:kpmg_employees/widget/progress_indicator_widget.dart';
import 'package:kpmg_employees/widget/rounded_button_widget.dart';
import 'package:kpmg_employees/widget/textfield_widget.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class SignUp extends StatefulWidget {
  @override
  _EmployeRegistration createState() => _EmployeRegistration();
}

class _EmployeRegistration extends State<SignUp> {
  final controllerUsername = TextEditingController();

  final controllerPassword = TextEditingController();
  final controllerAdharNumber = TextEditingController();
  final controllerEmail = TextEditingController();
  String encodedImage = "";
  var _isLoading;

  

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      body: _buildFirstBody(),
    );
  }

  Widget _buildFirstBody() {
    return SingleChildScrollView(
        child: Row(children: <Widget>[
      Expanded(
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 28.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // SizedBox(height: 24.0),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () => _backPressed(),
                            icon: Image.asset(
                              "assets/back_icon.png",
                              height: 40,
                              width: 40,
                            )),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Register Employee",
                            textAlign: TextAlign.center,
                            textScaleFactor: 2.0,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))
                      ]),
                  _buildBody(),
                ],
              ))),
    ]));
  }

  Widget _buildBody() {
    return Material(
      child: Stack(
        children: <Widget>[
          MediaQuery.of(context).orientation == Orientation.landscape
              ? Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: _buildRightSide(),
                    ),
                  ],
                )
              : Center(child: _buildRightSide()),
          Visibility(
            visible: _isLoading,
            child: CustomProgressIndicatorWidget(),
          )
        ],
      ),
    );
  }

  Widget _buildRightSide() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // AppIconWidget(image: 'assets/ic_logo.png'),
            SizedBox(height: 50.0),
            _buildUserName(),
            _buildUserEmail(),
            _buildPasswordField(),

            SizedBox(height: 24.0),
            _buildSignInButton()
          ],
        ),
      ),
    );
  }

  Widget _buildAdhaarNumber() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: 'Enter Aadhar Number',
          inputType: TextInputType.emailAddress,
          padding: EdgeInsets.only(top: 16.0),
          icon: Icons.credit_card,
          iconColor: Colors.black54,
          textController: controllerAdharNumber,
          errorText: null,
        );
      },
    );
  }

   

  Widget _buildUserName() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: 'Enter Username',
          inputType: TextInputType.name,
          icon: Icons.person,
          iconColor: Colors
              .black54, //_themeStore.darkMode ? Colors.white70 : Colors.black54,
          textController: controllerUsername,
          inputAction: TextInputAction.next,
          autoFocus: false,
          errorText: null,
        );
      },
    );
  }

  Widget _buildUserEmail() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: 'Enter Email',
          inputType: TextInputType.emailAddress,
          padding: EdgeInsets.only(top: 16.0),
          icon: Icons.lock,
          iconColor: Colors.black54,
          textController: controllerEmail,
          errorText: null,
        );
      },
    );
  }

  Widget _buildPasswordField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: 'Enter password',
          isObscure: true,
          padding: EdgeInsets.only(top: 16.0),
          icon: Icons.lock,
          iconColor: Colors.black54,
          textController: controllerPassword,
          errorText: null,
        );
      },
    );
  }

  Widget _buildSignInButton() {
    return RoundedButtonWidget(
      buttonText: 'Sign Up',
      buttonColor: Colors.orangeAccent,
      textColor: Colors.white,
      onPressed: () {
        if (_canSignUp()) {
          DeviceUtils.hideKeyboard(context);
          doUserRegistration();
        } else {
          _showErrorMessage('Please fill in all fields', context);
        }
      },
    );
  }

  void showSuccess(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!"),
          content: Text(message),
          actions: <Widget>[
            new TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorMessage(String message, BuildContext context) {
    if (message.isNotEmpty) {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  bool _canSignUp() {
    var username = controllerUsername.text.trim();
    var email = controllerEmail.text.trim();
    var password = controllerPassword.text.trim();
    if (email.length == 0 ||
        password.length == 0 ||
        username.length == 0 ) {
      return false;
    }
    return true;
  }

  void doUserRegistration() async {
    final username = controllerUsername.text.trim();
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();
    

    var user = ParseUser.createUser(username, password, email);
    

    var response = await user.save();
    if (response.success) {
      // AlertDialog(
      //   title: const Text('Successfull'),
      //   content: Text("User created successfull"),
      //   actions: <Widget>[
      //     TextButton(
      //       child: const Text('Ok'),
      //       onPressed: () {
      //         _navigateToNextScreen(context);
      //       },
      //     ),
      //   ],
      // );
      _navigateToNextScreen(context);
      print("User created");
    } else {
      _showErrorMessage(response.error!.message, context);
    }
  }

  

  
  void _backPressed() {
    Navigator.of(context).pop();
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LogInScreen()));
  }
}
