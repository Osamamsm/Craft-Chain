import 'package:equatable/equatable.dart';

class BarterUser extends Equatable {
  const BarterUser({
    required this.id,
    required this.fullName,
    this.photoUrl,
    this.rating,
  });

  final String id;
  final String fullName;
  final String? photoUrl;

  final double? rating;

  String get initial {
    final name = fullName.trim();
    return name.isEmpty ? '?' : name[0].toUpperCase();
  }

  @override
  List<Object?> get props => [id, fullName, photoUrl, rating];
}
