import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  @JsonKey(name: "productsImage")
  List<String>? productsImage;
  @JsonKey(name: "productName")
  String productName;
  @JsonKey(name: "productsDescription")
  String? productsDescription;
  @JsonKey(name: "productsPrice")
  double productsPrice;
  @JsonKey(name: "productCategory")
  String productCategory;
  @JsonKey(name: "productSubCategory")
  String productSubCategory;
  @JsonKey(name: "productBrand")
  String productBrand;
  @JsonKey(name: "shopId")
  String shopId;
  @JsonKey(name: "isActive")
  bool isActive;
  @JsonKey(name: "_id")
  final String id;
  @JsonKey(name: "productDiscount")
  ProductDiscount? productDiscount;

  ProductModel(
      {this.productsImage,
      required this.productName,
      this.productsDescription,
      required this.productsPrice,
      required this.productCategory,
      required this.productSubCategory,
      required this.productBrand,
      required this.shopId,
      required this.isActive,
      required this.id,
      this.productDiscount});

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}

@JsonSerializable()
class ProductDiscount {
  @JsonKey(name: "discountedvalue")
  int discountPrice;

  @JsonKey(name: "discounttype")
  String discountType;

  ProductDiscount({
    required this.discountPrice,
    required this.discountType,
  });

  factory ProductDiscount.fromJson(Map<String, dynamic> json) =>
      _$ProductDiscountFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDiscountToJson(this);
}
