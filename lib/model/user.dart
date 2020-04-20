
class User {
  int _id;
  String _name;
  String _phoneNumber;
  String _type;
  String _created_at;
  String _token;

  User(this._id ,this._name, this._phoneNumber, this._type, this._created_at, this._token);

  User.map(dynamic obj) {
    this._id = obj["id"];
    this._name = obj["name"];
    this._phoneNumber = obj["email"];
    this._type = obj["type"];
    this._created_at = obj["created_at"];
    this._token = obj["token"];
  }

  int get id => _id;
  String get name => _name;
  String get phoneNumber => _phoneNumber;
  String get type => _type;
  String get created => _created_at;
  String get token => _token;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["name"] = _name;
    map["email"] = _phoneNumber;
    map["type"] = _type;
    map["created_at"] = _created_at;
    map["token"] = _token;

    return map;
  }
}