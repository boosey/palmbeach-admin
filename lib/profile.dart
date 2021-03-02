import 'package:admin/model/userModel.dart';
import 'package:admin/adminOnly.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'appScaffold.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  final _formKey = GlobalKey<FormState>();
  UserModel userModel;

  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
  }

  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Profile',
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: 400,
              height: 300,
              child: Form(
                key: _formKey,
                child: Consumer<UserModel>(
                  builder: (context, uModel, child) {
                    userModel = uModel;
                    _firstNameController.text = userModel.profile.firstName;
                    _lastNameController.text = userModel.profile.lastName;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'First Name',
                          ),
                        ),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Last Name',
                          ),
                        ),
                        AdminOnly(
                          child: Row(
                            children: [
                              Text('Administrator'),
                              Switch(
                                value: userModel.isAdmin,
                                onChanged: adminSwitchChanged,
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: saveProfile,
                          child: Text('Update Profile'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveProfile() {
    if (_formKey.currentState.validate()) {
      UserProfile p = userModel.profile;
      p.firstName = _firstNameController.text;
      p.lastName = _lastNameController.text;
      userModel.save();

      Navigator.pop(context);
    }
  }

  void adminSwitchChanged(bool value) {
    // setState(() {
    //   userModel.isAdmin = value;
    // });

    print('new value: ' + userModel.isAdmin.toString());
  }
}
