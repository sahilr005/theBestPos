class EatInItemModel {
  List<Eatitems>? eatitems;

  EatInItemModel({this.eatitems});

  EatInItemModel.fromJson(Map<String, dynamic> json) {
    if (json['eatitems'] != null) {
      eatitems = <Eatitems>[];
      json['eatitems'].forEach((v) {
        eatitems!.add(new Eatitems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.eatitems != null) {
      data['eatitems'] = this.eatitems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Eatitems {
  String? itemid;
  String? itemname;
  String? usedInEatin;

  Eatitems({this.itemid, this.itemname, this.usedInEatin});

  Eatitems.fromJson(Map<String, dynamic> json) {
    itemid = json['itemid'];
    itemname = json['itemname'];
    usedInEatin = json['used_in_eatin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemid'] = this.itemid;
    data['itemname'] = this.itemname;
    data['used_in_eatin'] = this.usedInEatin;
    return data;
  }
}
