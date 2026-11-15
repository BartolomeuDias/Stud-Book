enum LoadStatus {
  initial,
  loading,
  success,
  failure;

  bool get isLoading => this == LoadStatus.initial || this == LoadStatus.loading;
  bool get isSuccess => this == LoadStatus.success;
  bool get isFailure => this == LoadStatus.failure;
}

enum SubmitStatus {
  idle,
  submitting,
  success,
  failure;

  bool get isSubmitting => this == SubmitStatus.submitting;
}
