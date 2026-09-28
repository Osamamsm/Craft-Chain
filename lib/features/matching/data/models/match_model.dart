import '../../domain/entities/match_entity.dart';
import 'skill_model.dart';

class MatchModel extends MatchEntity {
  const MatchModel({
    required super.userId,
    required super.fullName,
    super.photoUrl,
    super.city,
    required super.rating,
    required super.barterCount,
    required super.matchPercent,
    required super.teaches,
    required super.wantsToLearn,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String,
      photoUrl: json['photo_url'] as String?,
      city: json['city'] as String?,
      // numeric can arrive as int, double, or String depending on the value
      rating: double.tryParse(json['rating'].toString()) ?? 0,
      barterCount: (json['barter_count'] as num?)?.toInt() ?? 0,
      matchPercent: (json['match_percent'] as num?)?.toInt() ?? 0,
      teaches: _parseSkills(json['teaches']),
      wantsToLearn: _parseSkills(json['wants_to_learn']),
    );
  }

  static List<SkillModel> _parseSkills(dynamic raw) {
    if (raw == null) return const [];
    return (raw as List)
        .map((e) => SkillModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'full_name': fullName,
    'photo_url': photoUrl,
    'city': city,
    'rating': rating,
    'barter_count': barterCount,
    'match_percent': matchPercent,
    'teaches': teaches.map((e) => (e as SkillModel).toJson()).toList(),
    'wants_to_learn': wantsToLearn
        .map((e) => (e as SkillModel).toJson())
        .toList(),
  };
}
