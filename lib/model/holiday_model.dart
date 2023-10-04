class HolidayModel {
  List<Holidays>? holidays;

  HolidayModel({this.holidays});

  HolidayModel.fromJson(Map<String, dynamic> json) {
    if (json['holidays'] != null) {
      holidays = <Holidays>[];
      json['holidays'].forEach((v) {
        holidays!.add(new Holidays.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.holidays != null) {
      data['holidays'] = this.holidays!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Holidays {
  String? id;
  String? fdt;
  String? tdt;

  Holidays({this.id, this.fdt, this.tdt});

  Holidays.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fdt = json['fdt'];
    tdt = json['tdt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fdt'] = this.fdt;
    data['tdt'] = this.tdt;
    return data;
  }
}
