import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:memberberry_client/models/berry.dart';
import 'package:provider/provider.dart';

class ShowBerryArguments {
  final int berryIndex;

  ShowBerryArguments(this.berryIndex);
}

class ExistingBerry extends StatefulWidget {
  static const routeName = '/existing-berry';

  @override
  State<StatefulWidget> createState() => _ExistingBerry();
}

class _ExistingBerry extends State<ExistingBerry> {
  final _subjectController = TextEditingController();
  DateTime _nextExecution;
  String _period;

  @override
  Widget build(BuildContext context) {
    final ShowBerryArguments args = ModalRoute.of(context).settings.arguments;

    return Consumer<BerryModel>(builder: (context, berryModel, child) {
      var existingBerry = berryModel.get(args.berryIndex);
      _subjectController.text = existingBerry.subject;
      if (_nextExecution == null) {
        _nextExecution = existingBerry.nextExecution;
      }
      if (_period == null) {
        _period = existingBerry.period;
      }

      return _scaffold(berryModel, args.berryIndex, context);
    });
  }

  Scaffold _scaffold(
      BerryModel berryModel, int berryIndex, BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Berry')),
        body: SafeArea(
            child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 12.0),
            TextField(
              decoration: InputDecoration(filled: true, labelText: 'Subject'),
              controller: _subjectController,
            ),
            SizedBox(height: 12.0),
            ListTile(
                title: Text(_nextExecution.toIso8601String()),
                subtitle: Text("Next execution"),
                trailing: FlatButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: DateTime.now().add(Duration(days: -2)),
                          maxTime: DateTime.now().add(Duration(days: 400)),
                          onConfirm: (date) {
                        setState(() => _nextExecution = date);
                      }, currentTime: DateTime.now());
                    },
                    child:
                        Text('SELECT', style: TextStyle(color: Colors.blue)))),
            ListTile(
                title: Text("Daily"),
                leading: Radio(
                  value: "DAILY",
                  groupValue: _period,
                  onChanged: (String value) {
                    setState(() => _period = value);
                  },
                )),
            ListTile(
                title: Text("Weekly"),
                leading: Radio(
                  value: "WEEKLY",
                  groupValue: _period,
                  onChanged: (String value) {
                    setState(() => _period = value);
                  },
                )),
            ListTile(
                title: Text("Monthly"),
                leading: Radio(
                  value: "MONTHLY",
                  groupValue: _period,
                  onChanged: (String value) {
                    setState(() => _period = value);
                  },
                )),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    setState(() => _subjectController.clear());
                    setState(() => _period = "'DAILY");
                    Navigator.pop(context);
                  },
                ),
                RaisedButton(
                  child: Text('SAVE'),
                  onPressed: () {
                    berryModel.update(berryIndex, _subjectController.value.text,
                        _nextExecution, _period);
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        )));
  }
}
