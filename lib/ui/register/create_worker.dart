import 'package:ayolee_stores/model/create_user.dart';
import 'package:ayolee_stores/networking/rest_data.dart';
import 'package:ayolee_stores/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CreateWorker extends StatefulWidget {

  static const String id = 'create_worker_page';

  @override
  _CreateWorkerState createState() => _CreateWorkerState();
}

class _CreateWorkerState extends State<CreateWorker> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _pinController = new TextEditingController();
  TextEditingController _confirmPinController = new TextEditingController();
  bool showSpinner = false;

  String capitalize(String string) {
    String result = '';

    if (string == null) {
      throw ArgumentError("string: $string");
    }

    if (string.isEmpty) {
      return string;
    }

    else{
      List<String> values = string.split(' ');
      List<String> valuesToJoin = new List();

      if(values.length == 1){
        result = string[0].toUpperCase() + string.substring(1);
      }
      else{
        for(int i = 0; i < values.length; i++){
          if(values[i].isNotEmpty){
            valuesToJoin.add(values[i][0].toUpperCase() + values[i].substring(1));
          }
        }
        result = valuesToJoin.join(' ');
      }

    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Create Worker')),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: TextFormField(
                        decoration: kAddProductDecoration.copyWith(hintText: "Name"),
                        keyboardType: TextInputType.text,
                        controller: _nameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter a name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: TextFormField(
                        decoration: kAddProductDecoration.copyWith(hintText: "Phone Number"),
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter a phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: TextFormField(
                        decoration: kAddProductDecoration.copyWith(hintText: "Pin"),
                        keyboardType: TextInputType.number,
                        controller: _pinController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter a pin';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: TextFormField(
                        decoration: kAddProductDecoration.copyWith(hintText: "Confirm Pin"),
                        keyboardType: TextInputType.number,
                        controller: _confirmPinController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Confirm your pin';
                          }
                          else if(_pinController.text != _confirmPinController.text){
                            return 'Pin not equal';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    if(_formKey.currentState.validate()){
                      setState(() {
                        showSpinner = true;
                      });
                      createUser(_nameController.text, _phoneController.text, _pinController.text, _confirmPinController.text);
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }

  void createUser(String name, String phoneNumber, String pin, String confirmPin){
    var user = CreateUser();
    var api = new RestDataSource();
    try {
      user.name = capitalize(name);
      user.phoneNumber = phoneNumber;
      user.pin = pin;
      user.confirmPin = confirmPin;

      api.signUp(user).then((value) {
        _nameController.clear();
        _phoneController.clear();
        _pinController.clear();
        _confirmPinController.clear();

        setState(() {
          showSpinner = false;
        });

        Fluttertoast.showToast(
            msg: 'User successfully created',
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.white,
            textColor: Colors.black);

      }).catchError((Object error) {
        _phoneController.clear();
        _pinController.clear();
        _confirmPinController.clear();
        Fluttertoast.showToast(
            msg: error.toString(),
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.white,
            textColor: Colors.black);
      });

    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.white,
          textColor: Colors.black);
    }
  }

}
