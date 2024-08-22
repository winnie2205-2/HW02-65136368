import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'product.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Product>? products;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    var url = Uri.http("fakestoreapi.com", "products");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        products = productFromJson(response.body);
      });
    } else {
      // Handle errors here
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("UT@WU Shop")),
      body: products == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products!.length,
              itemBuilder: (context, index) {
                Product product = products![index];
                var imgUrl = product.image;
                imgUrl ??= "https://icon-library.com/images/no-picture-available-icon/no-picture-available-icon-20.jpg";
                return ListTile(
                  title: Text("${product.title}"),
                  subtitle: Text("\$${product.price}"),
                  leading: AspectRatio(
                    aspectRatio: 1.0,
                    child: Image.network(imgUrl),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Details(),
                        settings: RouteSettings(
                          arguments: product,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    var imgUrl = product.image;
    imgUrl ??= "https://icon-library.com/images/no-picture-available-icon/no-picture-available-icon-20.jpg";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: Image.network(imgUrl),
          ),
          ListTile(
            title: Text(
              "${product.title}",
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "\$${product.price}",
              style: const TextStyle(fontSize: 20.0),
            ),
          ),
          ListTile(
            title: const Text(
              "Category",
              style: TextStyle(color: Colors.grey),
            ),
            subtitle: Text(
              "${product.category?.name ?? 'Unknown'}",
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
          ListTile(
            title: Text(
              "Rating: ${product.rating?.rate ?? 'N/A'}/5 of ${product.rating?.count ?? 'N/A'}",
            ),
          ),
          RatingBar.builder(
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (value) => print(value),
            minRating: 0,
            itemCount: 5,
            allowHalfRating: true,
            direction: Axis.horizontal,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          ),
        ],
      ),
    );
  }
}

final GlobalKey<FormState> _key1 = GlobalKey<FormState>();
final GlobalKey<FormState> _key2 = GlobalKey<FormState>(); // ซ้ำกับ _key1

@override
Widget build(BuildContext context) {
  return Column(
    children: [
      Form(
        key: _key1,
        child: TextFormField(),
      ),
      Form(
        key: _key2, // นี่จะทำให้เกิดข้อผิดพลาดเนื่องจากการใช้ _key1 และ _key2 ซ้ำกัน
        child: TextFormField(),
      ),
    ],
  );
}



