import 'package:flutter/material.dart';
import 'package:new_project/models/task_model.dart';
import 'package:new_project/services/task_service.dart';

class CreateTasks extends StatefulWidget {
  final Task? task;
  final int? index;
  const CreateTasks({super.key, this.task, this.index});

  @override
  State<CreateTasks> createState() => _CreateTasksState();
}

class _CreateTasksState extends State<CreateTasks> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TaskService taskService = TaskService();
  String _selectedPriority = 'Baixa';

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title!;
      _descriptionController.text = widget.task!.description!;
      _selectedPriority = widget.task!.priority ?? 'Baixa'; // Carregar prioridade
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Criar nova tarefa' : 'Editar tarefa'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_titleController, 'Título', '* Título não preenchido!'),
              _buildTextField(_descriptionController, 'Descrição', '* Descrição não preenchida!', maxLines: 4),
              _buildPrioritySelection(),
              ElevatedButton(
                onPressed: _onSubmit,
                child: Text(widget.task == null ? 'Adicionar Tarefa' : 'Alterar Tarefa'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildTextField(TextEditingController controller, String label, String validationMessage, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) => value!.isEmpty ? validationMessage : null,
        decoration: InputDecoration(
          label: Text(label),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Padding _buildPrioritySelection() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Prioridade:', style: TextStyle(fontSize: 16)),
          ...['Baixa', 'Média', 'Alta'].map((priority) {
            return RadioListTile<String>(
              title: Text(priority),
              value: priority,
              groupValue: _selectedPriority,
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value!;
                });
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      String titleNewTask = _titleController.text;
      String descriptionNewTask = _descriptionController.text;

      if (widget.task != null && widget.index != null) {
        // Atualiza tarefa existente
        await taskService.editTask(widget.index!, titleNewTask, descriptionNewTask, _selectedPriority);
      } else {
        // Adiciona nova tarefa
        await taskService.saveTask(titleNewTask, descriptionNewTask, _selectedPriority);
      }

      Navigator.pop(context);
    }
  }
}
