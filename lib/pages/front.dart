import 'dart:io';

import 'package:band_names/pages/add_table.dart';
import 'package:band_names/pages/home.dart';
import 'package:band_names/widget/card_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/socket_service.dart';
import 'package:band_names/models/table.dart';


class FrontScreen extends StatefulWidget {
   
  const FrontScreen({Key? key}) : super(key: key);
  @override
  State<FrontScreen> createState() => _FrontScreenState();
}

class _FrontScreenState extends State<FrontScreen> {
  
  
  List<Tabe> tables=[];
  bool _visible =true;

  _handleActiveTables(dynamic payload)
  {
    this.tables = (payload as List).map((tabe) => Tabe.fromMap(tabe)).toList();
    if(mounted)
    {
      (context as Element).markNeedsBuild();
      setState(() {});
    }
  }
  

  Future<void> _addGroup()async
  {
    final result = await showDialog(
      context: context, 
      builder: (context) => AddTable(),);
    if (result != null)
    {
     
    }
  } 

  @override
  Widget build(BuildContext context) {
    final socketService2 = Provider.of<SocketService>(context);

    socketService2.socket.on('tables-active', _handleActiveTables);

    setState(() {});
    
    return  Scaffold(
      backgroundColor: Colors.grey[200],
      body:Column(
        children: [
          Stack( 
            children: [
              Container(
              height: MediaQuery.of(context).size.width * 0.65,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(
                  color: Colors.black26, 
                  offset: Offset(0.0,2.0),
                  blurRadius:6.0 )]
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image(image: AssetImage('assets/beerb.jpg'),fit: BoxFit.cover,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200, left: 20),
                child: Text('BUNEMANN\'S SPELUNKE \nINVENTARIO 2023 ',
                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: EdgeInsets.only(top: 220, left: 20),
                child: AnimatedOpacity(
                  opacity: _visible? 1.0 : 0.0,
                  duration: Duration(microseconds: 300),
                  child: MaterialButton(onPressed: _visible==true?() {
                    socketService2.emit('delete-table',{'tableName': 'general'});
                    setState(() {
                      _visible = !_visible ;
                    });
                  }:null,
                  child: Text('Mostrar Tablas', style: TextStyle(color: Colors.black),)
                  ,shape: StadiumBorder(),),
                ),
              ),
              SafeArea(
                child: Container(
                  margin: EdgeInsets.only(left: 15,top: 15),
                  child: 
                  socketService2.serverStatus == ServerStatus.Online 
                  ?
                  Icon(Icons.offline_bolt, color: Colors.green,size: 30,)
                  :Icon(Icons.offline_bolt, color: Colors.red,size: 30,)
                ),
              ),
              
            ],),
            Expanded(
              child: ListView.builder(
                itemCount: tables.length,
                itemBuilder:(context, index) => 
                GestureDetector(
                  onLongPress: () {
                    (context as Element).markNeedsBuild();
                    deleteTable(tables[index]);
                  },  
                  onTap:() {
                    (context as Element).markNeedsBuild();
                    Navigator.push(context,MaterialPageRoute(builder: (context) => 
                    HomeScreen(tables[index].tableName), ));
                  }, 
                  child: SingleCard(color: Colors.cyan, text: tables[index].tableName)),
                ),
            ),
        ],),
       floatingActionButton: _visible==false ? FloatingActionButton(
        onPressed: _addGroup,
        child: Icon(Icons.add, color: Colors.white,),
        ):null,
      ); 
  }

  deleteTable(Tabe tabe)
  {
    final socketService2 = Provider.of<SocketService>(context,listen: false);
    if(Platform.isAndroid){

      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            title: Text('¿Eliminar Tabla?'),
            actions: [
              MaterialButton(onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
              elevation: 5,
              textColor: Colors.red,
              ),
              MaterialButton(onPressed: () => Navigator.pop(context,socketService2.emit('delete-table',{'id': tabe.id})) ,
              child: Text('Eliminar'),
              elevation: 5,
              textColor: Colors.cyan,
              ),
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
          title: Text('¿Eliminar Tabla?'),
          actions: [
            CupertinoDialogAction(
              child: Text('Eliminar'),
              isDefaultAction: true,
              onPressed: () =>  Navigator.pop(context,socketService2.emit('delete-table',{'id': tabe.id})), 
            ),
            CupertinoDialogAction(
              child: Text('Cancelar'),
              isDestructiveAction: true,
              onPressed: () =>  Navigator.pop(context), 
            ),
          ],
        );
      },
    );
    }
  }
}




