import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:jarvis/Global.dart' as prefix0;
import 'package:sqflite/sqflite.dart';
import '../models/userModel.dart';
import '../Global.dart';
import 'package:path/path.dart';

import 'database_helper.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var database;
  int updateid;
  FocusNode NameFocus;
  final dbHelper = DatabaseHelper.instance;

  TextEditingController FirstNameController = new TextEditingController();
  TextEditingController LastNameController = new TextEditingController();
  TextEditingController EmailController = new TextEditingController();
  String ImageURL="";

  bool Edit = false;

  String image64 = "";
  File _image;

  Future getImage() async {
    var file = await ImagePicker.pickImage(source: ImageSource.gallery);
    _image = file;
    List<int> imagebytes = await file.readAsBytesSync();
    image64 = await base64.encode(imagebytes);

    http.post("http://saurabhenterprise.com/gg/upload.php",body: {
      "image":image64.toString()
    }).then((response){
      print(response.body);
      var ParsedJson = jsonDecode(response.body);

      ImageURL = ParsedJson['path'];

    });


    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Users"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: GlobalData.MyUsers.length,


          itemBuilder: (c, i) {
            return Dismissible(
              onDismissed: (direction) async {
                await dbHelper.delete(GlobalData.MyUsers[i].id);
                GlobalData.MyUsers.removeAt(i);
                setState(() {
                });
              },
              background: Container(
                color: Colors.red,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.delete, color: Colors.white,),
                  ),
                ),
              ),
              key: Key(GlobalData.MyUsers[i].id.toString()),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .15,
                        height: MediaQuery
                            .of(context)
                            .size
                            .width * .15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(100)),
                            image: DecorationImage(image: NetworkImage(
                                GlobalData.MyUsers[i].avatar),fit: BoxFit.cover)
                        ),
                      ),
                      SizedBox(width: 15,),
                      Expanded(child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(GlobalData.MyUsers[i].first_Name + " " +
                              GlobalData.MyUsers[i].last_Name),
                          SizedBox(height: 10,),
                          Text(GlobalData.MyUsers[i].email)
                        ],
                      )),
                      GestureDetector(
                        onTap: (){
                          updateid = GlobalData.MyUsers[i].id;
                          Edit=true;
                          FirstNameController.text=GlobalData.MyUsers[i].first_Name;
                          LastNameController.text=GlobalData.MyUsers[i].last_Name;
                          EmailController.text=GlobalData.MyUsers[i].email;
                          ImageURL=GlobalData.MyUsers[i].avatar;
                          _BottomSheet(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.edit),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              direction: DismissDirection.endToStart,
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Edit=false;
          FirstNameController.text="";
          LastNameController.text="";
          EmailController.text="";
          ImageURL="https://www.seekpng.com/png/full/428-4287240_no-avatar-user-circle-icon-png.png";
          _BottomSheet(context);
          FocusScope.of(context).requestFocus(NameFocus);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
        elevation: 2.0,
      ),

    );
  }


  void _BottomSheet(context) {



    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height*.75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                ),
                  child: Column(

                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[

                         Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                  color: Colors.amber,
                                ),

                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(Edit?"Edit User":"Add New User",style: TextStyle(fontSize: 20,color: Colors.white,),textAlign: TextAlign.center,),
                                ),
                              ),
                            ),
                          ],
                        ),

                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: getImage,
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * .20,
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .width * .20,
                                    child: Container(

                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(100)),
                                          image: DecorationImage(image:_image==null?NetworkImage(ImageURL??"https://s3.amazonaws.com/uifaces/faces/twitter/calebogden/128.jpg"): FileImage(_image),fit: BoxFit.cover)
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Expanded(child: TextField(
                                              controller: FirstNameController,
                                              focusNode: NameFocus,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                labelText: "First Name",

                                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                                              ),
                                            )),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          children: <Widget>[
                                            Expanded(child: TextField(
                                              controller: LastNameController,
                                              decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                  labelText: "Last Name",
                                                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                                              ),
                                            )),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: <Widget>[
                                Expanded(child: TextField(
                                  controller: EmailController,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                      labelText: "Email Address",
                                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                                  ),
                                )),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: <Widget>[
                                Expanded(child: RaisedButton(
                                  onPressed: () async {

                                    //

                                    if(FirstNameController.text.toString()==null || FirstNameController.text.toString()=="" )
                                      {
                                        Fluttertoast.showToast(msg: "First Name is Required",backgroundColor: Colors.red,gravity: ToastGravity.TOP);
                                      }else if(LastNameController.text.toString()==null || LastNameController.text.toString()=="" )
                                    {
                                      Fluttertoast.showToast(msg: "Last Name is Required",backgroundColor: Colors.red,gravity: ToastGravity.TOP);
                                    }else if(EmailController.text.toString()==null || EmailController.text.toString()=="" )
                                    {
                                      Fluttertoast.showToast(msg: "Email is Required",backgroundColor: Colors.red,gravity: ToastGravity.TOP);
                                    }else {
                                      bool emailValid = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(EmailController.text.toString());

                                      if(emailValid)
                                        {
                                          Edit?UpdateUserToDB(context):
                                          AddUserToDB(context);
                                        }else
                                          {
                                            Fluttertoast.showToast(msg: "Invalid Email Address",backgroundColor: Colors.red,gravity: ToastGravity.TOP);
                                          }

                                    }





                                  },child: Text(Edit?"Update":"Add",style: TextStyle(color: Colors.white),),color: Colors.amber[700],)),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
              ),
            ),
          );
        }
    );
  }

  AddUserToDB(context) async {
    await dbHelper.insert( Data(first_Name: FirstNameController.text.toString(),
        last_Name: LastNameController.text.toString(),
        avatar: ImageURL,
        email: EmailController.text.toString()).toMap());
    GlobalData.MyUsers=(await dbHelper.queryAllRows() as List).map((data)=>Data.fromJson(data)).toList();
    FirstNameController.text="";
    LastNameController.text="";
    EmailController.text="";
    ImageURL="https://www.seekpng.com/png/full/428-4287240_no-avatar-user-circle-icon-png.png";
    Navigator.of(context).pop();
    setState(() {

    });
  }

  UpdateUserToDB(context) async {
    await dbHelper.update(Data(first_Name: FirstNameController.text.toString(),
        last_Name: LastNameController.text.toString(),
        avatar: ImageURL,
        email: EmailController.text.toString()).toMap(),updateid);
    GlobalData.MyUsers=(await dbHelper.queryAllRows() as List).map((data)=>Data.fromJson(data)).toList();
    FirstNameController.text="";
    LastNameController.text="";
    EmailController.text="";
    ImageURL="https://www.seekpng.com/png/full/428-4287240_no-avatar-user-circle-icon-png.png";
    Navigator.of(context).pop();
    setState(() {

    });
  }



}