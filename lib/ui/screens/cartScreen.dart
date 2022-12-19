import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/models/product.dart';
import 'package:groomlyfe/ui/screens/productScreen.dart';
import 'package:groomlyfe/ui/widgets/avatar.dart';
import 'package:groomlyfe/ui/widgets/toast.dart';
import 'package:transparent_image/transparent_image.dart';

// cart screen
class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  double total_price = 0.0;
  static final String tokenizationKey = 'sandbox_6m2663hb_qnz77qsm9p2h3xq2';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calculatorTotalPrice();
  }

  //total price calculator
  _calculatorTotalPrice() async {
    total_price = 0.0;
    for (var item in cartProducts) {
      total_price += double.parse(item!.productPrice!) * item.quality!;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Your Cart"),
            Avatar(user_image_url, user_id, scaffoldKey, context)
                .smallLogoHome(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              //product list widget
              _productListWidget(),
              SizedBox(
                height: 20,
              ),

              //total price widget
              _totlaPriceWidget(),
              SizedBox(
                height: 20,
              ),

              //checkout button
              _chekcourButton(),
            ],
          ),
        ),
      ),
    );
  }

  //product list widget
  Widget _productListWidget() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.grey, blurRadius: 3, offset: Offset(1, 1)),
      ]),
      child: Column(
        children: cartProducts.map((_product) {
          return _productWidget(_product!);
        }).toList(),
      ),
    );
  }

  //product item vidget
  Widget _productWidget(Product item) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1))),
      child: Row(
        children: <Widget>[
          InkWell(
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
              width: 100,
              height: 80,
              decoration: BoxDecoration(color: Colors.grey),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: item.productPhotos!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: device_width - 160,
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    item.productName!,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.fade,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    width: device_width - 160,
                    padding: EdgeInsets.only(left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //price
                        Text(
                          "\$${item.productPrice}",
                          style: TextStyle(color: Colors.grey, fontSize: 22),
                        ),

                        //quality
                        Container(
                          child: Row(
                            children: <Widget>[
                              InkWell(
                                  onTap: () {
                                    //add remove products in cart
                                    cartProducts[cartProducts.indexOf(item)]!
                                        .quality! - 1;
                                    if (cartProducts[cartProducts.indexOf(item)]!
                                            .quality ==
                                        0) {
                                      cartProducts.remove(item);
                                      if (cartProducts.isEmpty) {
                                        Navigator.pop(context);
                                        return;
                                      }
                                    }
                                    _calculatorTotalPrice();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(
                                            color: Colors.grey, width: 1)),
                                    child: Icon(
                                      Icons.remove,
                                      size: 18,
                                      color: Colors.black,
                                    ),
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                item.quality.toString(),
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                  onTap: () {
                                    cartProducts[cartProducts.indexOf(item)]!.quality! + 1;
                                    _calculatorTotalPrice();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(
                                            color: Colors.grey, width: 1)),
                                    child: Icon(
                                      Icons.add,
                                      size: 18,
                                      color: Colors.black,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  //total price widget
  Widget _totlaPriceWidget() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.grey, blurRadius: 3, offset: Offset(1, 1)),
      ]),
      child: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Total Price",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "\$$total_price",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  //checkout button widget
  Widget _chekcourButton() {
    return InkWell(
      onTap: _pay,
      child: Container(
        color: Colors.black87,
        padding: EdgeInsets.all(15),
        alignment: Alignment.center,
        child: Text(
          "CHECKOUT",
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
      ),
    );
  }

  //braintee pay
  void _pay() async {
    var request = BraintreeDropInRequest(
      tokenizationKey: tokenizationKey,
      collectDeviceData: true,
      googlePaymentRequest: BraintreeGooglePaymentRequest(
        totalPrice: '$total_price',
        currencyCode: 'USD',
        billingAddressRequired: false,
      ),
      paypalRequest: BraintreePayPalRequest(
        amount: '$total_price',
        displayName: 'Example company',
      ),
    );
    BraintreeDropInResult? result = await BraintreeDropIn.start(request);
//    final request = BraintreePayPalRequest(amount: '$total_price');
//    BraintreePaymentMethodNonce result =
//    await Braintree.requestPaypalNonce(
//      tokenizationKey,
//      request,
//    );
    if (result != null) {
      ToastShow("Success", context, Colors.red[700]).init();
    }
  }
}
