import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_de_tarefas/models/todo.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // Importar o pacote do Slidable

class TodoListItens extends StatelessWidget {
  const TodoListItens({Key? key, required this.todo , required this.onDelete}) : super(key: key);

  final Todo todo;
  final Function(Todo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(todo.title), // Definindo uma chave única para o Slidable

      // Definição do ActionPane à esquerda, com a opção de excluir
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SizedBox(
            height: 80,
            width: 100,
            child: SlidableAction(
              onPressed: (BuildContext context) {
                onDelete(todo);// ação de deletar uma tarefa 
              },
              backgroundColor:
                  const Color(0xFFFE4A49), // Cor de fundo vermelha para excluir
              foregroundColor: Colors.white, // Cor do ícone
              icon: Icons.delete, // Ícone de exclusão
              label: 'Excluir', // Rótulo
              borderRadius: (BorderRadius.only(
                topLeft:
                    Radius.circular(0), // Arredonda o canto superior esquerdo
                topRight:
                    Radius.circular(8), // Arredonda o canto superior direito
                bottomLeft: 
                    Radius.circular(0), // Não arredonda o canto inferior esquerdo
                bottomRight:
                    Radius.circular(8), // Arredonda o canto inferior direito
              )),
            ),
          )
        ],
      ),

      // O conteúdo do item da lista
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: const Color.fromARGB(255, 207, 205, 205),
        ),
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              DateFormat('dd/MM/yyyy - HH:mm').format(todo.dateTime),
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              todo.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
