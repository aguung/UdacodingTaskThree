import 'package:app_task/model/hospital.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_task/utils/extensions.dart';

class CreateHospitalView extends StatefulWidget {
  final bool isEdit;
  final Hospital hospital;

  CreateHospitalView({
    @required this.isEdit,
    this.hospital,
  });

  @override
  _CreateHospitalViewState createState() => _CreateHospitalViewState();
}

class _CreateHospitalViewState extends State<CreateHospitalView> {
  final formState = GlobalKey<FormState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerAddress = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  final TextEditingController controllerLat = TextEditingController();
  final TextEditingController controllerLang = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    if (widget.isEdit) {
      controllerName.text = widget.hospital.name;
      controllerDescription.text = widget.hospital.description;
      controllerAddress.text = widget.hospital.address;
      controllerLat.text = widget.hospital.latitude;
      controllerLang.text = widget.hospital.longitude;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.isEdit ? 'Update Hospital' : 'Create Hospital'),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              if (formState.currentState.validate()) {
                var name = controllerName.text.trim();
                var address = controllerAddress.text.trim();
                var description = controllerDescription.text.trim();
                var lat = controllerLat.text.trim();
                var long = controllerLang.text.trim();
                setState(() => isLoading = true);
                if (widget.isEdit) {
                  try {
                    DocumentReference documentTask =
                        firestore.doc('hospital/${widget.hospital.id}');
                    firestore.runTransaction((transaction) async {
                      DocumentSnapshot task =
                          await transaction.get(documentTask);
                      if (task.exists) {
                        transaction.update(
                            documentTask,
                            Hospital(
                                    name: name,
                                    address: address,
                                    description: description,
                                    latitude: lat,
                                    longitude: long,
                                    updateAt: DateTime.now())
                                .toJson());
                        Navigator.pop(context, 'Hospital has been udpated');
                      }
                    });
                  } on FirebaseException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.message),
                      ),
                    );
                  }
                } else {
                  try {
                    CollectionReference tasks =
                        firestore.collection('hospital');
                    DocumentReference result = await tasks.add(Hospital(
                            name: name,
                            address: address,
                            description: description,
                            latitude: lat,
                            longitude: long,
                            updateAt: DateTime.now())
                        .toJson());
                    if (result.id != null) {
                      Navigator.pop(context, 'Hospital has been created');
                    }
                  } on FirebaseException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.message),
                      ),
                    );
                  }
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
                            controller: controllerName,
                            decoration: InputDecoration(
                              hintText: 'Name',
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              return value.isEmpty ? 'Name is empty' : null;
                            },
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: controllerAddress,
                            decoration: InputDecoration(
                              hintText: 'Address',
                              labelText: 'Address',
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                value.isEmpty ? 'Address is empty' : null,
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: controllerDescription,
                            keyboardType: TextInputType.multiline,
                            minLines: 5,
                            maxLines: 8,
                            decoration: InputDecoration(
                              hintText: 'Description',
                              labelText: 'Description',
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                value.isEmpty ? 'Description is empty' : null,
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: controllerLat,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Latitude',
                              labelText: 'Latitude',
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (value) => value.isEmpty
                                ? 'Latitude is empty'
                                : !value.isNumericUsingRegularExpression()
                                    ? 'Wrong input'
                                    : null,
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: controllerLang,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Longitude',
                              labelText: 'Longitude',
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (value) => value.isEmpty
                                ? 'Longitude is empty'
                                : !value.isNumericUsingRegularExpression()
                                    ? 'Wrong input'
                                    : null,
                          ),
                          SizedBox(height: 8),
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
