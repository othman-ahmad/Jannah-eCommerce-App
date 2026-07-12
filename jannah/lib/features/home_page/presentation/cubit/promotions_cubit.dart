import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jannah/features/home_page/domain/usecases/get_promotions.dart';
import 'package:jannah/features/home_page/presentation/cubit/promotions_state.dart';

class PromotionsCubit extends Cubit<PromotionsState> {
  final GetPromotions getPromotions;

  PromotionsCubit({required this.getPromotions})
    : super(const PromotionsState());

  Future<void> loadPromotions() async {
    emit(state.copyWith(promotionsStatus: PromotionsStatus.loading));

    try {
      final promotions = await getPromotions();
      emit(
        state.copyWith(
          promotionsStatus: PromotionsStatus.success,
          promotions: promotions,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          promotionsStatus: PromotionsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
