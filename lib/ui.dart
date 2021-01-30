import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:latrag_app/latrag.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _formKey = GlobalKey<NounInputFormState>();

  int _processing = -1;

  String nominativus, genitivus;
  LatinWord word;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LatRag'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow_rounded),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            setState(() {
              nominativus = _formKey.currentState.nominativus();
              genitivus = _formKey.currentState.genitivus();
              if (_formKey.currentState.chosenDeclinatio == -1) {
                this.word = LatinWord.autoDetect(
                  genitivus: genitivus,
                  nominativus: nominativus,
                  neutrum: _formKey.currentState.neutrum,
                );
              } else {
                this.word = LatinWord.forceDecl(
                  genitivus: genitivus,
                  nominativus: nominativus,
                  neutrum: _formKey.currentState.neutrum,
                  decl: _formKey.currentState.chosenDeclinatio,
                );
              }
            });
          }
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NounInputForm(
              key: _formKey,
            ),
            Container(
              height: 16,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: this.word != null ? 10 : 0,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(word.ragoz(index)),
                    subtitle: Text(['Singularis', 'Pluralis'][index ~/ 5] +
                        ' ' +
                        [
                          'nominativus',
                          'accusativus',
                          'genitivus',
                          'dativus',
                          'ablativus'
                        ][index % 5]),
                    onTap: () {
                      var rag = word.ragoz(index);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Copy text"),
                            content: Text(
                                'Are you sure you want to copy "' + rag + '"?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('No'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: rag));
                                  Navigator.of(context).pop();
                                },
                                child: Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );
                      Clipboard.setData(new ClipboardData(text: rag));
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NounInputForm extends StatefulWidget {
  NounInputForm({key}) : super(key: key);

  @override
  NounInputFormState createState() => NounInputFormState();
}

class NounInputFormState extends State<NounInputForm> {
  final formKey = GlobalKey<FormState>();
  final _genitivusController = TextEditingController();
  final _nominativusController = TextEditingController();

  int chosenDeclinatio = -1;
  bool neutrum = false;

  String genitivus() {
    return _genitivusController.text;
  }

  String nominativus() {
    return _nominativusController.text;
  }

  bool validate() {
    return formKey.currentState.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nominativus',
                  ),
                  controller: _nominativusController,
                  validator: (value) =>
                      value.trim() == '' ? 'Type something' : null,
                ),
              ),
              Container(
                width: 16,
              ),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Genitivus',
                  ),
                  validator: (value) =>
                      checkCorrectGenitivus(value) ? null : 'Invalid genitivus',
                  controller: _genitivusController,
                ),
              ),
            ],
          ),
          Container(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField(
                  items: [
                    DropdownMenuItem(
                      child: Text('Auto'),
                      value: -1,
                    ),
                    for (int i = 1; i <= 5; ++i)
                      DropdownMenuItem(
                        child: Text('Declinatio ' + i.toString()),
                        value: i - 1,
                      )
                  ],
                  onChanged: (value) {
                    this.chosenDeclinatio = value;
                  },
                ),
              ),
              Container(width: 16),
              Expanded(
                child: DropdownButtonFormField(
                  items: [
                    DropdownMenuItem(
                      child: Text('Masculinum'),
                      value: 0,
                    ),
                    DropdownMenuItem(
                      child: Text('Femininum'),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text('Neutrum'),
                      value: 2,
                    ),
                  ],
                  onChanged: (value) {
                    this.neutrum = value == 2;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
