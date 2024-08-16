import 'package:beni2_sqflit/db/constants.dart';

class Note {
  int? id;
  String text = '';
  String createdDate = '';
  String? updatedDate;
  int? color;

  Note(
      {this.id,
      required this.text,
      required this.createdDate,
      this.updatedDate,
      this.color});

  //convert object to map
  Map<String, dynamic> toMap() => {
        colId: id,
        colText: text,
        colDate: createdDate,
        colUpdatedDate: updatedDate,
        colColor: color
      };

  //convert map to object
  Note.formMap(Map<String, dynamic> map) {
    id = map[colId];
    text = map[colText];
    createdDate = map[colDate];
    updatedDate = map[colUpdatedDate];
    color = map[colColor];
  }
}
