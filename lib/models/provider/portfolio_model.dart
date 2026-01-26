class PortfolioModel {
  String? id;
  String? providerId;
  String? title;
  String? beforeImage;
  String? afterImage;
  String? about;
  String? serviceType;
  int? displayOrder;
  bool? isActive;

  PortfolioModel({
    this.id,
    this.providerId,
    this.title,
    this.beforeImage,
    this.afterImage,
    this.about,
    this.serviceType,
    this.displayOrder,
    this.isActive,
  });

  PortfolioModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? json['id'];
    providerId = json['providerId'];
    title = json['title'];
    beforeImage = json['beforeImage'];
    afterImage = json['afterImage'];
    about = json['about'];
    serviceType = json['serviceType'];
    displayOrder = json['displayOrder'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    // beforeImage and afterImage are usually handled via multipart requests, 
    // but for completeness in model we keep them.
    data['about'] = about;
    data['serviceType'] = serviceType;
    return data;
  }
}
