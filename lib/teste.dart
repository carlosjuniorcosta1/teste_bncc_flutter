import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Student> fetchStudent() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:5000/diario/aluno/239'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Student.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Student {
  final String name;

const Student({
  required this.name 
});

factory Student.fromJson(Map<String, dynamic>json) {
  return Student(
    name: json['nome'] as String
  );
}
}
void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  late Future<Student> futureStudent;

@override
void initState() {

    super.initState();
    futureStudent = fetchStudent();
  }

@override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fetch Student Api",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Show students"),          
        ),
        body: Center(
          child: FutureBuilder<Student>(
            future: futureStudent,
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.name);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } 
              return const CircularProgressIndicator();
            }
          ),
        ),

      ), 


    )
    );  
    
    
  
  }
}




