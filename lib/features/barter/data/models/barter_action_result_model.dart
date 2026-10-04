import 'package:craft_chain/features/barter/domain/entities/barter_action_result.dart';

class BarterActionResultModel extends BarterActionResult {
  const BarterActionResultModel({
    required super.success,
    required super.message,
  });

  factory BarterActionResultModel.fromJson(Map<String, dynamic> json) =>
      BarterActionResultModel(
        success: json['success'] as bool,
        message: json['message'] as String,
      );
}
