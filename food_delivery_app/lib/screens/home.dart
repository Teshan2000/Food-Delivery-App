import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,        
        title: const Text('Hello, Peter!'),
        actions: [
          IconButton(
            onPressed: () async {},
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            )
          ),
          Form(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: Colors.white)
            )
          ),
        ],
      ),   
      body: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: SafeArea(child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Explore Foods",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "View All",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.amber,
                    ),  
                  ),
                ] 
              ),
              Row(),
              Column(),
              // TextButton(
              //   onPressed: () { },                
              //),
            ],
          ),        
        )
      ),               
      ),   
    );
  }
} 