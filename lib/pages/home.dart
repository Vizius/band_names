import 'dart:io';
import 'dart:math';

import 'package:band_names/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:provider/provider.dart';

import '../models/band.dart';

class HomeScreen extends StatefulWidget {
   
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Band> bands=[];

  @override
  void initState() {

    final socketService2 = Provider.of<SocketService>(context, listen: false);

    socketService2.socket.on('bands-active', _handleActiveBands);

    super.initState();
    
  }

  _handleActiveBands(dynamic payload)
  {
    this.bands = (payload as List).map((band) => Band.fromMap(band)).toList();

    setState(() {});
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    final socketService2 = Provider.of<SocketService>(context, listen: false);

    socketService2.socket.off('bands-active');
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
     
    final socketService2 = Provider.of<SocketService>(context);

    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('BandNames'),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),

            child: 
            socketService2.serverStatus == ServerStatus.Online 
            ?
            Icon(Icons.offline_bolt, color: Colors.green,)
            :Icon(Icons.offline_bolt, color: Colors.red,)
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.grey[100],
              constraints: const BoxConstraints(
              maxHeight: 300,
              maxWidth: double.infinity,
              ),
              padding: const EdgeInsets.all(0.5),
              child: Stack(children: [
                _showGraph(),
                Container(
                  padding: EdgeInsets.only(top: 90),
                  width: double.infinity,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image(image: AssetImage('assets/beer2.jpeg')),
                  
                  ),
                )
              ], ),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
              itemCount: bands.length,
              itemBuilder:(context, i) =>_bandTitle(bands[i])
            )
            ),
          
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand
      ),
    );
  }

  Widget _bandTitle(Band banda) {

    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(banda.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) => socketService.emit('delete-band',{'id':banda.id} ),
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
        onTap: () => socketService.socket.emit('vote-band',{'id': banda.id }),
        
    
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
              MaterialButton(onPressed: () => addBandToList(textControler.text),
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
    final socketService = Provider.of<SocketService>(context, listen: false);

    if(name.length > 1)
    {
      socketService.socket.emit('add-band' ,{'name': name});
    }
    Navigator.pop(context);
  }

  Widget _showGraph()
  {
    return Chart(
      layers: layers(),);

    
  }
  List<ChartLayer> layers() {

  return [
    ChartGroupPieLayer(
      items: List.generate(
        1,
        (index) => List.generate(
          bands.length,
          (index) => ChartGroupPieDataItem(
              amount:bands[index].votes.toDouble(),
              color:  [
                  Colors.orangeAccent,
                  Colors.pinkAccent,
                  Colors.redAccent,
                  Colors.blueAccent,
                  Colors.cyanAccent,
                  Colors.tealAccent,
                ][Random().nextInt(6)],
              
              label: bands[index].name.toString()
              ),
        ),
      ),
      settings: ChartGroupPieSettings(),
    ),
    ChartTooltipLayer(
      shape: () => ChartTooltipPieShape<ChartGroupPieDataItem>(
        onTextName: (item) => item.label,
        onTextValue: (item) => 'Litros: ${item.amount.toString()}',
        radius: 10.0,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(12.0),
        nameTextStyle: const TextStyle(
          color: Color(0xFF8043F9),
          fontWeight: FontWeight.w700,
          height: 1.47,
          fontSize: 12.0,
        ),
        valueTextStyle: const TextStyle(
          color: Color(0xFF1B0E41),
          fontWeight: FontWeight.w700,
          fontSize: 12.0,
        ),
      ),
    )
  ];
  }
}