import 'package:bus/bus_driver/home_page.dart';
import 'package:bus/student/home_page.dart';
import 'package:flutter/material.dart';

class ChoicePage extends StatefulWidget {
  const ChoicePage({super.key});

  @override
  State<ChoicePage> createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('College Bus'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => HomePageForStudent()));
              },
              child: ListTile(
                title: Text('Student'),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => BusDriverHomePage()));
              },
              child: ListTile(
        
                title: Text('Bus Driver'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
