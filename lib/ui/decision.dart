import 'package:acessibility_project/ui/listener/home_receptor.dart';
import 'package:flutter/material.dart';
import 'package:acessibility_project/ui/storyteller/home.dart';

class Decision extends StatefulWidget {
  @override
  _DecisionState createState() => _DecisionState();
}

class _DecisionState extends State<Decision> {
  final TextEditingController _usuarioController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _name = "";

  validateInputsStoryteller() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      showHomeStoryteller();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  validateInputsListener() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      showHomeListener();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  showHomeStoryteller() {
    String textToSend = _usuarioController.text;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new Home(textToSend),
        ));
  }

  showHomeListener() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new HomeReceptor(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text("Áudio Descrição"),
          backgroundColor: Colors.deepOrange,
          // actions: <Widget>[],
        ),
        backgroundColor: Colors.lightBlueAccent[100],
        body: Form(
          key: _formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Seja bem vindo!",
                  style: TextStyle(
                    fontSize: 24.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.deepOrangeAccent,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _usuarioController,
                    decoration: InputDecoration(
                      hintText: 'Nome',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.5)),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (String arg) {
                      if (arg.length < 3)
                        return 'Digite seu nome';
                      else
                        return null;
                    },
                    onSaved: (String val) {
                      _name = val;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        //Entrar
                        Container(
                          // ignore: deprecated_member_use
                          child: RaisedButton(
                            onPressed: validateInputsStoryteller,
                            color: Colors.deepOrange,
                            child: Text(
                              "Narrador",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                        //Cancelar
                        Container(
                          // ignore: deprecated_member_use
                          child: RaisedButton(
                            onPressed: validateInputsListener,
                            color: Colors.deepOrange,
                            child: Text(
                              "Ouvinte",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ]),
        ));
  }
}
