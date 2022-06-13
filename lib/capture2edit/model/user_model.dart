class UserModel {
  UserModel(this.userName, this.email, this.phone, this.address, this.password);

  String? userName;
  String email = '';
  String phone = '';
  String address = '';
  String password = '';

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'userName': userName,
      'email': email,
      'phone': phone,
      'address': address,
      'password': password
    };
    return map;
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    userName = map['userName'];
    email = map['email'];
    phone = map['phone'];
    address = map['address'];
    password = map['password'];
  }
}
