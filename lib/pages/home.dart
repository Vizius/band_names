import 'dart:io';
import 'dart:math';

import 'package:band_names/services/invoice_service.dart';
import 'package:band_names/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:provider/provider.dart';
import '../models/band.dart';

class HomeScreen extends StatefulWidget {

  
  final String table;
  HomeScreen(this.table, {Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int number = 0;
  List<Band> bands=[];
  bool _visible = true;

  _handleActiveBands(dynamic payload)
  {
    this.bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    if(mounted)
    {
      (context as Element).markNeedsBuild();
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {

    final socketService2 = Provider.of<SocketService>(context);

    socketService2.socket.on('bands-active', _handleActiveBands);
    setState(() {
      
    });
    return  StatefulBuilder(
      
      builder: (context, refresh) {
        return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBar(
            centerTitle: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            flexibleSpace: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  image:DecorationImage(
                    image: AssetImage('assets/Bunemann.jpg'),fit: BoxFit.cover)
                ),
              ),
            ),
            title: Text(widget.table),
            leading: IconButton(onPressed: () {
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back_ios_new)),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 10),
                child: 
                socketService2.serverStatus == ServerStatus.Online 
                ?
                Icon(Icons.offline_bolt, color: Colors.green)
                :Icon(Icons.offline_bolt, color: Colors.red)
              ),
            ],
          ),
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
                child: Stack(
                  children: [
                  Container(
                    padding: EdgeInsets.all(50),
                    width: double.infinity,
                    height: 280,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image(image: AssetImage('assets/beer2.jpeg')),
                    
                    ),
                  ),
                  _showGraph(),
                  Center(
                    child: AnimatedOpacity(
                    opacity: _visible? 1.0 : 0.0,
                    duration: Duration(microseconds: 300),
                    child: MaterialButton(onPressed: _visible==true? () {
                      socketService2.emit('delete-band',{'nameProduct':'1'} );
                      setState(() {
                        _visible = !_visible ;
                      });
                    }:null,child: Text('Mostrar Productos', style: TextStyle(color: Colors.black),),
                    color: Colors.amber,shape: StadiumBorder(),),),
                  ),
                  if(_visible==false)
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: FloatingActionButton(
                      child: Icon(Icons.add),
                      elevation: 1,
                      onPressed: addNewBand
                    ),
                  ),
                  Positioned(
                  left: 10,
                  bottom: 0,
                  child: MaterialButton(
                    shape: StadiumBorder(),
                    child: Text('Generar Pdf', style: TextStyle(color: Colors.black),),
                    onPressed: () async{
                      createPdf();
                    },
                  ),
                  ),
                ]),
              ),
              Divider(),
              Expanded(
                child: 
                ListView.builder(
                itemCount: bands.length,
                itemBuilder:(context, i) =>_bandTitle(bands[i]))
              ),
            ],
          ),
        ),);
      },
    );
  }

  Widget _bandTitle(Band banda) {

    final socketService = Provider.of<SocketService>(context, listen: false);
    final  te = TextEditingController();
    
    return Column(
      children: [
        if(banda.nameTable.contains(widget.table))
        Dismissible(
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
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 2),
          child: ListTile(
            leading: CircleAvatar(
              child: 
              Text(banda.nameProduct.substring(0,2), 
              style: TextStyle(color: Colors.white),),
              backgroundColor: Colors.cyan,
            ),
            title:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Text(banda.nameProduct,maxLines: 1,overflow: TextOverflow.ellipsis)),
                IconButton(onPressed: () {
                  socketService.socket.emit('vote-band',{'id': banda.id });
                }, icon: Icon(Icons.arrow_drop_up,color: Colors.black,)),
                Container(
                  height: 50,
                  width: 50,
                  child: TextField(onSubmitted: (te){
                    banda.votes2 = int.parse(te);
                    socketService.emit('vote-band3',{'id': banda.id , 'votes2': banda.votes2 });
                  },
                  controller: te,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '${banda.votes}'
                  ) ,style: TextStyle(fontSize: 20),),
                ),
                IconButton(onPressed: () {
                  socketService.socket.emit('vote-band2',{'id': banda.id });
                }, icon: Icon(Icons.arrow_drop_down,color: Colors.black,)),
              ],)
          ),
        ),
        ),],
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
            title: Text('Nombre Producto:'),
            content: TextField(
              controller: textControler
            ),
            actions: [
              MaterialButton(onPressed: () => addBandToList(textControler.text, widget.table),
              child: Text('Agregar'),
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
              onPressed: () =>  addBandToList(textControler.text, widget.table), 
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

  void addBandToList (String name, String tables )
  {
    final socketService = Provider.of<SocketService>(context, listen: false);

    if(name.length > 1)
    {
      socketService.socket.emit('add-band' ,{'nameProduct': name, 'nameTable': tables});
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
              label: bands[index].nameProduct.toString()
              ),
        ),
      ),
      settings: ChartGroupPieSettings(),
    ),
    ChartTooltipLayer(
      shape: () => ChartTooltipPieShape<ChartGroupPieDataItem>(
        onTextName: (item) => item.label,
        onTextValue: (item) => 'Unidades: ${item.amount.toString()}',
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