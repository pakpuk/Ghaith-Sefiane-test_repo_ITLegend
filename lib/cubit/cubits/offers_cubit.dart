import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:marketplace_app/Model/offer_model.dart';
import 'package:marketplace_app/db/database.dart';

/// Offers State
abstract class OffersState extends Equatable {
  const OffersState();

  @override
  List<Object?> get props => [];
}

class OffersInitial extends OffersState {
  const OffersInitial();
}

class OffersLoading extends OffersState {
  const OffersLoading();
}

class OffersLoaded extends OffersState {
  final List<Offer> offers;
  final String selectedFilter;

  const OffersLoaded({
    required this.offers,
    this.selectedFilter = 'الكل',
  });

  OffersLoaded copyWith({
    List<Offer>? offers,
    String? selectedFilter,
  }) {
    return OffersLoaded(
      offers: offers ?? this.offers,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  @override
  List<Object?> get props => [offers, selectedFilter];
}

class OffersError extends OffersState {
  final String message;

  const OffersError(this.message);

  @override
  List<Object> get props => [message];
}

class OffersEmpty extends OffersState {
  const OffersEmpty();
}

/// Offers Cubit
class OffersCubit extends Cubit<OffersState> {
  final DatabaseHelper _dbHelper;

  OffersCubit(this._dbHelper) : super(const OffersInitial());

  Future<void> loadOffers() async {
    try {
      emit(const OffersLoading());

      debugPrint('🔄 [OffersCubit] Loading offers...');

      final offersData = await _dbHelper.getAllOffers();
      final offers = offersData.map((data) => Offer.fromMap(data)).toList();

      debugPrint('✅ [OffersCubit] Loaded ${offers.length} offers');

      if (offers.isEmpty) {
        emit(const OffersEmpty());
      } else {
        emit(OffersLoaded(offers: offers));
      }
    } catch (e) {
      debugPrint('❌ [OffersCubit] Error loading offers: $e');
      emit(OffersError('فشل تحميل العروض: $e'));
    }
  }

  Future<void> filterOffers(String filterType) async {
    if (state is! OffersLoaded) return;

    final currentState = state as OffersLoaded;

    debugPrint('🔍 [OffersCubit] Filtering offers by: $filterType');

    emit(currentState.copyWith(selectedFilter: filterType));
  }

  Future<void> refreshOffers() async {
    debugPrint('🔄 [OffersCubit] Refreshing offers...');
    await loadOffers();
  }
}
