import 'package:equatable/equatable.dart';

class BarterActionResult extends Equatable {
  const BarterActionResult({required this.success, required this.message});

  final bool success;
  final String message;

  @override
  List<Object?> get props => [success, message];
}
