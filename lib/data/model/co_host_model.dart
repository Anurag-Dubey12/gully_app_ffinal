import 'package:json_annotation/json_annotation.dart';

part 'co_host_model.g.dart';

@JsonSerializable(createToJson: false)
class CoHostModel {
  @JsonKey(name: '_id')
  final String id;
  final String fullName;
  final String phoneNumber;

  CoHostModel(
      {required this.id, required this.fullName, required this.phoneNumber});

  factory CoHostModel.fromJson(Map<String, dynamic> json) =>
      _$CoHostModelFromJson(json);
}
