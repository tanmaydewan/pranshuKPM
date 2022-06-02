import 'package:flutter/material.dart';
import 'package:kpmg_employees/welcome_page.dart';
import 'package:kpmg_employees/widget/app_icon_widget.dart';
import 'package:kpmg_employees/widget/device_utils.dart';
import 'package:kpmg_employees/widget/progress_indicator_widget.dart';
import 'package:kpmg_employees/widget/rounded_button_widget.dart';
import 'package:kpmg_employees/widget/textfield_widget.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}
var name;
class _LogInScreenState extends State<LogInScreen> {
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
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
      body: _buildBody(),
    );
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
          // Observer(
          //   builder: (context) {
          //     return _showError
          //         ? null
          //         : _showErrorMessage(
          //             'Unable to sign in. Please try again or contact the Admin',
          //             context);
          //   },
          // ),
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
            AppIconWidget(image: 'assets/KPMG_logo_2.png'),
            SizedBox(height: 64.0),
            _buildUserIdField(),
            _buildPasswordField(),
            SizedBox(height: 24.0),
            _buildSignInButton()
          ],
        ),
      ),
    );
  }

  Widget _buildUserIdField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: 'Enter email',
          inputType: TextInputType.emailAddress,
          icon: Icons.person,
          iconColor: Colors
              .black54, //_themeStore.darkMode ? Colors.white70 : Colors.black54,
          textController: _userEmailController,
          inputAction: TextInputAction.next,
          autoFocus: false,
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
          textController: _passwordController,
          errorText: null,
        );
      },
    );
  }

  Widget _buildSignInButton() {
    return RoundedButtonWidget(
      buttonText: 'Sign in',
      buttonColor: Colors.orangeAccent,
      textColor: Colors.white,
      onPressed: () {
        if (_canLogin()) {
          DeviceUtils.hideKeyboard(context);
          _signin(context);
        } else {
          _showErrorMessage('Please fill in all fields', context);
        }
      },
    );
  }

  bool _canLogin() {
    var email = _userEmailController.text.trim();
    var password = _passwordController.text.trim();
    if (email.length == 0 || password.length == 0) {
      return false;
    }
    return true;
  }

  void _signin(BuildContext context) async {
    setState(() {
      _isLoading = true;
      name=_userEmailController.text.trim();
    });
    final username = _userEmailController.text.trim();
    final password = _passwordController.text.trim();

    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('User'));
    parseQuery.whereEqualTo("objectId", username);
    print("objectid  = = ==   $parseQuery");
    final user = ParseUser(username, password, null);

    var response = await user.login();
    

    setState(() {
      _isLoading = false;
    });
    if (response.success) {
      Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (BuildContext context) => new WelcomePage()));
      // navigateToNextScreen(context);
    } else {
      _showErrorMessage("Login failed. Check your credentials", context);
    }
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

  Future<void> navigateToNextScreen(BuildContext context) async {
    bool a = await adminCheck();
    if (a == true) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => WelcomePage()));
    } else {
      Text("data");
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _userEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// ignore: camel_case_types
class Login_Successfull extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
    );
  }
}

Future<bool> adminCheck() async {
  ParseUser currentUser = await ParseUser.currentUser() as ParseUser;
  final a = currentUser["isAdmin"];
  return a;
}
