import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl = 'http://192.168.1.104/task_manager_api/api.php'; // Your server URL on mobile or emulator must provide an ip 

  // Fetch all tasks
  Future<List<dynamic>> getTasks() async {
    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  // Create a task
  Future<void> createTask(String title, String description) async {
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'description': description,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create task');
    }
  }

  // Update a task
  Future<void> updateTask(int id, String title, String description, String status) async {
    var response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'title': title,
        'description': description,
        'status': status,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }

  // Delete a task
// Delete a task
Future<void> deleteTask(int id) async {
  var response = await http.delete(
    Uri.parse('$apiUrl?id=$id'), // Passing the id in the URL query
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to delete task');
  }
}

}
