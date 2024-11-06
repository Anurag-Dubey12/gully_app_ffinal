class VendorResponseModel {
  List<Vendors>? vendors;

  VendorResponseModel({this.vendors});

  VendorResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['vendors'] != null) {
      vendors = <Vendors>[];
      json['vendors'].forEach((v) {
        vendors!.add(new Vendors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.vendors != null) {
      data['vendors'] = this.vendors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vendors {
  String? sId;
  String? name;
  String? address;
  String? phoneNumber;
  String? email;
  String? identityProof;
  String? category;
  String? description;
  int? experience;
  int? duration;
  int? fees;
  String? serviceType;
  List<String>? serviceImages;
  bool? isVendorDeleted;
  UserId? userId;
  int? iV;

  Vendors(
      {this.sId,
        this.name,
        this.address,
        this.phoneNumber,
        this.email,
        this.identityProof,
        this.category,
        this.description,
        this.experience,
        this.duration,
        this.fees,
        this.serviceType,
        this.serviceImages,
        this.isVendorDeleted,
        this.userId,
        this.iV});

  Vendors.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    address = json['address'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    identityProof = json['identityProof'];
    category = json['category'];
    description = json['description'];
    experience = json['experience'];
    duration = json['duration'];
    fees = json['fees'];
    serviceType = json['serviceType'];
    serviceImages = json['serviceImages'].cast<String>();
    isVendorDeleted = json['isVendorDeleted'];
    userId =
    json['userId'] != null ? new UserId.fromJson(json['userId']) : null;
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['identityProof'] = this.identityProof;
    data['category'] = this.category;
    data['description'] = this.description;
    data['experience'] = this.experience;
    data['duration'] = this.duration;
    data['fees'] = this.fees;
    data['serviceType'] = this.serviceType;
    data['serviceImages'] = this.serviceImages;
    data['isVendorDeleted'] = this.isVendorDeleted;
    if (this.userId != null) {
      data['userId'] = this.userId!.toJson();
    }
    data['__v'] = this.iV;
    return data;
  }
}

class UserId {
  Location? location;
  String? sId;
  String? fullName;
  bool? isNewUser;
  bool? isLogin;
  bool? isOrganizer;
  bool? isDeleted;
  String? email;
  String? accessToken;
  String? refreshToken;
  String? fcmToken;
  String? banStatus;
  Null? banExpiresAt;
  bool? isPhoneNumberVerified;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? nickName;
  String? phoneNumber;
  String? profilePhoto;

  UserId(
      {this.location,
        this.sId,
        this.fullName,
        this.isNewUser,
        this.isLogin,
        this.isOrganizer,
        this.isDeleted,
        this.email,
        this.accessToken,
        this.refreshToken,
        this.fcmToken,
        this.banStatus,
        this.banExpiresAt,
        this.isPhoneNumberVerified,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.nickName,
        this.phoneNumber,
        this.profilePhoto});

  UserId.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    sId = json['_id'];
    fullName = json['fullName'];
    isNewUser = json['isNewUser'];
    isLogin = json['isLogin'];
    isOrganizer = json['isOrganizer'];
    isDeleted = json['isDeleted'];
    email = json['email'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    fcmToken = json['fcmToken'];
    banStatus = json['banStatus'];
    banExpiresAt = json['banExpiresAt'];
    isPhoneNumberVerified = json['isPhoneNumberVerified'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    nickName = json['nickName'];
    phoneNumber = json['phoneNumber'];
    profilePhoto = json['profilePhoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['_id'] = this.sId;
    data['fullName'] = this.fullName;
    data['isNewUser'] = this.isNewUser;
    data['isLogin'] = this.isLogin;
    data['isOrganizer'] = this.isOrganizer;
    data['isDeleted'] = this.isDeleted;
    data['email'] = this.email;
    data['accessToken'] = this.accessToken;
    data['refreshToken'] = this.refreshToken;
    data['fcmToken'] = this.fcmToken;
    data['banStatus'] = this.banStatus;
    data['banExpiresAt'] = this.banExpiresAt;
    data['isPhoneNumberVerified'] = this.isPhoneNumberVerified;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['nickName'] = this.nickName;
    data['phoneNumber'] = this.phoneNumber;
    data['profilePhoto'] = this.profilePhoto;
    return data;
  }
}

class Location {
  String? type;
  List<double>? coordinates;
  String? selectLocation;

  Location({this.type, this.coordinates, this.selectLocation});

  Location.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
    selectLocation = json['selectLocation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    data['selectLocation'] = this.selectLocation;
    return data;
  }
}
