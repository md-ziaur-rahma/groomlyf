import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/models/product.dart';
import 'package:groomlyfe/ui/screens/cartScreen.dart';
import 'package:groomlyfe/ui/widgets/avatar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:transparent_image/transparent_image.dart';

//product detail screen
class ProductScreen extends StatefulWidget {
  Product? product;
  ProductScreen({this.product});
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  //product variable
  Product? _product;

  //bottom pop up panel controller
  PanelController _pc = new PanelController();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _product = widget.product;
    for (var item in cartProducts) {
      if (_product!.productId == item!.productId) {
        _product!.quality = item.quality;
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        controller: _pc,
        renderPanelSheet: false,
        panel: _floatingPanel(),
        collapsed: _floatingCollapsed(),
        body: Container(
          padding: EdgeInsets.only(bottom: 30),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                _header(),
                _body(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //product name, user logo, cart situation..
  Widget _header() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              size: 24,
              color: Colors.black,
            ),
          ),

          //user logo
          Avatar(user_image_url, user_id, scaffoldKey, context).smallLogoHome(),

          //cart situation
          InkWell(
            onTap: () {
              if (cartProducts.isNotEmpty)
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartScreen()));
            },
            child: Container(
                child: Stack(
              alignment: Alignment(-1.5, -1),
              children: <Widget>[
                Icon(
                  Icons.shopping_basket,
                  size: 30,
                  color: Colors.black54,
                ),
                cartProducts.isEmpty
                    ? Container()
                    : Container(
                        padding: EdgeInsets.only(
                            top: 2, bottom: 2, right: 5, left: 5),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          cartProducts.length.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            )),
          ),
        ],
      ),
    );
  }

  //product image slider
  Widget _body() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("product/${_product!.productId}/productPhotos")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container();
          } else {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: device_height - 200,
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                  ),
                ),
              );
            } else {
              List<ProductPhotos> _small_photos = [];
              List<ProductPhotos> _big_photos = [];
              print("----------------------------");
              snapshot.data!.docs.forEach((snapshot) {
                ProductPhotos _photo_item =
                    ProductPhotos.fromJson(snapshot.data() as Map<String, dynamic>);
                if (_photo_item.photoType == "small") {
                  _small_photos.add(_photo_item);
                  print("========================${_photo_item.photoUrl}");
                } else {
                  _big_photos.add(_photo_item);
                }
              });
              return Column(
                children: <Widget>[
                  //small photos slider
                  _small_photos_widget(_small_photos),

                  //big photos slider
                  _big_photos_widget(_big_photos),
                ],
              );
            }
          }
        },
      ),
    );
  }

  //small photos slider widget
  Widget _small_photos_widget(List<ProductPhotos> _photos) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      height: device_height * 0.4,
      child: CarouselSlider(
        options: CarouselOptions(
          height: device_height * 0.45,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          viewportFraction: 0.4,
          autoPlay: true,
          autoPlayInterval: Duration(milliseconds: 5000),
          autoPlayCurve: Curves.linear,
          autoPlayAnimationDuration: Duration(milliseconds: 5000),
         /* pauseAutoPlayOnTouch: Duration(seconds: 2),
          onPageChanged: (c) {},*/
          scrollDirection: Axis.horizontal,
        ),

        items: _photos.map((item) {
          return Container(
              width: device_width * 0.4,
              padding: EdgeInsets.all(5),
              child: Stack(
                children: <Widget>[
                  Container(
                    height: device_height,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.grey[400]!, blurRadius: 5)
                        ],
                        borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: item.photoUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        // Where the linear gradient begins and ends
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        // Add one stop for each color. Stops should increase from 0 to 1
                        stops: [0.1, 0.5, 0.7, 0.9],
                        colors: [
                          // Colors are easy thanks to Flutter's Colors class.
                          Colors.grey.withOpacity(0.0),
                          Colors.grey.withOpacity(0.2),
                          Colors.black26,
                          Colors.black54,
                        ],
                      ),
                    ),
                  ),
                ],
              ));
        }).toList(),
      ),
    );
  }

  //big photos slider widget
  Widget _big_photos_widget(List<ProductPhotos> _photos) {
    return Container(
        height: device_height * 0.6 - 140,
        padding: EdgeInsets.only(top: 15),
        child: Container(
          child: CarouselSlider(
            options: CarouselOptions(
              height: device_height * 0.6 - 100,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: Duration(milliseconds: 5000),
              autoPlayCurve: Curves.linear,
              autoPlayAnimationDuration: Duration(milliseconds: 5000),
             /* pauseAutoPlayOnTouch: Duration(seconds: 2),
              onPageChanged: (c) {},*/
              scrollDirection: Axis.horizontal,
            ),

            items: _photos.map((item) {
              return Container(
                padding: EdgeInsets.all(5),
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: device_width,
                      height: device_height,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.grey[400]!, blurRadius: 5)
                          ],
                          borderRadius: BorderRadius.circular(20)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: item.photoUrl!,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          // Where the linear gradient begins and ends
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          // Add one stop for each color. Stops should increase from 0 to 1
                          stops: [0.1, 0.5, 0.7, 0.9],
                          colors: [
                            // Colors are easy thanks to Flutter's Colors class.
                            Colors.grey.withOpacity(0.0),
                            Colors.grey.withOpacity(0.2),
                            Colors.black26,
                            Colors.black54,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ));
  }

  //closed collepse widget. product name and description
  Widget _floatingCollapsed() {
    return InkWell(
      onTap: () {
        _pc.open();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        ),
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: device_width,
                padding:
                    EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 10),

                //product name
                child: Text(
                  _product!.productName!,
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
              ),

              //product description
              Container(
                width: device_width,
                padding: EdgeInsets.only(left: 20, right: 20, top: 0),
                child: Text(
                  _product!.productDescription!,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //opened collapse widget. product all info. add and remve product in cart
  Widget _floatingPanel() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0), topLeft: Radius.circular(30.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 5.0,
              color: Colors.grey[400]!,
            ),
          ]),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                //product name
                Container(
                  width: device_width,
                  padding:
                      EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 10),
                  child: Text(
                    _product!.productName!,
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ),

                //product description
                Container(
                  width: device_width,
                  padding: EdgeInsets.only(left: 20, right: 20, top: 0),
                  child: Text(
                    _product!.productDescription!,
                    maxLines: 6,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  //product type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Type",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _product!.productType!,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  //product category
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Category",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _product!.productCategory!,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  //product price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Price",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "\$" + _product!.productPrice!,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  //product quality
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Quality",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            //remove product from cart button
                            InkWell(
                                onTap: () {
                                  if (_product!.quality == 0) {
                                    return;
                                  }
                                  _product!.quality! - 1;
                                  setState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(
                                          color: Colors.grey, width: 1)),
                                  child: Icon(
                                    Icons.remove,
                                    size: 24,
                                    color: Colors.black,
                                  ),
                                )),
                            SizedBox(
                              width: 10,
                            ),

                            //product quality display
                            Text(
                              _product!.quality.toString(),
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                                onTap: () {
                                  _product!.quality!+1;
                                  setState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(
                                          color: Colors.grey, width: 1)),
                                  child: Icon(
                                    Icons.add,
                                    size: 24,
                                    color: Colors.black,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  //product add to cart
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(
                          left: 50, right: 50, top: 12, bottom: 12),
                      backgroundColor: Colors.orange[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                    onPressed: () async {
                      if (_product!.quality == 0) {
                        return;
                      }
                      int check_index = -1;
                      for (int i = 0; i < cartProducts.length; i++) {
                        if (cartProducts[i]!.productId == _product!.productId) {
                          check_index = i;
                        }
                      }
                      if (check_index != -1) {
                        cartProducts.removeAt(check_index);
                      }
                      cartProducts.add(_product);
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartScreen()));
                      setState(() {});
                    },
                    child: Text(
                      "Add to Cart",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
