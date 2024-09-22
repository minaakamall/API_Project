import 'dart:convert'; // Import for JSON decoding
import 'package:apiproject/home/data/data_models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreenn extends StatefulWidget {
  const HomeScreenn({super.key});

  @override
  State<HomeScreenn> createState() => _HomeScreennState();
}

class _HomeScreennState extends State<HomeScreenn> {
  List<ProductDataModel> data = [];

  Future<void> getProductsData() async {
    try {
      final uri = Uri.parse('https://fakestoreapi.com/products');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        List<dynamic> listOfObjects = jsonDecode(response.body);

        setState(() {
          data = listOfObjects.map((object) {
            return ProductDataModel(
              title: object['title'],
              description: object['description'],
              image: object['image'],
              price: (object['price'] as num).toDouble(),
              
            );
          }).toList();
        });

        print(data);
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      print('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(data[index].image!),
            title: Text(data[index].title ?? "No Title"),
            subtitle: Text("\$${data[index].price.toString()}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  data.removeAt(index);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getProductsData,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
