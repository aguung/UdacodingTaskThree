import 'package:app_task/helper/database_helper.dart';
import 'package:app_task/model/employe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_task/utils/extensions.dart';

class CreateEmployeView extends StatefulWidget {
  final bool isEdit;
  final Employe employe;

  CreateEmployeView({@required this.isEdit, this.employe});

  @override
  _CreateEmployeState createState() => _CreateEmployeState();
}

class _CreateEmployeState extends State<CreateEmployeView> {
  DatabaseHelper db = new DatabaseHelper();
  final formState = GlobalKey<FormState>();
  final TextEditingController controllerFirstName = TextEditingController();
  final TextEditingController controllerLastName = TextEditingController();
  final TextEditingController controllerMobileNo = TextEditingController();
  final TextEditingController controllerEmailId = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    if (widget.isEdit) {
      controllerFirstName.text = widget.employe.firstName;
      controllerLastName.text = widget.employe.lastName;
      controllerEmailId.text = widget.employe.emailId;
      controllerMobileNo.text = widget.employe.mobileNo;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Update Employe' : 'Create Employe'),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              if (formState.currentState.validate()) {
                var firstName = controllerFirstName.text.trim();
                var lastName = controllerLastName.text.trim();
                var mobileNo = controllerMobileNo.text.trim();
                var emailId = controllerEmailId.text.trim();
                setState(() => isLoading = true);
                if (widget.isEdit) {
                  db
                      .updatePegawai(Employe.fromMap({
                    'id': widget.employe.id,
                    'firstName': firstName,
                    'lastName': lastName,
                    'mobileNo': mobileNo,
                    'emailId': emailId
                  }))
                      .then((_) {
                    Navigator.pop(context, 'Employe has been udpated');
                  });
                } else {
                  db
                      .savePegawai(
                          Employe(firstName, lastName, mobileNo, emailId))
                      .then((_) {
                    Navigator.pop(context, 'Employe has been created');
                  });
                }
              }
            },
            icon: Icon(Icons.done),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Form(
                    key: formState,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: controllerFirstName,
                            decoration: InputDecoration(
                              hintText: 'First Name',
                              labelText: 'First Name',
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              return value.isEmpty
                                  ? 'First Name is empty'
                                  : null;
                            },
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: controllerLastName,
                            decoration: InputDecoration(
                              hintText: 'Last Name',
                              labelText: 'Last Name',
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                value.isEmpty ? 'Last Name is empty' : null,
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: controllerEmailId,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (value) => value.isEmpty
                                ? 'Email is empty'
                                : !value.isValidEmail()
                                    ? 'Check your format email'
                                    : null,
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: controllerMobileNo,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Mobile Number',
                              labelText: 'Mobile Number',
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (value) => value.isEmpty
                                ? 'Mobile Number is empty'
                                : !value.isNumericUsingRegularExpression()
                                    ? 'Wrong input'
                                    : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
