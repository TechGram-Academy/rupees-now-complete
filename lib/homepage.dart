import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rupeesnow/constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double currentRate = 0;
  String selectedCurrency = currencies[0];

  @override
  void initState() {
    super.initState();
    getData("USD");
  }

  void getData(String currency) async {
    String url =
        "https://free.currconv.com/api/v7/convert?q=${currency}_INR&compact=ultra&apiKey=[your api key goes here]";
    var result = await http.get(url);
    var data = jsonDecode(result.body);
    setState(() {
      currentRate = data["${currency}_INR"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rupees Now"),
      ),
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: Card(
            elevation: 20,
            child: Container(
              color: Colors.lightBlueAccent,
              height: 100,
              width: 150,
              child: Center(
                child: Text(
                  currentRate.toString(),
                  style: TextStyle(color: textColor, fontSize: 20),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 150,
              color: Colors.lightBlueAccent,
              child: Center(
                child: Platform.isIOS
                    ? CupertinoPicker(
                        children: <Widget>[
                          for (String val in currencies) Text(val, style: TextStyle(color: textColor),)
                        ],
                        itemExtent: 30,
                        onSelectedItemChanged: (value) {
                          print(currencies[value]);
                          getData(currencies[value]);
                        },
                      )
                    : DropdownButton(
                      dropdownColor: Colors.lightBlueAccent,
                        value: selectedCurrency,
                        items: [
                          for (String val in currencies)
                            DropdownMenuItem(

                              child: Text(val, style: TextStyle(color:textColor),),
                              value: val,
                            )
                        ],
                        onChanged: (value) {
                          getData(value);
                          setState(() {
                            selectedCurrency = value;
                          });
                        },
                      ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
