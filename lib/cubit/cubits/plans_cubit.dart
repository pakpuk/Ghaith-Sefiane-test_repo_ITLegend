import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

/// Plans State
abstract class PlansState extends Equatable {
  const PlansState();

  @override
  List<Object?> get props => [];
}

class PlansInitial extends PlansState {
  const PlansInitial();
}

class PlansLoaded extends PlansState {
  final List<int> selectedPlanIds;

  const PlansLoaded({this.selectedPlanIds = const []});

  PlansLoaded copyWith({List<int>? selectedPlanIds}) {
    return PlansLoaded(
      selectedPlanIds: selectedPlanIds ?? this.selectedPlanIds,
    );
  }

  bool isPlanSelected(int planId) => selectedPlanIds.contains(planId);

  int get selectedCount => selectedPlanIds.length;

  bool get hasSelection => selectedPlanIds.isNotEmpty;

  @override
  List<Object?> get props => [selectedPlanIds];
}

/// Plans Cubit
class PlansCubit extends Cubit<PlansState> {
  PlansCubit() : super(const PlansInitial());

  void initialize() {
    emit(const PlansLoaded());
  }

  void togglePlan(int planId) {
    if (state is! PlansLoaded) return;

    final currentState = state as PlansLoaded;
    final selectedIds = List<int>.from(currentState.selectedPlanIds);

    if (selectedIds.contains(planId)) {
      selectedIds.remove(planId);
      debugPrint('❌ [PlansCubit] Deselected plan: $planId');
    } else {
      selectedIds.add(planId);
      debugPrint('✅ [PlansCubit] Selected plan: $planId');
    }

    emit(currentState.copyWith(selectedPlanIds: selectedIds));
  }

  void clearSelection() {
    debugPrint('🔄 [PlansCubit] Clearing all selections');
    emit(const PlansLoaded());
  }

  void selectMultiple(List<int> planIds) {
    debugPrint('✅ [PlansCubit] Selecting ${planIds.length} plans');
    emit(PlansLoaded(selectedPlanIds: planIds));
  }
}
