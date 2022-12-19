import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/models/product.dart';
import 'package:groomlyfe/providers/shop_registration.dart';
import 'package:groomlyfe/ui/screens/cartScreen.dart';
import 'package:groomlyfe/ui/screens/productScreen.dart';
import 'package:groomlyfe/ui/widgets/shop_components.dart';
import 'package:provider/provider.dart';

//shop widget in shop tab of home
class Shop extends StatefulWidget {
  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  TextEditingController _searchProductController = new TextEditingController();
  List<Product> products = [];
  List<Product> constantProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _init_products();
  }

  //get products.....................
  void _init_products() async {
    try {
      FirebaseFirestore.instance.collection('product').snapshots().forEach((data) {
        products = [];
        data.docs.forEach((doc) {
          print(doc['productName']);
          Product item = Product.fromJson(doc.data());
          products.add(item);
        });
        constantProducts = products;
        _isLoading = false;
        setState(() {});
        // use ds as a snapshot
      });
    } catch (e) {
      _isLoading = false;
      setState(() {});
    }
  }

  //search products...............................
  _search(String query) {
    if (query == "") {
      products = constantProducts;
      setState(() {});
      return;
    } else {
      products = constantProducts;
      List<Product> productForSearch = products;
      products = [];
      for (var item in productForSearch) {
        if (item.productName!.toLowerCase().contains(query)) {
          products.add(item);
        }
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: _searchProductController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: "mantserrat-bold"),
                        border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1)),
                        enabledBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1)),
                        hintText: "search for products",
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) {
                        print(value);
                        _search(value);
                      },
                    ),
                  ),
                  Container(
                    height: device_height - 220,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                _isLoading
                                    ? Container(
                                        height: device_width,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            backgroundColor: Colors.black,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        child: products.isEmpty
                                            ? Container()
                                            : Column(
                                                children:
                                                    products.map((productItem) {
                                                  return _productItemWidget(
                                                      productItem);
                                                }).toList(),
                                              ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Provider.of<ShopRegistrationProvider>(context).isAdds
                ? Offstage()
                : Positioned(
                    bottom: 0,
                    right: 10,
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        if (cartProducts.length > 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartScreen()));
                        }
                      },
                      backgroundColor: Colors.black,
                      label: Row(
                        children: <Widget>[
                          Icon(Icons.shopping_cart),
                          SizedBox(
                            width: 10,
                          ),
                          Text("${cartProducts.length} items")
                        ],
                      ),
                    ),
                  ),
          ],
        ),
        SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.78,
          child: const AdsLayer(),
        ),
      ],
    );
  }

  //product item widget...............................................
  Widget _productItemWidget(Product item) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: device_width,
      height: 500,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: CachedNetworkImageProvider(item.productPhotos!),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(color: Colors.grey, offset: Offset(1, 1), blurRadius: 10),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 397,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Colors.white.withOpacity(0.0),
                      Colors.black54
                    ])),
              ),
              InkWell(
                onTap: () async {},

                //product type name price..........................
                child: Container(
                  padding: EdgeInsets.all(5),
                  height: 397,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.productType!,
                        style: TextStyle(color: Colors.white),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: device_width - 100,
                            child: Text(
                              item.productName!,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: "phenomena-bold"),
                            ),
                          ),
                          Container(
                            child: Text(
                              "\$${item.productPrice}",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),

          //desctoption
          Container(
            color: Colors.white,
            width: device_width - 20,
            padding: EdgeInsets.all(5),
            child: Text(
              item.productDescription!,
              maxLines: 4,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          //add to cart
          InkWell(
            focusColor: Colors.grey,
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductScreen(
                            product: item,
                          )));
              setState(() {});
            },
            child: Container(
              alignment: Alignment.center,
              width: device_width - 20,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Text(
                "Add to cart",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "phenomena-bold",
                    fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
