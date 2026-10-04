import 'package:equatable/equatable.dart';

class MeetingPlatform extends Equatable {
  const MeetingPlatform({required this.id, required this.name, this.icon});

  final String id;
  final String name;
  final String? icon;

  @override
  List<Object?> get props => [id, name, icon];
}
