// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      productsImage: (json['productsImage'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      productName: json['productName'] as String,
      productsDescription: json['productsDescription'] as String?,
      productsPrice: (json['productsPrice'] as num).toDouble(),
      productCategory: json['productCategory'] as String,
      productSubCategory: json['productSubCategory'] as String,
      productBrand: json['productBrand'] as String,
      shopId: json['shopId'] as String,
      isActive: json['isActive'] as bool,
      id: json['_id'] as String,
      productDiscount: json['productDiscount'] == null
          ? null
          : ProductDiscount.fromJson(
              json['productDiscount'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'productsImage': instance.productsImage,
      'productName': instance.productName,
      'productsDescription': instance.productsDescription,
      'productsPrice': instance.productsPrice,
      'productCategory': instance.productCategory,
      'productSubCategory': instance.productSubCategory,
      'productBrand': instance.productBrand,
      'shopId': instance.shopId,
      'isActive': instance.isActive,
      '_id': instance.id,
      'productDiscount': instance.productDiscount,
    };

ProductDiscount _$ProductDiscountFromJson(Map<String, dynamic> json) =>
    ProductDiscount(
      discountPrice: (json['discountedvalue'] as num).toInt(),
      discountType: json['discounttype'] as String,
    );

Map<String, dynamic> _$ProductDiscountToJson(ProductDiscount instance) =>
    <String, dynamic>{
      'discountedvalue': instance.discountPrice,
      'discounttype': instance.discountType,
    };
