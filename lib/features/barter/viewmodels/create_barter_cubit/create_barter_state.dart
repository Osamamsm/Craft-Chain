class CreateBarterState {
  const CreateBarterState({
    this.isSendingRequest = false,
    this.requestSentSuccessfully = false,
    this.errorMessage,
    this.selectedTeachSkill,
    this.selectedLearnSkill,
  });

  /// True while sending a new barter request from the bottom sheet.
  final bool isSendingRequest;
  final bool requestSentSuccessfully;

  final String? errorMessage;

  // ── Bottom-sheet selection state ──────────────────────────────────────────
  final String? selectedTeachSkill;
  final String? selectedLearnSkill;

  bool get canSubmitRequest =>
      selectedTeachSkill != null && selectedLearnSkill != null;

  CreateBarterState copyWith({
    bool? isSendingRequest,
    bool? requestSentSuccessfully,
    String? errorMessage,
    String? selectedTeachSkill,
    String? selectedLearnSkill,
    bool clearTeachSkill = false,
    bool clearLearnSkill = false,
    bool clearError = false,
  }) {
    return CreateBarterState(
      isSendingRequest: isSendingRequest ?? this.isSendingRequest,
      requestSentSuccessfully:
          requestSentSuccessfully ?? this.requestSentSuccessfully,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedTeachSkill: clearTeachSkill
          ? null
          : (selectedTeachSkill ?? this.selectedTeachSkill),
      selectedLearnSkill: clearLearnSkill
          ? null
          : (selectedLearnSkill ?? this.selectedLearnSkill),
    );
  }
}
