import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class Testing extends StatefulWidget {
  @override
  _TestingState createState() => _TestingState();
}

class _TestingState extends State<Testing> {

  String ReadData;


  myfun() async {

    Database   database =await openDatabase(
      // Set the path to the database.
      join(await getDatabasesPath(), 'doggie_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );

     return database;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () async {
                await insertDog(fido);
              },
            ),
            RaisedButton(
              onPressed: () async {
                print(jsonEncode(await dogs()));
              },
            ),
          ],
        ),
      ),
    );
  }


  Future<List<Dog>> dogs() async {
    // Get a reference to the database.
    final Database db = await myfun();

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('dogs');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
  }


  Future<void> insertDog(Dog dog) async {
    // Get a reference to the database.
    final Database db = await myfun();

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Create a Dog and add it to the dogs table.
  final fido = Dog(
    id: 0,
    name: 'Fido',
    age: 35,
  );



}

class Dog {
  final int id;
  final String name;
  final int age;

  Dog({this.id, this.name, this.age});

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'email': age,
        'id':id
      };

}
