
//product info class
class Product {
  String? productId;
  String? productName;
  String? productPrice;
  String? productRetailCost;
  String? productActualCost;
  String? productPhotos;
  String? productSize;
  String? productCategory;
  String? productType;
  String? productManufacturer;
  String? productDescription;
  int? quality = 0;
  Product(
      {this.productId,
        this.productName,
        this.productPrice,
        this.productRetailCost,
        this.productActualCost,
        this.productPhotos,
        this.productSize,
        this.productCategory,
        this.productType,
        this.productManufacturer,
        this.productDescription,
        this.quality,
      });

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    productPrice = json['productPrice'];
    productRetailCost = json['productRetailCost'];
    productActualCost = json['productActualCost'];
    productPhotos = json['productPhotos'];
    productSize = json['productSize'];
    productCategory = json['productCategory'];
    productType = json['productType'];
    productManufacturer = json['productManufacturer'];
    productDescription = json['productDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['productPrice'] = this.productPrice;
    data['productRetailCost'] = this.productRetailCost;
    data['productActualCost'] = this.productActualCost;
    data['productPhotos'] = this.productPhotos;
    data['productSize'] = this.productSize;
    data['productCategory'] = this.productCategory;
    data['productType'] = this.productType;
    data['productManufacturer'] = this.productManufacturer;
    data['productDescription'] = this.productDescription;
    return data;
  }
}


//product photos "small", "big"..
class ProductPhotos {
  String? photoId;
  String? photoType;
  String? photoUrl;

  ProductPhotos({this.photoId, this.photoType, this.photoUrl});

  ProductPhotos.fromJson(Map<String, dynamic> json) {
    photoId = json['photoId'];
    photoType = json['photoType'];
    photoUrl = json['photoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photoId'] = this.photoId;
    data['photoType'] = this.photoType;
    data['photoUrl'] = this.photoUrl;
    return data;
  }
}