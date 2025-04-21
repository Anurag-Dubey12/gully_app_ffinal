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
    };
