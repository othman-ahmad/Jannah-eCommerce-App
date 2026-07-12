import 'package:jannah/features/home_page/data/promotion_model.dart';

enum PromotionsStatus { initial, loading, success, failure }

class PromotionsState {
  final PromotionsStatus promotionsStatus;
  final List<Promotion> promotions;
  final String? errorMessage;

  const PromotionsState({
    this.promotionsStatus = PromotionsStatus.initial,
    this.promotions = const [],
    this.errorMessage,
  });

  PromotionsState copyWith({
    PromotionsStatus? promotionsStatus,
    List<Promotion>? promotions,
    String? errorMessage,
  }) {
    return PromotionsState(
      promotionsStatus: promotionsStatus ?? this.promotionsStatus,
      promotions: promotions ?? this.promotions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
