import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:kriya/api/models/models.dart';
import 'package:kriya/bloc/product_bloc.dart';
import 'package:kriya/screens/product/local_widgets/order_list_tile.dart';
import 'package:kriya/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kriya/screens/home/local_widgets/product_list_tile.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  ProductBloc? bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<ProductBloc>(context, listen: false);
    bloc?.add(ProductMigrateEvent());
    // BlocProvider.of<ProductBloc>(context).add(ProductFetchStarted());
  }

  Future<bool> _onWillPop() async {
    bloc?.add(ProductRevertEvent());
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(245, 213, 72, 1),
          foregroundColor: blackcolor,
          title: const Text(
            "KRIYA TEST",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SafeArea(
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
                      bloc?.add(ProductMigrateEvent());
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                    'Total Order : ' +
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

                                        return OrderListTile(product: product);
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
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            bloc?.add(ProductOrderClearEvent());
            Navigator.pushNamed(
              context,
              '/',
              arguments: {'action': 'addProduct'},
            );
          },
          child: const Icon(FeatherIcons.shoppingCart),
          backgroundColor: primarycolor,
        ),
      ),
    );
  }
}
