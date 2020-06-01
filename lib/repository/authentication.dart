import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthRepository {
  Future signInWithCredential(String nomorinduk, String password) async {
    var response = await http.get('url');
    return json.decode(response.body);
  }
}
