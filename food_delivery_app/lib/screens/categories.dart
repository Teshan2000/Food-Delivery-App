import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/categoryCard.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> with TickerProviderStateMixin {

  List<Map<String, dynamic>> categories = [
    {"image": "🍕", "name": "Pizza"},
    {"image": "🍔", "name": "Burger"},
    {"image": "🌭", "name": "Hotdog"},
    {"image": "🥪", "name": "Sandwich"},
    {"image": "🌮", "name": "Taco"},
    {"image": "🥐", "name": "Bun"},
    {"image": "🍞", "name": "Bread"},
    {"image": "🥮", "name": "Cake"}
  ];

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
        padding: const EdgeInsets.symmetric(
          horizontal: 10, 
          vertical: 10
        ),        
        child: SingleChildScrollView(
          child: GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2, 
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: List.generate(
              categories.length,
              (index) =>GestureDetector(
                child: Container(
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
                                child: Center(
                                  child: Text(
                                    categories[index]['image'],
                                    style: TextStyle(fontSize: 35),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              categories[index]['name'],
                              style: TextStyle(
                                fontSize: 16, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    AnimationController _controller = AnimationController(
                      vsync: this,
                      duration: Duration(milliseconds: 300),
                    );
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => BottomSheet(
                        animationController: _controller,
                        onClosing: () {
                          TextButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.close),
                            label: Text('Close')
                          );
                        },
                        builder: (BuildContext context) {
                          return CategoryCard();
                        },
                      ),
                    );
                  },
                ),                
              )
            )          
        ),
      )
    );
  }
}
