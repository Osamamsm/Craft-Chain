class SkillUpdateEntity {
  final int skillId;
  final String? proficiency;
  final double? yearsOfExperience;

  const SkillUpdateEntity({
    required this.skillId,
    this.proficiency,
    this.yearsOfExperience,
  });
}
