import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/remote_service.dart';

class EmpresaSubmitState {
  final bool isLoading;
  final String? error;
  final int? empresaId;
  final String estadoRevision;

  const EmpresaSubmitState({
    this.isLoading = false,
    this.error,
    this.empresaId,
    this.estadoRevision = 'pendiente',
  });

  EmpresaSubmitState copyWith({
    bool? isLoading,
    String? error,
    int? empresaId,
    String? estadoRevision,
  }) =>
      EmpresaSubmitState(
        isLoading: isLoading ?? this.isLoading,
        error: error,
        empresaId: empresaId ?? this.empresaId,
        estadoRevision: estadoRevision ?? this.estadoRevision,
      );
}

class EmpresaNotifier extends StateNotifier<EmpresaSubmitState> {
  EmpresaNotifier() : super(const EmpresaSubmitState());

  Future<bool> submitStep1(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await RemoteService().crearEmpresa(data);
      state = state.copyWith(isLoading: false, empresaId: result['id'] as int);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> submitStep2(Map<String, dynamic> data) async {
    if (state.empresaId == null) return false;
    state = state.copyWith(isLoading: true);
    try {
      final result = await RemoteService()
          .actualizarDocumentacion(state.empresaId!, data);
      state = state.copyWith(
        isLoading: false,
        estadoRevision: result['estado_revision'] as String,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final empresaNotifierProvider =
    StateNotifierProvider.autoDispose<EmpresaNotifier, EmpresaSubmitState>(
  (ref) => EmpresaNotifier(),
);
