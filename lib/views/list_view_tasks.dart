import 'package:flutter/material.dart';
import 'package:new_project/models/task_model.dart';
import 'package:new_project/services/task_service.dart';
import 'package:new_project/views/list_form_tasks.dart';

class ListViewTasks extends StatefulWidget {
  const ListViewTasks({super.key});

  @override
  State<ListViewTasks> createState() => _ListViewTasksState();
}

class _ListViewTasksState extends State<ListViewTasks> {
  TaskService taskService = TaskService();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    getAllTasks();
  }

  Future<void> getAllTasks() async {
    tasks = await taskService.getTasks();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
      ),
      body: tasks.isEmpty
          ? Center(child: Text('Nenhuma tarefa disponível.'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return _buildTaskCard(tasks[index], index); // Chama o método atualizado
              },
            ),
    );
  }

  Widget _buildTaskCard(Task task, int index) {
    Color priorityColor;

    // Define a cor da prioridade com base no valor
    switch (task.priority) {
      case 'gitBaixa':
        priorityColor = Colors.green; // Verde
        break;
      case 'Média':
        priorityColor = Colors.amber; // Amarelo
        break;
      case 'Alta':
        priorityColor = Colors.red; // Vermelho
        break;
      default:
        priorityColor = Colors.black; // Cor padrão
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    task.title!,
                    style: TextStyle(
                      fontSize: 22,
                      color: task.isCompleted ? Colors.grey : Colors.blue,
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        task.isCompleted = value; // Atualiza isCompleted
                      });
                      taskService.editTaskByCheckBox(index, value); // Edita no serviço
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 4), // Um pequeno espaço entre o título e a prioridade
            Text(
              task.priority ?? 'Sem prioridade', // Mostra a prioridade ou 'Sem prioridade'
              style: TextStyle(fontSize: 16, color: priorityColor),
            ),
            SizedBox(height: 8),
            Text(
              task.description!,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () async {
                    await taskService.deleteTask(index);
                    getAllTasks();
                  },
                  icon: Icon(Icons.delete, color: task.isCompleted ? Colors.grey : Colors.red), // Altera a cor para cinza se a tarefa estiver finalizada
                ),
                // Ícone de editar escondido se a tarefa estiver finalizada
                if (!task.isCompleted)
                  IconButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateTasks(
                            task: task,
                            index: index,
                          ),
                        ),
                      ).then((value) => getAllTasks());
                    },
                    icon: const Icon(Icons.edit, color: Colors.blue),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
