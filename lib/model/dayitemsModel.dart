class DayitemsModel {
  List<Dayitems>? dayitems;

  DayitemsModel({this.dayitems});

  DayitemsModel.fromJson(Map<String, dynamic> json) {
    if (json['dayitems'] != null) {
      dayitems = <Dayitems>[];
      json['dayitems'].forEach((v) {
        dayitems!.add(new Dayitems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dayitems != null) {
      data['dayitems'] = this.dayitems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dayitems {
  String? itemid;
  String? itemname;
  String? daystr;

  Dayitems({this.itemid, this.itemname, this.daystr});

  Dayitems.fromJson(Map<String, dynamic> json) {
    itemid = json['itemid'];
    itemname = json['itemname'];
    daystr = json['daystr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemid'] = this.itemid;
    data['itemname'] = this.itemname;
    data['daystr'] = this.daystr;
    return data;
  }
}
