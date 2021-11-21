import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kriya/api/models/models.dart';
import 'package:kriya/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kriya/bloc/product_bloc.dart';

import 'local_widgets/product_list_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductBloc? bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<ProductBloc>(context, listen: false);
    bloc?.add(ProductFetchStarted());
    // BlocProvider.of<ProductBloc>(context).add(ProductFetchStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(245, 213, 72, 1),
        title: const Text(
          "KRIYA TEST",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: SafeArea(
          child: BlocConsumer<ProductBloc, ProductState>(
            listener: (context, state) {},
            builder: (context, state) {
              return StreamBuilder<List<Product>>(
                stream: bloc?.listStream,
                builder: (context, snapshot) {
                  print(snapshot.connectionState);
                  return RefreshIndicator(
                    color: primarycolor,
                    onRefresh: () async {
                      bloc?.add(ProductFetchStarted());
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (state is ProductLoadInProgress) ...[
                              CircularProgressIndicator(
                                color: primarycolor,
                              )
                            ] else if (state is ProductLoadSuccess) ...[
                              if (snapshot.hasData) ...[
                                Container(
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.withOpacity(0.5),
                                          width: 1),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    'Total Product : ' +
                                        snapshot.data!.length.toString(),
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                                Flexible(
                                  child: Container(
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        final product = snapshot.data![index];

                                        return ProductListTile(
                                            product: product);
                                      },
                                    ),
                                  ),
                                )
                              ]
                            ] else
                              SizedBox(
                                child: Text('Oops something went wrong!'),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );

              // if (state is ProductLoadSuccess) {

              //     },
              //   );
              // }

              // if (state is ProductDeleteState) {
              //   bloc?.add(ProductFetchStarted());
              // }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/product',
          );
        },
        child: const Icon(FeatherIcons.shoppingBag),
        backgroundColor: primarycolor,
      ),
    );
  }
}
