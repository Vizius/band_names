import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/band.dart';

class HomeScreen extends StatefulWidget {
   
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Band> bands=[
    Band(id: '1', name: 'Keller', votes: 0),
    Band(id: '2', name: 'Hazy', votes: 0),
    Band(id: '3', name: 'Kolsh', votes: 0),
    Band(id: '4', name: 'Summer', votes: 0),
  ];
 
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('BandNames'),
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder:(context, i) =>_bandTitle(bands[i])
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand
      ),
    );
  }

  Widget _bandTitle(Band banda) {
    return Dismissible(
      key: Key(banda.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        
        print('id: ' + banda.id);
      },
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Align(
          child: Text('Delete Band',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          alignment: Alignment.centerLeft,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(banda.name.substring(0,2), style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.cyan,
        ),
        title:Text(banda.name),
        trailing: Text('${banda.votes}',style: TextStyle(fontSize: 20),),
        onTap: () {
          print(banda.name);
        },
    
      ),
    );
  }

  addNewBand()
  {
    final textControler = TextEditingController();

    if(Platform.isAndroid){

      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            title: Text('New Band Name:'),
            content: TextField(
              controller: textControler
            ),
            actions: [
              MaterialButton(onPressed: () {
              addBandToList(textControler.text);
                
              },
              child: Text('Add'),
              elevation: 5,
              textColor: Colors.cyan,
              )
            ],
          );
        } ,
      );
    }else
    {
      showCupertinoDialog(
      context: context, 
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('New Band Name'),
          content: CupertinoTextField(
            controller: textControler,
          ),
          actions: [
            CupertinoDialogAction(
              child: Text('Add'),
              isDefaultAction: true,
              onPressed: () =>  addBandToList(textControler.text), 
            ),
            CupertinoDialogAction(
              child: Text('Dismiss'),
              isDestructiveAction: true,
              onPressed: () =>  Navigator.pop(context), 
            ),
          ],
        );
      },
    );
    }

    



  }

  void addBandToList (String name)
  {
    if(name.length > 1)
    {
      this.bands.add(new Band(
        id: DateTime.now().toString(),
        name: name, 
        votes: 0));
      setState(() {
        
      });
    }
    print(name);
    Navigator.pop(context);
  }

}