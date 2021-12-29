import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Queen', votes: 3),
    Band(id: '3', name: 'Iron Maiden', votes: 2),
    Band(id: '4', name: 'Led Zeppelin', votes: 1),
    Band(id: '5', name: 'Helloween', votes: 0),
    Band(id: '6', name: 'Heroes del silencio', votes: 0),
  ];

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(socketService.serverStatus.toString(),
            style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, index) {
          final band = bands[index];
          return Dismissible(
            key: Key(band.id),
            direction: DismissDirection.startToEnd,
            background: Container(
              padding: EdgeInsets.only(left: 8.0),
              color: Colors.red,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Delete band',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
            onDismissed: (direction) {
              setState(() {
                //TODO: Delete the band from the list
                bands.removeAt(index);
              });
            },
            child: bandTile(band),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        child: Icon(Icons.add),
        elevation: 1,
      ),
    );
  }

  ListTile bandTile(Band band) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(band.name.substring(0, 2)),
      ),
      title: Text(band.name),
      trailing: Text('${band.votes}'),
      onTap: () {
        setState(() {
          band.votes++;
        });
      },
    );
  }

  addNewBand() {
    final textController = new TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add a new band'),
            content: TextField(
              controller: textController,
              decoration: InputDecoration(labelText: 'Band Name'),
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              MaterialButton(
                child: Text('Save'),
                onPressed: () {
                  if (textController.text.isNotEmpty) {
                    final newBand = new Band(
                        id: DateTime.now().toString(),
                        name: textController.text,
                        votes: 0);
                    setState(() {
                      bands.add(newBand);
                    });
                  }
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
