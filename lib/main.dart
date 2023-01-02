import 'package:flutter/material.dart';
import 'sign_up_page.dart';
import 'offers_search.dart';
import 'item_list.dart';

class Offer {
  String offerName;
  int id;
  Offer(this.offerName, this.id);
}

const List<String> list = <String>['Swiggy', 'Zomato', 'Uber', 'Travel'];
const List<String> creditCardList = <String>[
  'Flipkart Axis',
  'Amazon ICICI',
  'StandardCharted Smart'
];

void main() {
  runApp(MaterialApp(
    home: SignUp(),
    initialRoute: '/signUp',
    routes: {
      '/signUp': (context) => SignUp(),
      '/offerSearch': (context) => const OfferSearch(),
      '/listItems': (context) => const CreditCardList()
    },
  ));
}

class DropdownButtonApp extends StatelessWidget {
  const DropdownButtonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dropdown Sample'),
      ),
      body: const Center(
        child: DropdownButtonExample(),
      ),
    );
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<StatefulWidget> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;
  String creditCardValue = creditCardList.first;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        Container(
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.all(10.0),
            child: Text("Select anyone : ")),
        Container(
            child: DropdownButton<String>(
          value: creditCardValue,
          icon: const Icon(
            Icons.arrow_circle_down,
            size: 20,
          ),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? value) {
            setState(() {
              dropdownValue = value!;
            });
          },
          items: creditCardList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        ))
      ]),
      Row(children: [
        Container(
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.all(10.0),
            child: Text("Select anyone : ")),
        Container(
            child: DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(
            Icons.arrow_circle_down,
            size: 20,
          ),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? value) {
            setState(() {
              dropdownValue = value!;
            });
          },
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        ))
      ]),
      Row(
        children: [
          Container(
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.all(10.0),
              child: Text("Enter amount : ")),
          Container(
            child: SizedBox(
              height: 30,
              width: 100,
              child: TextField(
                  decoration: InputDecoration(border: OutlineInputBorder())),
            ),
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.deepPurpleAccent)),
              child: Text(
                "Calculate",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => {},
            ),
          )
        ],
      )
    ]);
  }
}
