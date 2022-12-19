import 'dart:ui';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:groomlyfe/global/data.dart';
import 'package:groomlyfe/models/ads.dart';
import 'package:groomlyfe/providers/shop_registration.dart';
import 'package:groomlyfe/ui/widgets/toast.dart';
import 'package:groomlyfe/util/validator.dart';
import 'package:provider/provider.dart';

class AdsLayer extends StatefulWidget {
  const AdsLayer();
  @override
  _AdsLayerState createState() => _AdsLayerState();
}

class _AdsLayerState extends State<AdsLayer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<ShopRegistrationProvider>(context).pageController!.dispose();
    super.dispose();
  }

  List<String?> list = [];

  @override
  Widget build(BuildContext context) {
    final result = Provider.of<DataSnapshot>(context).value as Map<String, dynamic>?;
    if (result != null) {

      result.forEach((key, values) {
        final ads = '*shopads'.toUpperCase();
        if (values['video_tag'].toUpperCase().toString().contains(ads)) {
          if (list.length < 1) {
            list.add(values['video_url']);
          }
        }
      });
    }
    return Container(
      color: Colors.black26,
      padding:
          EdgeInsets.symmetric(horizontal: 16.0).add(EdgeInsets.only(top: 8.0)),
      child: PageView(
        controller:
            Provider.of<ShopRegistrationProvider>(context).pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Ads(url: list),
          ShopRegistration(),
          CloseRegistration(),
        ],
      ),
    );
  }
}

class Ads extends StatelessWidget {
  final List<String?>? url;
  const Ads({this.url});

  static List<String?> videos = [];

  @override
  Widget build(BuildContext context) {
    videos = url ?? [];
    return SizedBox.expand(
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: videos.length > 0
                  ? MyVideoPlayer(myVideoAds: videos)
                  : Image.asset(
                      "assets/images/ads.png",
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(height: 8.0),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('gl_shop_registration')
                .where('user_id', isEqualTo: user_id)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.length <= 0) {
                  return MaterialButton(
                    height: 45.0,
                    minWidth: double.maxFinite,
                    color: Colors.black,
                    shape: StadiumBorder(),
                    child: Text(
                      'Register to sell on Groomlyfe',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        fontFamily: "phenomena-bold",
                      ),
                    ),
                    onPressed: () {
                      Provider.of<ShopRegistrationProvider>(context)
                          .pageController!
                          .nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.linear,
                          );
                    },
                  );
                }
              }
              return Offstage();
            },
          )
        ],
      ),
    );
  }
}

class MyVideoPlayer extends StatefulWidget {
  final List<String?>? myVideoAds;
  MyVideoPlayer({this.myVideoAds});
  @override
  _MyVideoPlayerState createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  CachedVideoPlayerController? _controller;

  bool isListened = false;
  int index = 0;

  ValueNotifier<bool> valueNotifier = ValueNotifier<bool>(false);
  ValueNotifier<CouponItem> couponNotifier =
      ValueNotifier<CouponItem>(CouponItem.none);
  ValueNotifier<String?> adsNotifier = ValueNotifier<String?>(null);

  List<AdsModel> adsList = [
    AdsModel(
      title: "Fades Factory Store",
      // image: 'assets/images/coupon_image.png',
      image: 'assets/images/store_logo.jpg',
    )
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void checkVideo() {
    if (_controller!.value.position == _controller!.value.duration) {
      if (index < ((widget.myVideoAds!.length) - 1)) {
        index = index + 1;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      _controller =
          CachedVideoPlayerController.network(widget.myVideoAds![index]!)
            ..initialize().then((_) {
              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
              setState(() {
                _controller!.play();
              });
            });
    }
    if (_controller!.value.position == _controller!.value.duration) {
      _controller =
          CachedVideoPlayerController.network(widget.myVideoAds![index]!)
            ..initialize().then((_) {
              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
              setState(() {
                _controller!.play();
              });
            });
    }
    if (!isListened) {
      _controller!.addListener(() {
        checkVideo();
        isListened = true;
      });
    }
    return Stack(
      children: <Widget>[
        Card(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              _controller!.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: CachedVideoPlayer(_controller!),
                    )
                  : SizedBox.expand(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
              ValueListenableBuilder(
                valueListenable: couponNotifier,
                builder: (context, dynamic value, child) {
                  return value == CouponItem.display
                      ? ValueListenableBuilder(
                          valueListenable: adsNotifier,
                          builder: (context, dynamic ads, child) {
                            var size = MediaQuery.of(context).size;
                            print(
                                'weight: ${size.width}, height: ${size.height}');
                            return ads == null
                                ? InkWell(
                                    child: Container(
                                      width: 250,
                                      height: 50.0,
                                      margin: EdgeInsets.only(
                                        top: 10.0,
                                      ),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Text(
                                        adsList[0].title!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "phenomena-regular",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      adsNotifier.value = adsList[0].image;
                                    },
                                  )
                                : Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Container(
                                      // width: 150,
                                      // height: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        image: DecorationImage(
                                          image: AssetImage(ads),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      // child: Stack(
                                      //   alignment: Alignment.bottomLeft,
                                      //   children: [
                                      //     Image.asset(
                                      //       ads,
                                      //       width: double.maxFinite,
                                      //       fit: BoxFit.cover,
                                      //     ),
                                      //   ],
                                      // ),
                                    ),
                                  );
                          },
                        )
                      : Offstage();
                },
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                  width: double.maxFinite,
                  color: Colors.blue[600],
                  child: Text(
                    "Ad ${index + 1} of ${widget.myVideoAds!.length}",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "phenomena-regular",
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0.0,
          right: 0.0,
          child: InkWell(
            child: ValueListenableBuilder(
              valueListenable: valueNotifier,
              builder: (context, dynamic value, child) {
                return Image.asset(
                  value
                      ? 'assets/images/coupon_show.png'
                      : 'assets/images/coupon_hide.png',
                  height: 50.0,
                  width: 50.0,
                  fit: BoxFit.cover,
                );
              },
            ),
            onTap: () {
              if (valueNotifier.value == true) {
                valueNotifier.value = false;
                couponNotifier.value = CouponItem.none;
              } else {
                valueNotifier.value = true;
                if (couponNotifier.value == CouponItem.none) {
                  couponNotifier.value = CouponItem.display;
                  adsNotifier.value = null;
                }
              }
            },
          ),
        )
      ],
    );
  }
}

// displays the registration page
class ShopRegistration extends StatefulWidget {
  @override
  _ShopRegistrationState createState() => _ShopRegistrationState();
}

class _ShopRegistrationState extends State<ShopRegistration> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _companyController = TextEditingController();
  TextEditingController _productController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _sellController = TextEditingController();

  FocusNode _nameFocus = FocusNode();
  FocusNode _emailFocus = FocusNode();
  FocusNode _companyFocus = FocusNode();
  FocusNode _productFocus = FocusNode();
  FocusNode _priceFocus = FocusNode();
  FocusNode _sellFocus = FocusNode();

  bool isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _productController.dispose();
    _priceController.dispose();
    _sellController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _companyFocus.dispose();
    _productFocus.dispose();
    _priceFocus.dispose();
    _sellFocus.dispose();
    super.dispose();
  }

  final style = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 21,
    fontFamily: "phenomena-bold",
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              margin: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const Text(
                      "GL Shop Registration",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        fontFamily: "phenomena-bold",
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _nameController,
                      focusNode: _nameFocus,
                      textInputAction: TextInputAction.next,
                      style: style,
                      validator: Validator.validateName,
                      decoration:
                          InputDecoration(hintText: 'Name', hintStyle: style),
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_emailFocus),
                    ),
                    TextFormField(
                      controller: _emailController,
                      focusNode: _emailFocus,
                      textInputAction: TextInputAction.next,
                      validator: Validator.validateEmail,
                      style: style,
                      decoration:
                          InputDecoration(hintText: 'Email', hintStyle: style),
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_companyFocus),
                    ),
                    TextFormField(
                      controller: _companyController,
                      focusNode: _companyFocus,
                      textInputAction: TextInputAction.next,
                      style: style,
                      validator: Validator.validateString(),
                      decoration: InputDecoration(
                          hintText: 'Company', hintStyle: style),
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_productFocus),
                    ),
                    TextFormField(
                      controller: _productController,
                      focusNode: _productFocus,
                      validator: Validator.validateString(),
                      textInputAction: TextInputAction.next,
                      style: style,
                      decoration: InputDecoration(
                          hintText: 'Product Category', hintStyle: style),
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFocus),
                    ),
                    TextFormField(
                      controller: _priceController,
                      focusNode: _priceFocus,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      validator: Validator.validatePrice,
                      style: style,
                      decoration: InputDecoration(
                          hintText: 'Avg price of product', hintStyle: style),
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_sellFocus),
                    ),
                    const SizedBox(height: 16.0),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        "Why sell on Groomlyfe?",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                          fontFamily: "phenomena-bold",
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: _sellController,
                      focusNode: _sellFocus,
                      validator: Validator.validateString(),
                      maxLines: 6,
                      style: style,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          isLoading
              ? SizedBox(
                  height: 30.0,
                  width: 30.0,
                  child: CircularProgressIndicator(strokeWidth: 3.0),
                )
              : MaterialButton(
                  height: 45.0,
                  minWidth: double.maxFinite,
                  color: Colors.black,
                  shape: StadiumBorder(),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      fontFamily: "phenomena-bold",
                    ),
                  ),
                  onPressed: onSubmit,
                ),
          SizedBox(height: 50.0)
        ],
      ),
    );
  }

  void onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String name = _nameController.text.trim().toString();
      String email = _emailController.text.trim().toString();
      String company = _companyController.text.trim().toString();
      String product = _productController.text.trim().toString();
      String price = _priceController.text.trim().toString();
      String sell = _sellController.text.trim().toString();
      final Map<String, dynamic> body = {
        "user_name": user_firstname ?? "" + user_lastname!,
        'user_email': user_email ?? "",
        'user_id': user_id ?? "",
        "Name": name,
        "Email": email,
        "Company": company,
        "Product Category": product,
        "Avg price of Product": price,
        "Why sell on Groomlyfe": sell
      };
      try {
        setState(() {
          isLoading = true;
        });
        await FirebaseFirestore.instance
            .collection('gl_shop_registration')
            .doc(user_id)
            .set(body);
        Provider.of<ShopRegistrationProvider>(context).pageController!.nextPage(
              duration: Duration(milliseconds: 500),
              curve: Curves.linear,
            );
      } catch (e) {
        ToastShow('Error Encountered. Please try again', context, Colors.red);
      }
    }
  }
}

class CloseRegistration extends StatelessWidget {
  final text1 =
      'You will be reviewed and someone will connect with you soon. Until then enjoy the app and post some amazing contents for others to review';
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                margin: EdgeInsets.all(28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0),
                    SizedBox(
                      height: 80.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'GL',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 80,
                              fontFamily: "phenomena-bold",
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Image.asset(
                            "assets/images/path@2x.png",
                            height: 60.0,
                            fit: BoxFit.contain,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "You are now Registered!",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                              fontFamily: "phenomena-bold",
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            text1,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                              fontFamily: "phenomena-bold",
                            ),
                          ),
                          SizedBox(height: 30.0),
                          const Text(
                            "- Groomlyfe Staff.",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                              fontFamily: "phenomena-bold",
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          MaterialButton(
            height: 45.0,
            minWidth: double.maxFinite,
            color: Colors.black,
            shape: StadiumBorder(),
            child: Text(
              'Close',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                fontFamily: "phenomena-bold",
              ),
            ),
            onPressed: () {
              Provider.of<ShopRegistrationProvider>(context)
                  .pageController!
                  .jumpToPage(0);
            },
          )
        ],
      ),
    );
  }
}
