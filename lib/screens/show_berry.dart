import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memberberry_client/models/berry.dart';
import 'package:provider/provider.dart';

class ShowBerryArguments {
  final int berryIndex;

  ShowBerryArguments(this.berryIndex);
}

class ShowBerry extends StatelessWidget {
  static const routeName = '/existing-berry';

  @override
  Widget build(BuildContext context) {
    final ShowBerryArguments args = ModalRoute.of(context).settings.arguments;

    return Consumer<BerryModel>(builder: (context, berryModel, child) {
      var berry = berryModel.get(args.berryIndex);
      return _scaffold(berry, context);
    });
  }

  Widget _scaffold(Berry berry, BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Memberberry')),
        body: SafeArea(
            child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            ListTile(title: Text(berry.subject), subtitle: Text("Subject")),
            ListTile(
              title: Text(berry.period),
              subtitle: Text("Period"),
            ),
            ListTile(
              title: Text(berry.nextExecution.toLocal().toIso8601String()),
              subtitle: Text("Next execution"),
            ),
            ListTile(
              title: Text(berry.lastExecution.toLocal().toIso8601String()),
              subtitle: Text("Last Execution"),
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('BACK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        )));
  }
}
