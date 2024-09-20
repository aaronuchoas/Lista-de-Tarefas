import 'package:flutter/material.dart';
import 'package:new_project/views/list_form_tasks.dart';
import 'package:new_project/views/list_view_tasks.dart';

void main() {
  runApp(const MyApp());
}


  


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your applica+tion.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: false,
      ),
      home: MyWidget(),
      routes: {
        '/listarTarefas': (context) => ListViewTasks(),
        '/criarTarefas': (context) => CreateTasks()
      },
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Minha Lista de Tarefas'),
        ),
        drawer: Drawer(
            child: Column(
          children: [
            UserAccountsDrawerHeader(
                accountName: Text('Aluno', style: TextStyle(fontSize: 24)),
                accountEmail: Text('aluno@teste.com'),
                currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white, child: Icon(Icons.person))),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Listagem de Tarefas'),
              onTap: () {
                Navigator.pushNamed(context, '/listarTarefas');
              },
            )
          ],
        )),
        body: Stack(
          children: [
            Padding(
                padding: EdgeInsets.only(right: 10, bottom: 30),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/criarTarefas');
                        },
                        child: Icon(Icons.add))))
          ],
        ));
  }
}



