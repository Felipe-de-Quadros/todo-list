import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/models/todo.dart';
import 'package:lista_de_tarefas/repositories/todo_repository.dart';
import 'package:lista_de_tarefas/widgets/todo_list_itens.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage ({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todocontroller = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];

  Todo? deletedTodo;
  int? deletedTodoPos;

  String? errorText;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value){
        setState(() {
          todos = value;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                       controller: todocontroller,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adicione uma tarefa',
                          hintText: 'Ex: estudar dart',
                          errorText: errorText,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            )
                          ),
                          labelStyle: TextStyle(
                            color: Colors.blue,
                          )
                          ),     
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    width: 100,
                    height: 50,
                      child: ElevatedButton(
                      onPressed: () {
                        String text = todocontroller.text;

                        if(text.isEmpty){
                          setState(() {
                            errorText = 'O título não pode ser vazio';
                          });
                          return;
                        }
                        setState(() {
                          Todo newTodo = Todo(
                          title: text,
                           dateTime: DateTime.now(),
                          );
                          todos.add(newTodo);
                          errorText = null;
                        });
                        todocontroller.clear();
                        todoRepository.saveTodoList(todos);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,  // Cor de fundo
                        foregroundColor: Colors.white, // Cor do texto
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 30,),
                    ),
                  )
                ],
              ),
            SizedBox(height: 20),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for(Todo todo in todos)
                  TodoListItens(
                    todo: todo,
                    onDelete: onDelete,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
              Row(
                children: [
                  Expanded(
                  child: Text("Você possui ${todos.length} tarefas pendentes")),
                  SizedBox(
                    width: 16,
                  ),
                  SizedBox(
                    width: 100,
                    height: 50,
                      child: ElevatedButton(
                        onPressed: (
                        showDeleteTodosConfirmationDialog
                        ),
                        style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,  // Cor de fundo
                        foregroundColor: Colors.white, // Cor do texto
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                        ),
                        ),
                        child: Text("Limpar tudo"),
                      ),
                  )
                ],
              )
            ],
          ),
        )),
      ),
    );
  }

  void onDelete (Todo todo){
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Tarefa ${todo.title} excluída!"),
                  action: SnackBarAction(
                    label: 
                      'Desfazer',
                    onPressed: (){
                      setState(() {
                        todos.insert(deletedTodoPos!, deletedTodo!);
                      });
                      todoRepository.saveTodoList(todos);
                  }),
                  duration: Duration(seconds: 5),
                ));
    }
  
  void showDeleteTodosConfirmationDialog(){
    showDialog(context: context, builder:(context)=>AlertDialog(
      title: Text("Limpar tudo?"),
      content: Text("Você tem certeza que deseja apagar todas as tarefas?"),
      actions: 
      [TextButton(onPressed: (){
        Navigator.of(context).pop();
      },
      style: TextButton.styleFrom(foregroundColor: Colors.blue), 
      child:Text("Cancelar")),

      TextButton(onPressed: (){
        Navigator.of(context).pop();
        deletedeAllTodos();
      },
      style: TextButton.styleFrom(foregroundColor: Colors.red),
       child: Text("Limpar tudo"))],
    ),
    );
  }

  void deletedeAllTodos(){
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}
