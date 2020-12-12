import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memberberry_client/models/berry.dart';
import 'package:memberberry_client/screens/existing_berry.dart';
import 'package:provider/provider.dart';

class BerryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Memberberries')),
      body: Column(children: [
        Expanded(
            child:
                Padding(padding: const EdgeInsets.all(32), child: _BerryList()))
      ]),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/new'),
          tooltip: 'Add new berry',
          child: const Icon(Icons.add)),
    );
  }
}

class _BerryList extends StatelessWidget {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    var berries = context.watch<BerryModel>();

    return ListView.builder(
        itemCount: berries.list.length,
        itemBuilder: (context, index) => ListTile(
              isThreeLine: true,
              trailing: IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    berries.delete(index);
                  }),
              title: Text(berries.list[index].subject),
              subtitle: Text(berries.list[index].period +
                  ", " +
                  _getNextExecutionDate(berries.list[index])),
          onTap: () => Navigator.pushNamed(context, ExistingBerry.routeName,
                  arguments: ShowBerryArguments(index)),
            ));
  }

  String _getNextExecutionDate(Berry berry) {
    return _dateFormat.format(berry.nextExecution);
  }
}
