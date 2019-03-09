import 'package:meta/meta.dart';
import 'package:weekplanner/models/access_level_enum.dart';
import 'package:weekplanner/models/model.dart';

class PictogramModel implements Model {
  int id;

  /// The last time the pictogram was edited.
  DateTime lastEdit;

  /// The title of the pictogram.
  String title;

  /// The accesslevel of the pictogram.
  AccessLevel accessLevel;

  String imageUrl;

  String imageHash;

  PictogramModel({
    @required this.id,
    @required this.lastEdit,
    @required this.title,
    @required this.accessLevel,
    @required this.imageUrl,
    @required this.imageHash,
  });

  PictogramModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw FormatException("[PictogramModel]: Cannot initialize from null");
    }

    id = json['id'];
    lastEdit =
        json['lastEdit'] == null ? null : DateTime.parse(json['lastEdit']);
    title = json['title'];
    accessLevel = AccessLevel.values[(json['accessLevel'] as int) -1];
    imageUrl = json['imageUrl'];
    imageHash = json['imageHash'];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lastEdit': lastEdit == null ? '' : lastEdit.toIso8601String(),
      'title': title,
      'accessLevel': accessLevel.index + 1,
      'imageUrl': imageUrl,
      'imageHash': imageHash
    };
  }
}
