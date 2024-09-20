import 'dart:convert';
import 'package:new_project/models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskService {
  // SALVAR TAREFAS
  Future<void> saveTask(String title, String description, String priority) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];
    Task task = Task(title: title, description: description, priority: priority); // Incluindo a prioridade
    tasks.add(jsonEncode(task.toJson()));
    await prefs.setStringList('tasks', tasks);
    print('Tarefa adicionada');
  }

  Future<List<Task>> getTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasksString = prefs.getStringList('tasks') ?? [];
    return tasksString
        .map((taskJson) => Task.fromJson(jsonDecode(taskJson)))
        .toList();
  }

  Future<void> deleteTask(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];
    tasks.removeAt(index);
    await prefs.setStringList('tasks', tasks);
  }

  Future<void> editTask(int index, String title, String description, String priority) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];
    Task existingTask = Task.fromJson(jsonDecode(tasks[index]));
    Task updatedTask = Task(
      title: title,
      description: description,
      isCompleted: existingTask.isCompleted, // Preservar o estado de isCompleted
      priority: priority, // Adiciona a prioridade
    );
    tasks[index] = jsonEncode(updatedTask.toJson());
    await prefs.setStringList('tasks', tasks);
  }

  Future<void> editTaskByCheckBox(int index, bool isCompleted) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];
    Task existingTask = Task.fromJson(jsonDecode(tasks[index]));
    existingTask.isCompleted = isCompleted;

    tasks[index] = jsonEncode(existingTask.toJson());
    await prefs.setStringList('tasks', tasks);
    print('Estado de isCompleted atualizado');
  }

  // Métodos para salvar e carregar prioridade
  Future<void> saveTaskPriority(String priority) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('taskPriority', priority);
  }

  Future<String> loadTaskPriority() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('taskPriority') ?? 'Baixa';
  }
}
