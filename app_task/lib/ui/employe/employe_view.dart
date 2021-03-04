import 'package:app_task/helper/database_helper.dart';
import 'package:app_task/model/employe.dart';
import 'package:app_task/ui/create_employe/create_employe_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmployeView extends StatefulWidget {
  @override
  _EmployeViewState createState() => _EmployeViewState();
}

class _EmployeViewState extends State<EmployeView> {
  List<Employe> items = [];
  DatabaseHelper db = new DatabaseHelper();

  @override
  void initState() {
    super.initState();
    db.getAllPegawai().then((employes) {
      setState(() {
        employes.forEach((employe) {
          items.add(Employe.fromMap(employe));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Clerk"),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              String result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateEmployeView(isEdit: false,)));
              if (result != null && result.isNotEmpty) {
                items.clear();
                db.getAllPegawai().then((employes) {
                  setState(() {
                    employes.forEach((employe) {
                      items.add(Employe.fromMap(employe));
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(result),
                    ));
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  });
                });
              }
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.only(left: 16),
              title: Text(
                '${items[index].firstName} ${items[index].lastName}',
                style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.deepOrangeAccent),
              ),
              subtitle: Text(
                '${items[index].emailId}',
              ),
              trailing: PopupMenuButton(
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
                        return CreateEmployeView(
                          isEdit: true,
                          employe: items[index],
                        );
                      }),
                    );
                    if (result != null && result.isNotEmpty) {
                      items.clear();
                      db.getAllPegawai().then((employes) {
                        setState(() {
                          employes.forEach((employe) {
                            items.add(Employe.fromMap(employe));
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(result),
                          ));
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        });
                      });
                    }
                  } else if (value == 'delete') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Are You Sure'),
                          content: Text(
                              'Do you want to delete ${items[index].firstName} ${items[index].lastName}?'),
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
                                _deletePegawai(context, items[index], index);
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
            );
          }),
    );
  }

  _deletePegawai(BuildContext context, Employe employe, int position) {
    db.deletePegawai(employe.id).then((employes) {
      setState(() {
        items.removeAt(position);
      });
    });
  }
}
