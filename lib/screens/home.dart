import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:todo_app/constants/color.dart';
import 'package:todo_app/constants/tasktype.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/screens/add_new_task.dart';
import 'package:todo_app/service/todo_service.dart';
import 'package:todo_app/todoitem.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> todo = [
    Task(
        type: TaskType.note,
        title: "Study Lessons",
        description: "Study Comp117",
        isCompleted: false),
    Task(
        type: TaskType.contest,
        title: "Run 5K",
        description: "Run 5 kilometers",
        isCompleted: false),
    Task(
        type: TaskType.calendar,
        title: "Go To Party",
        description: "Attend to party",
        isCompleted: false),
  ];
  List<Task> completed = [
    Task(
        type: TaskType.note,
        title: "Study Lessons",
        description: "Study Comp117",
        isCompleted: false),
    Task(
        type: TaskType.contest,
        title: "Run 5K",
        description: "Run 5 kilometers",
        isCompleted: false),
  ];

  void addNewTask(Task newTask) {
    setState(() {
      todo.add(newTask);
    });
  }

  @override
  Widget build(BuildContext context) {
    TodoService todoService = TodoService();

    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: SafeArea(
      child: Scaffold(
        backgroundColor: HexColor(backgroundColor),
        body: Column(
          children: [
            // Header
            Container(
              width: deviceWidth,
              height: deviceHeight / 3,
              decoration: const BoxDecoration(
                  color: Colors.purple,
                  image: DecorationImage(
                      image: AssetImage("lib/assets/images/header.png"),
                      fit: BoxFit.cover)),
              child: const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "October 20, 2024",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text(
                        "My Todo List App",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
            // Top Column
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: SingleChildScrollView(
                  child: FutureBuilder(
                    future: todoService.getUnCompletedTodos(),
                    builder: (context, snapshot) {
                      if (snapshot.data!.isEmpty) {
                        return const CircularProgressIndicator();
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return TodoItem(task: snapshot.data![index]);
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            // Completed Text
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Completed",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
            ),
            // Bottom Column

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: SingleChildScrollView(
                  // FutureBuilder
                    child: FutureBuilder(
                      future: todoService.getCompletedTodos(),
                      builder: (context, snapshot) {
                        if (snapshot.data!.isEmpty) {
                          return const CircularProgressIndicator();
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return TodoItem(task: snapshot.data![index]);
                            },
                          );
                        }
                      },
                    ),),
              ),
            ),


            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddNewTaskScreen(
                    addNewTask: (newTask) => addNewTask(newTask),
                  ),
                ));
              },
              child: const Text("Add New Task"),
            )
          ],
        ),
      ),
    ));
  }
}
