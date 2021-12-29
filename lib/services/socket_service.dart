import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;

  ServerStatus get serverStatus => this._serverStatus;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    print('estoy aki');
    IO.Socket socket = IO.io('http://192.168.1.37:3000', {
      'transports': ['websocket'],
      'autoConnect': true
    });

    socket.onConnect((_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
      print('connect');
    });
    socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
      print('disconnect');
    });
    

    socket.on('respuesta', (_data) {
      print(_data);
    });
    socket.connect();
  }
/*
  void setServerStatus(ServerStatus status) {
    this._serverStatus = status;
    notifyListeners();
  }

  void setServerStatus(ServerStatus status) {
    this._serverStatus = status;
    notifyListeners();
  }

  */
}
