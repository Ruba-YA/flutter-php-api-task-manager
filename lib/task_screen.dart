import 'package:flutter/material.dart';
import 'api_service.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  ApiService apiService = ApiService();
  List tasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();  // Load tasks on app startup
  }

  void fetchTasks() async {
    tasks = await apiService.getTasks();  // Fetch tasks from API
    setState(() {});
  }

  void createTask(String title, String description) async {
    await apiService.createTask(title, description);  // Call API to create task
    fetchTasks();  // Refresh task list
  }

  void updateTask(int id, String title, String description, String status) async {
    await apiService.updateTask(id, title, description, status);  // Call API to update task
    fetchTasks();  // Refresh task list
  }

  void deleteTask(int id) async {
    await apiService.deleteTask(id);  // Call API to delete task
    fetchTasks();  // Refresh task list
  }

  void toggleTaskStatus(int id, String currentStatus, String title, String description) {
    // Determine new status
    String newStatus = currentStatus == 'pending' ? 'completed' : 'pending';
    updateTask(id, title, description, newStatus);  // Update task status
  }

  void showTaskDialog({int? taskId, String? title, String? description, String? status}) {
    TextEditingController titleController = TextEditingController(text: title);
    TextEditingController descriptionController = TextEditingController(text: description);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(taskId == null ? 'Add Task' : 'Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: UnderlineInputBorder(),
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: UnderlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                String newTitle = titleController.text;
                String newDescription = descriptionController.text;

                if (taskId == null) {
                  createTask(newTitle, newDescription);
                } else {
                  updateTask(taskId, newTitle, newDescription, status ?? 'pending');
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Task Manager",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Remove shadow for clean look
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                toggleTaskStatus(tasks[index]['id'], tasks[index]['status'],
                    tasks[index]['title'], tasks[index]['description']);
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tasks[index]['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      tasks[index]['description'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: tasks[index]['status'] == 'completed',
                              onChanged: (value) {
                                toggleTaskStatus(
                                  tasks[index]['id'],
                                  tasks[index]['status'],
                                  tasks[index]['title'],
                                  tasks[index]['description'],
                                );
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              activeColor: Colors.teal,
                            ),
                            Text(
                              tasks[index]['status'] == 'completed'
                                  ? 'Completed'
                                  : 'Pending',
                              style: TextStyle(
                                color: tasks[index]['status'] == 'completed'
                                    ? Colors.green
                                    : Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.grey[700]),
                              onPressed: () {
                                showTaskDialog(
                                  taskId: tasks[index]['id'],
                                  title: tasks[index]['title'],
                                  description: tasks[index]['description'],
                                  status: tasks[index]['status'],
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red[400]),
                              onPressed: () => deleteTask(tasks[index]['id']),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTaskDialog();  // Show form to add new task
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.grey[100], // Light background for a clean look
    );
  }
}
