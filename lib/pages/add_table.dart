import 'package:band_names/services/socket_service.dart';
import 'package:band_names/widget/card_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTable extends StatefulWidget {

  AddTable({Key? key}) : super(key: key);

  @override
  State<AddTable> createState() => _AddTableState();
}

class _AddTableState extends State<AddTable> {

  Color selectedColor = Colors.primaries.first;
  final textController = TextEditingController();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30)
      ),
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      content: SizedBox(
        height: 400,
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30)),
                color: Colors.cyan,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory,size: 60,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: textController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold
                      ),
                      decoration: InputDecoration(
                        hintText: 'Nombre Inventario',
                        border: InputBorder.none
                      ),
                    ),
                  )
                ],
              ),
            )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                errorMessage ?? '',
                style: TextStyle(color: Colors.red),
              ),
              ),
              Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: MaterialButton(onPressed: () {
                _onSave(textController.text);
              },
              shape: StadiumBorder(),
              color: Colors.cyan,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Text('Crear Inventario',style: TextStyle(color: Colors.white),),
                ),
              ),
              )],
              ),
            ));
  }
  
  void _onSave( String name) {
    final name = textController.text.trim();
    if(name.isEmpty)
    {
      setState(() {
        errorMessage = 'Nombre de inventario requerido';
      });
      return;
    }else
    {
      final socketService = Provider.of<SocketService>(context, listen: false);

      if(name.length > 1)
      {
        socketService.socket.emit('add-table' ,{'tableName': name, 'color': 'no-colors'});
      }

      setState(() {
        errorMessage= null;
      });
    }
    final result = SingleCard(color: selectedColor, text: name);
    Navigator.of(context).pop(result);
  }
}