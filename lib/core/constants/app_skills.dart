
class SkillCategory {
  const SkillCategory({required this.nameKey, required this.skills});

  final String nameKey;
  final List<String> skills;
}

class AppSkills {
  AppSkills._();

  static const List<SkillCategory> all = [
    SkillCategory(
      nameKey: 'profile.category_tech',
      skills: [
        'Flutter',
        'Dart',
        'Firebase',
        'React',
        'Node.js',
        'Python',
        'Swift',
        'Kotlin',
        'ML / AI',
        'Data Science',
        'UI/UX',
        'TypeScript',
        'Vue.js',
      ],
    ),
    SkillCategory(
      nameKey: 'profile.category_design',
      skills: [
        'Figma',
        'Illustrator',
        'Photoshop',
        'Branding',
        '3D Modeling',
        'Motion Design',
        'Sketch',
        'After Effects',
      ],
    ),
    SkillCategory(
      nameKey: 'profile.category_creative',
      skills: [
        'Calligraphy',
        'Photography',
        'Video Editing',
        'Music',
        'Drawing',
        'Animation',
        'Painting',
        'Podcasting',
      ],
    ),
    SkillCategory(
      nameKey: 'profile.category_language',
      skills: [
        'English',
        'Arabic',
        'French',
        'Spanish',
        'German',
        'Chinese',
        'Italian',
        'Japanese',
      ],
    ),
    SkillCategory(
      nameKey: 'profile.category_business',
      skills: [
        'Marketing',
        'SEO',
        'Copywriting',
        'Project Management',
        'Entrepreneurship',
        'Finance',
        'Public Speaking',
        'Sales',
      ],
    ),
  ];

  /// Returns all skills flattened into a single list.
  static List<String> get flat =>
      all.expand((cat) => cat.skills).toList();
}
