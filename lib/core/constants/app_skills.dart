class Skill {
  const Skill({
    required this.id,
    required this.name,
    this.description,
  });

  final int id;
  final String name;
  final String? description;
}

class SkillCategory {
  const SkillCategory({
    required this.id,
    required this.nameKey,
    required this.skills,
  });

  final int id;
  final String nameKey;
  final List<Skill> skills;
}

class AppSkills {
  AppSkills._();

  static const List<SkillCategory> all = [
    // =========================================================
    // TECHNOLOGY - category_id: 1
    // =========================================================
    SkillCategory(
      id: 1,
      nameKey: 'profile.category_tech',
      skills: [
        Skill(
          id: 1,
          name: 'Flutter',
          description:
              'Cross-platform mobile application development with Flutter.',
        ),
        Skill(
          id: 2,
          name: 'Dart',
          description: 'Programming with the Dart language.',
        ),
        Skill(
          id: 3,
          name: 'Java',
          description: 'Java programming and application development.',
        ),
        Skill(
          id: 4,
          name: 'Python',
          description: 'Python programming and application development.',
        ),
        Skill(
          id: 5,
          name: 'JavaScript',
          description: 'JavaScript programming for web applications.',
        ),
        Skill(
          id: 6,
          name: 'TypeScript',
          description:
              'TypeScript programming for scalable applications.',
        ),
        Skill(
          id: 7,
          name: 'React',
          description: 'Frontend development using React.',
        ),
        Skill(
          id: 8,
          name: 'Node.js',
          description: 'Backend development using Node.js.',
        ),
        Skill(
          id: 9,
          name: 'SQL',
          description:
              'Working with relational databases and SQL queries.',
        ),
        Skill(
          id: 10,
          name: 'Git & GitHub',
          description:
              'Version control and collaborative development using Git and GitHub.',
        ),
        Skill(
          id: 11,
          name: 'UI Development',
          description:
              'Building user interfaces for web or mobile applications.',
        ),
        Skill(
          id: 12,
          name: 'Backend Development',
          description:
              'Building APIs, services, and backend systems.',
        ),
        Skill(
          id: 13,
          name: 'Database Design',
          description:
              'Designing relational and non-relational databases.',
        ),
        Skill(
          id: 14,
          name: 'Cybersecurity',
          description:
              'Security principles, secure systems, and application security.',
        ),
        Skill(
          id: 15,
          name: 'Cloud Computing',
          description:
              'Cloud platforms and cloud-based application development.',
        ),
      ],
    ),

    // =========================================================
    // LANGUAGES - category_id: 2
    // =========================================================
    SkillCategory(
      id: 2,
      nameKey: 'profile.category_language',
      skills: [
        Skill(
          id: 16,
          name: 'English',
        ),
        Skill(
          id: 17,
          name: 'Arabic',
        ),
        Skill(
          id: 18,
          name: 'French',
        ),
        Skill(
          id: 19,
          name: 'German',
        ),
        Skill(
          id: 20,
          name: 'Spanish',
        ),
        Skill(
          id: 21,
          name: 'Italian',
        ),
        Skill(
          id: 22,
          name: 'Turkish',
        ),
        Skill(
          id: 23,
          name: 'Chinese',
        ),
        Skill(
          id: 24,
          name: 'Japanese',
        ),
        Skill(
          id: 25,
          name: 'Korean',
        ),
      ],
    ),

    // =========================================================
    // BUSINESS - category_id: 3
    // =========================================================
    SkillCategory(
      id: 3,
      nameKey: 'profile.category_business',
      skills: [
        Skill(
          id: 26,
          name: 'Entrepreneurship',
        ),
        Skill(
          id: 27,
          name: 'Project Management',
        ),
        Skill(
          id: 28,
          name: 'Business Strategy',
        ),
        Skill(
          id: 29,
          name: 'Leadership',
        ),
        Skill(
          id: 30,
          name: 'Negotiation',
        ),
        Skill(
          id: 31,
          name: 'Sales',
        ),
        Skill(
          id: 32,
          name: 'Customer Service',
        ),
        Skill(
          id: 33,
          name: 'Public Speaking',
        ),
        Skill(
          id: 34,
          name: 'Communication',
        ),
        Skill(
          id: 35,
          name: 'Time Management',
        ),
      ],
    ),

    // =========================================================
    // DESIGN - category_id: 4
    // =========================================================
    SkillCategory(
      id: 4,
      nameKey: 'profile.category_design',
      skills: [
        Skill(
          id: 36,
          name: 'UI/UX Design',
        ),
        Skill(
          id: 37,
          name: 'Graphic Design',
        ),
        Skill(
          id: 38,
          name: 'Figma',
        ),
        Skill(
          id: 39,
          name: 'Adobe Photoshop',
        ),
        Skill(
          id: 40,
          name: 'Adobe Illustrator',
        ),
        Skill(
          id: 41,
          name: 'Brand Identity',
        ),
        Skill(
          id: 42,
          name: 'Motion Design',
        ),
        Skill(
          id: 43,
          name: '3D Design',
        ),
      ],
    ),

    // =========================================================
    // MARKETING - category_id: 5
    // =========================================================
    SkillCategory(
      id: 5,
      nameKey: 'profile.category_marketing',
      skills: [
        Skill(
          id: 44,
          name: 'Digital Marketing',
        ),
        Skill(
          id: 45,
          name: 'Social Media Marketing',
        ),
        Skill(
          id: 46,
          name: 'Content Marketing',
        ),
        Skill(
          id: 47,
          name: 'SEO',
        ),
        Skill(
          id: 48,
          name: 'Copywriting',
        ),
        Skill(
          id: 49,
          name: 'Email Marketing',
        ),
        Skill(
          id: 50,
          name: 'Advertising',
        ),
      ],
    ),

    // =========================================================
    // MUSIC - category_id: 6
    // =========================================================
    SkillCategory(
      id: 6,
      nameKey: 'profile.category_music',
      skills: [
        Skill(
          id: 51,
          name: 'Guitar',
        ),
        Skill(
          id: 52,
          name: 'Piano',
        ),
        Skill(
          id: 53,
          name: 'Singing',
        ),
        Skill(
          id: 54,
          name: 'Music Production',
        ),
        Skill(
          id: 55,
          name: 'Music Theory',
        ),
        Skill(
          id: 56,
          name: 'Drums',
        ),
      ],
    ),

    // =========================================================
    // PHOTOGRAPHY & VIDEO - category_id: 7
    // =========================================================
    SkillCategory(
      id: 7,
      nameKey: 'profile.category_photography_video',
      skills: [
        Skill(
          id: 57,
          name: 'Photography',
        ),
        Skill(
          id: 58,
          name: 'Portrait Photography',
        ),
        Skill(
          id: 59,
          name: 'Video Editing',
        ),
        Skill(
          id: 60,
          name: 'Videography',
        ),
        Skill(
          id: 61,
          name: 'Adobe Premiere Pro',
        ),
        Skill(
          id: 62,
          name: 'After Effects',
        ),
      ],
    ),

    // =========================================================
    // WRITING - category_id: 8
    // =========================================================
    SkillCategory(
      id: 8,
      nameKey: 'profile.category_writing',
      skills: [
        Skill(
          id: 63,
          name: 'Creative Writing',
        ),
        Skill(
          id: 64,
          name: 'Technical Writing',
        ),
        Skill(
          id: 65,
          name: 'Blogging',
        ),
        Skill(
          id: 66,
          name: 'Storytelling',
        ),
        Skill(
          id: 67,
          name: 'Proofreading',
        ),
      ],
    ),

    // =========================================================
    // EDUCATION - category_id: 9
    // =========================================================
    SkillCategory(
      id: 9,
      nameKey: 'profile.category_education',
      skills: [
        Skill(
          id: 68,
          name: 'Mathematics',
        ),
        Skill(
          id: 69,
          name: 'Physics',
        ),
        Skill(
          id: 70,
          name: 'Chemistry',
        ),
        Skill(
          id: 71,
          name: 'Biology',
        ),
        Skill(
          id: 72,
          name: 'Tutoring',
        ),
        Skill(
          id: 73,
          name: 'Study Skills',
        ),
      ],
    ),

    // =========================================================
    // CRAFTS & DIY - category_id: 10
    // =========================================================
    SkillCategory(
      id: 10,
      nameKey: 'profile.category_crafts_diy',
      skills: [
        Skill(
          id: 74,
          name: 'Woodworking',
        ),
        Skill(
          id: 75,
          name: 'Drawing',
        ),
        Skill(
          id: 76,
          name: 'Painting',
        ),
        Skill(
          id: 77,
          name: 'Knitting',
        ),
        Skill(
          id: 78,
          name: 'Sewing',
        ),
        Skill(
          id: 79,
          name: 'Handmade Crafts',
        ),
      ],
    ),

    // =========================================================
    // COOKING - category_id: 11
    // =========================================================
    SkillCategory(
      id: 11,
      nameKey: 'profile.category_cooking',
      skills: [
        Skill(
          id: 80,
          name: 'Cooking',
        ),
        Skill(
          id: 81,
          name: 'Baking',
        ),
        Skill(
          id: 82,
          name: 'Desserts',
        ),
        Skill(
          id: 83,
          name: 'Meal Preparation',
        ),
      ],
    ),

    // =========================================================
    // FITNESS & SPORTS - category_id: 12
    // =========================================================
    SkillCategory(
      id: 12,
      nameKey: 'profile.category_fitness_sports',
      skills: [
        Skill(
          id: 84,
          name: 'Football',
        ),
        Skill(
          id: 85,
          name: 'Basketball',
        ),
        Skill(
          id: 86,
          name: 'Swimming',
        ),
        Skill(
          id: 87,
          name: 'Running',
        ),
        Skill(
          id: 88,
          name: 'Yoga',
        ),
        Skill(
          id: 89,
          name: 'Weight Training',
        ),
        Skill(
          id: 90,
          name: 'Tennis',
        ),
      ],
    ),

    // =========================================================
    // PERSONAL DEVELOPMENT - category_id: 13
    // =========================================================
    SkillCategory(
      id: 13,
      nameKey: 'profile.category_personal_development',
      skills: [
        Skill(
          id: 91,
          name: 'Leadership',
        ),
        Skill(
          id: 92,
          name: 'Communication Skills',
        ),
        Skill(
          id: 93,
          name: 'Presentation Skills',
        ),
        Skill(
          id: 94,
          name: 'Problem Solving',
        ),
        Skill(
          id: 95,
          name: 'Critical Thinking',
        ),
        Skill(
          id: 96,
          name: 'Career Development',
        ),
      ],
    ),

    // =========================================================
    // FINANCE - category_id: 14
    // =========================================================
    SkillCategory(
      id: 14,
      nameKey: 'profile.category_finance',
      skills: [
        Skill(
          id: 97,
          name: 'Personal Finance',
        ),
        Skill(
          id: 98,
          name: 'Accounting',
        ),
        Skill(
          id: 99,
          name: 'Budgeting',
        ),
        Skill(
          id: 100,
          name: 'Financial Analysis',
        ),
        Skill(
          id: 101,
          name: 'Investing',
        ),
      ],
    ),

    // =========================================================
    // OTHER - category_id: 15
    // =========================================================
    SkillCategory(
      id: 15,
      nameKey: 'profile.category_other',
      skills: [],
    ),
  ];

  /// Returns all skills flattened into a single list.
  static List<Skill> get flat =>
      all.expand((category) => category.skills).toList();
}