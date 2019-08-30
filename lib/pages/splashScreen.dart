import 'dart:convert';
import 'package:flutter/material.dart' as prefix0;
import 'package:path/path.dart' as Path;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import '../models/userModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Global.dart';
import 'database_helper.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final dbHelper = DatabaseHelper.instance;

  var database;
  SharedPreferences preferences ;
  bool FirstTime;
  List<Data> MyUsers = List();

  var connectivityResult;

  CheckNetwork() async{

    preferences = await SharedPreferences.getInstance();
    FirstTime = preferences.getBool("firstTime")??true;


    if(FirstTime==true)
      {

        print('First time ');

        connectivityResult = await (Connectivity().checkConnectivity());
        setState(() {

        });
        if (connectivityResult != ConnectivityResult.none) {


          bool check = preferences.getBool('first_time')??true;
          List<Data> allRows= (await dbHelper.queryAllRows() as List).map((data)=>Data.fromJson(data)).toList();

          if(check==true && allRows.length==0) {
            Fluttertoast.showToast(msg: "Fetching Data From Internet");
            http.get("https://reqres.in/api/users?page=1").then((
                response) async {
              print(response.body);
              var ParsedJson = jsonDecode(response.body);
              MyUsers = (ParsedJson['data'] as List).map((data) =>
                  Data.fromJson(data)).toList();
              GlobalData.MyUsers = MyUsers;
              print(GlobalData.MyUsers.length);
              Fluttertoast.showToast(msg: "Inserting Data into Database...");
              for (var item in GlobalData.MyUsers) {
                print("inserting the records");
                print(item.toMap());
                dbHelper.insert(await item.toMap());
              }

              List<Data> allRows= (await dbHelper.queryAllRows() as List).map((data)=>Data.fromJson(data)).toList();
              if(allRows.length>0)
                {
                  preferences.setBool('first_time', false);
                  Navigator.of(context).pushReplacementNamed('home');
                }


            });
          }else
            {
              Fluttertoast.showToast(msg: "Fetching Data From Database");
              GlobalData.MyUsers=(await dbHelper.queryAllRows() as List).map((data)=>Data.fromJson(data)).toList();
              Navigator.of(context).pushReplacementNamed('home');
            }




        }


      }
    else
      {



      }


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheckNetwork();


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Center(
          child: connectivityResult==ConnectivityResult.none?Text("No Internet Connection,\n\nPlease Connect to Internet and Restart the App\n\nInternet is Required for Image to Load from Network as well to Upload the New Profile Picture of User\n\nTo Test the App without internet Connection\nTurn of the Internet After Splash Screen and Perform the \nAdd / Update / Delete \n Operations and Restart the App. ",textAlign: TextAlign.center,):Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              prefix0.GestureDetector(
                  onTap: () async{
                    print("button Clicked");
                  //  List<Data> allRows = await dbHelper.queryAllRows() as List<Data>;
                    List<Data> allRows= (await dbHelper.queryAllRows() as List).map((data)=>Data.fromJson(data)).toList();
                    print('query all rows:');
                    allRows.forEach((row) => print(row.toJson()));
                    final eallRows = await dbHelper.queryAllRows();
                    eallRows.forEach((row) => print(row));
                  },child: prefix0.Image.asset('assets/images/logo.jpeg',height: 100,width: 100,)),
            ],
          ),
        ),
      ),
    );
  }





}
