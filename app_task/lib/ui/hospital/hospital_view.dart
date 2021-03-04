import 'package:app_task/model/hospital.dart';
import 'package:app_task/ui/create_hospital/create_hospital_view.dart';
import 'package:app_task/ui/detail_hospital/detail_hospital_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HospitalView extends StatefulWidget {
  @override
  _HospitalViewState createState() => _HospitalViewState();
}

class _HospitalViewState extends State<HospitalView> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hospital"),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              String result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateHospitalView(
                            isEdit: false,
                          )));
              if (result != null && result.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(result),
                ));
                setState(() {});
              }
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('hospital')
                    .orderBy('updateAt')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return snapshot.data.docs.isEmpty
                      ? Center(child: Text('Empty Hospital'))
                      : ListView.builder(
                          padding: EdgeInsets.all(8.0),
                          itemCount: snapshot.data.size,
                          itemBuilder: (BuildContext context, int index) {
                            DocumentSnapshot document =
                                snapshot.data.docs[index];
                            Hospital hospital =
                                Hospital.fromMap(document, document.id);
                            return Card(
                              child: ListTile(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return DetailHospitalView(
                                      hospital: hospital,
                                    );
                                  }),
                                ),
                                title: Text(hospital.name),
                                subtitle: Text(
                                  hospital.address,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                isThreeLine: false,
                                trailing: PopupMenuButton(
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Text('Edit'),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Text('Delete'),
                                    )
                                  ],
                                  onSelected: (String value) async {
                                    if (value == 'edit') {
                                      String result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return CreateHospitalView(
                                            isEdit: true,
                                            hospital: hospital,
                                          );
                                        }),
                                      );
                                      if (result != null && result.isNotEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(result),
                                        ));
                                        setState(() {});
                                      }
                                    } else if (value == 'delete') {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Are You Sure'),
                                            content: Text(
                                                'Do you want to delete ${hospital.name}?'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('No'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              TextButton(
                                                child: Text('Delete'),
                                                onPressed: () {
                                                  document.reference.delete();
                                                  Navigator.pop(context);
                                                  setState(() {});
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  child: Icon(Icons.more_vert),
                                ),
                              ),
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
