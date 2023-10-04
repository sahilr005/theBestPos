class HolidayStatusModel {
  String? status;
  String? title;
  String? description;

  HolidayStatusModel({this.status, this.title, this.description});

  HolidayStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}
