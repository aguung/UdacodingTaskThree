class Employe {
  int _id;
  String _firstName;
  String _lastName;
  String _mobileNo;
  String _emailId;

  Employe(this._firstName, this._lastName, this._mobileNo, this._emailId);

  Employe.map(dynamic obj) {
    this._id = obj['id'];
    this._firstName = obj['firstName'];
    this._lastName = obj['lastName'];
    this._mobileNo = obj['mobileNo'];
    this._emailId = obj['emailId'];
  }

  int get id => _id;

  String get firstName => _firstName;

  String get lastName => _lastName;

  String get mobileNo => _mobileNo;

  String get emailId => _emailId;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['mobileNo'] = _mobileNo;
    map['emailId'] = _emailId;
    return map;
  }

  Employe.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._firstName = map['firstName'];
    this._lastName = map['lastName'];
    this._mobileNo = map['mobileNo'];
    this._emailId = map['emailId'];
  }
}
