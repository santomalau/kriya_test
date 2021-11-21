import 'package:kriya/screens/home/home.dart';
import 'package:kriya/screens/product/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kriya/api/api.dart';
import 'package:kriya/bloc/product_bloc.dart';

// void main() => runApp(MyApp(productsApiClient: ProductApiClient.create()));
void main() async {
  runApp(
    BlocProvider(
      create: (context) => ProductBloc(productsApiClient: ProductApiClient()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // BlocProvider.of<ProductBloc>(context).add(ProductFetchStarted());

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/product': (context) => const ProductScreen(),
      },
    );
  }
}
