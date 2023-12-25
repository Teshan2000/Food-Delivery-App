import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: const Icon(Icons.arrow_back),
        title: const Center(child: Text('Categories')),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.fastfood),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),        
        child: GestureDetector(
          child: GridView.count(
            crossAxisCount: 2, 
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                height: 165,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Container(
                      width: 90,
                      height: 145,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFFC107),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: ShapeDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(90),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  '🍕',
                                  style: TextStyle(fontSize: 35),
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            'Pizza',
                            style: TextStyle(
                              fontSize: 16, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                height: 165,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Container(
                      width: 90,
                      height: 145,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFFC107),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: ShapeDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(90),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  '🍔',
                                  style: TextStyle(fontSize: 35),
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            'Burger',
                            style: TextStyle(
                              fontSize: 16, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                height: 165,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Container(
                      width: 90,
                      height: 145,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFFC107),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: ShapeDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(90),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  '🌭',
                                  style: TextStyle(fontSize: 35),
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            'Hotdog',
                            style: TextStyle(
                              fontSize: 16, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                height: 165,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Container(
                      width: 90,
                      height: 145,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFFC107),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: ShapeDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(90),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  '🥪',
                                  style: TextStyle(fontSize: 35),
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            'Sandwich',
                            style: TextStyle(
                              fontSize: 16, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                height: 165,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Container(
                      width: 90,
                      height: 145,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFFC107),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: ShapeDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(90),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  '🥐',
                                  style: TextStyle(fontSize: 35),
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            'Bun',
                            style: TextStyle(
                              fontSize: 16, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                height: 165,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Container(
                      width: 90,
                      height: 145,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFFC107),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: ShapeDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(90),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  '🍞',
                                  style: TextStyle(fontSize: 35),
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            'Bread',
                            style: TextStyle(
                              fontSize: 16, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                ),
              ),
            ]
          )
        ),
      )
    );
  }
}
