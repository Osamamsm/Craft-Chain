import 'dart:io';

class CompleteProfileParams {
  final String fullName;
  final String gender;
  final String city;
  final String bio;
  final List<CompleteProfileSkillParams> teachingSkills;
  final List<CompleteProfileSkillParams> learningSkills;
  final File photo;

  const CompleteProfileParams({
    required this.fullName,
    required this.gender,
    required this.city,
    required this.bio,
    required this.teachingSkills,
    required this.learningSkills,
    required this.photo,
  });
}

class CompleteProfileSkillParams {
  final int skillId;
  final String? proficiency;
  final double? yearsOfExperience;

  const CompleteProfileSkillParams({
    required this.skillId,
    this.proficiency,
    this.yearsOfExperience,
  });
}
