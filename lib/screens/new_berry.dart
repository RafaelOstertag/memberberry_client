import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:memberberry_client/models/berry.dart';
import 'package:provider/provider.dart';

class NewBerry extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NewBerry();
}

class _NewBerry extends State<NewBerry> {
  final _subjectController = TextEditingController();
  String _period = "DAILY";

  @override
  Widget build(BuildContext context) {
    return Consumer<BerryModel>(builder: (context, berryModel, child) {
      return _scaffold(berryModel);
    });
  }

  Scaffold _scaffold(BerryModel berryModel) {
    return Scaffold(
        appBar: AppBar(title: Text('New Berry')),
        body: SafeArea(
            child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 12.0),
            TextField(
              decoration: InputDecoration(filled: true, labelText: 'Subject'),
              controller: _subjectController,
            ),
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
                    berryModel.create(_subjectController.value.text, _period);
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        )));
  }
}
