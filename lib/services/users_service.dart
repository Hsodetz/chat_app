
import 'package:chat/global/environment.dart';
import 'package:chat/models/user.dart';
import 'package:chat/models/users_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UsersService {
  Future<List<User>> getUsers() async {
    // Fetch users from the server
    try {
      final resp = await http.get(Uri.parse('${ Environment.apiUrl }/users'),
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() ?? ''
        }
      );

      final usersResponse = usersResponseFromJson(resp.body);
      return usersResponse.users;
      
    } catch (e) {
      return [];
    }
  }
  
}