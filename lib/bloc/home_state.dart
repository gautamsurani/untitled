import 'package:untitled/api/rest_client.dart';

class HomeState {
  SymbolModel? symbols;
  SymbolDetail? symbolDetail;
  bool loading;
  String? errorMessage;

  HomeState({
    required this.loading,
    required this.symbols,
    required this.symbolDetail,
    required this.errorMessage,
  });

  factory HomeState.initial() {
    return HomeState(
      loading: false,
      symbols: null,
      symbolDetail: null,
      errorMessage: null,
    );
  }
}