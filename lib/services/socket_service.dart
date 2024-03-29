
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus
{
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  
  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;


  SocketService(){
   this._initConfig();
  }

  void _initConfig() {
    
    this._socket = IO.io('ip', OptionBuilder()
      .setTransports(['websocket']) 
      .enableAutoConnect()
      .setExtraHeaders({'foo': 'bar'})
      .build()
    );

    this._socket.onConnect((_) {
      this._serverStatus = ServerStatus.Online;
      print("conect");
      notifyListeners();
    });

    this._socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      print('Desconectado del Socket Server');
      notifyListeners();
    });

    this._socket.on('nuevo-mensaje', (payload) =>
    {
      print('nuevo-mensaje: $payload' ),
      notifyListeners()
    });
  }
}


