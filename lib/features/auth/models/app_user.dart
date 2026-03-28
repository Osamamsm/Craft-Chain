class AppUser {
  const AppUser({
    required this.uid,
    required this.name,
    required this.city,
    required this.gender,
    required this.canTeach,
    required this.wantsToLearn,
    required this.rating,
    required this.barterCount,
    this.photoUrl,
    this.bio = '',
    this.isProfileComplete = false,
    this.isActive = true,
  });

  final String uid;
  final String name;
  final String? photoUrl;
  final String gender;
  final String city;
  final String bio;
  final List<String> canTeach;
  final List<String> wantsToLearn;
  final double rating;
  final int barterCount;
  final bool isProfileComplete;
  final bool isActive;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  AppUser copyWith({
    String? uid,
    String? name,
    String? city,
    String? gender,
    List<String>? canTeach,
    List<String>? wantsToLearn,
    double? rating,
    int? barterCount,
    String? photoUrl,
    String? bio,
    bool? isProfileComplete,
    bool? isActive,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      city: city ?? this.city,
      gender: gender ?? this.gender,
      canTeach: canTeach ?? this.canTeach,
      wantsToLearn: wantsToLearn ?? this.wantsToLearn,
      rating: rating ?? this.rating,
      barterCount: barterCount ?? this.barterCount,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      isActive: isActive ?? this.isActive,
    );
  }

  static const AppUser placeholder = AppUser(
    uid: 'placeholder',
    name: 'Loading User Name',
    city: 'Some City, Country',
    gender: 'male',
    bio:
        'This is a placeholder bio text used for the skeleton loading animation. It has enough length to fill a few lines.',
    canTeach: ['Skill One', 'Skill Two', 'Skill Three'],
    wantsToLearn: ['Learn Skill A', 'Learn Skill B'],
    rating: 4.5,
    barterCount: 8,
  );

  // TODO(task-02b): Timestamp fields will use [FieldValue.serverTimestamp()].
  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    uid: json['uid'] as String,
    name: json['name'] as String,
    city: json['city'] as String,
    gender: json['gender'] as String,
    canTeach: List<String>.from(json['canTeach'] as List),
    wantsToLearn: List<String>.from(json['wantsToLearn'] as List),
    rating: (json['rating'] as num).toDouble(),
    barterCount: json['barterCount'] as int,
    photoUrl: json['photoUrl'] as String?,
    bio: json['bio'] as String? ?? '',
    isProfileComplete: json['isProfileComplete'] as bool? ?? false,
    isActive: json['isActive'] as bool? ?? true,
  );

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'city': city,
    'gender': gender,
    'canTeach': canTeach,
    'wantsToLearn': wantsToLearn,
    'rating': rating,
    'barterCount': barterCount,
    if (photoUrl != null) 'photoUrl': photoUrl,
    'bio': bio,
    'isProfileComplete': isProfileComplete,
    'isActive': isActive,
  };
}
