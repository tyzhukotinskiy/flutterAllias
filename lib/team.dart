import 'model.dart';

class Team extends Model {

  static String table = 'team';

  int id;
  String name;
  int points;
  int next;

  Team({ this.id, this.name, this.points, this.next });

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      'name': name,
      'points': points,
      'next': next
    };

    if (id != null) { map['id'] = id; }
    return map;
  }

  static Team fromMap(Map<String, dynamic> map) {

    return Team(
        id: map['id'],
        name: map['name'],
        points: map['points'],
        next: map['next']
    );
  }
}
