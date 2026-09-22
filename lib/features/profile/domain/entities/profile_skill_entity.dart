import 'package:equatable/equatable.dart';

enum SkillDirection { teaching, learning }

enum ProficiencyLevel { beginner, intermediate, advanced, expert }

extension ProficiencyLevelX on ProficiencyLevel {
  static ProficiencyLevel? fromString(String? value) {
    if (value == null) return null;
    return ProficiencyLevel.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError('Unknown proficiency: $value'),
    );
  }
}

class ProfileSkillEntity extends Equatable {
  final int skillId;
  final String name;
  final int categoryId;
  final ProficiencyLevel? proficiency;
  final double? yearsOfExperience;

  const ProfileSkillEntity({
    required this.skillId,
    required this.name,
    required this.categoryId,
    this.proficiency,
    this.yearsOfExperience,
  });

  @override
  List<Object?> get props => [
    skillId,
    name,
    categoryId,
    proficiency,
    yearsOfExperience,
  ];
}
