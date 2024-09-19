import 'dart:ui';
import 'package:json_annotation/json_annotation.dart';
//
// part 'package_model.g.dart';
//
// @JsonSerializable()
class PackageModel{
  final String name;
  final String duration;
  final double price;
  final String endDate;
  // final Color color;

  PackageModel({
    required this.name,
    required this.duration,
    required this.price,
    required this.endDate,
    // required this.color,
  });

  factory PackageModel.fromMap(Map<String, dynamic> map) {
    return PackageModel(
      name: map['package'] as String,
      duration: map['Duration'] as String,
      price: (map['price'] as num).toDouble(),
      endDate: map['EndDate'] as String,
      // color: Color(map['color'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'package': name,
      'Duration': duration,
      'price': price,
      'EndDate': endDate,
      // 'color': color.value,

    };
  }

  @override
  String toString() {
    return '$name - $duration - ₹$price';
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PackageModel &&
        other.name == name &&
        other.duration == duration &&
        other.price == price &&
        other.endDate == endDate ;
        // other.color == color;

  }
  @override
  int get hashCode => name.hashCode ^ duration.hashCode ^ price.hashCode ;

  // PackageModel copyWith({
  //   String? name,
  //   String? duration,
  //   double? price,
  //   Color? color,
  // }) {
  //   return PackageModel(
  //     name: name ?? this.name,
  //     duration: duration ?? this.duration,
  //     price: price ?? this.price,
  //     // color: color ?? this.color,
  //   );
  // }
}