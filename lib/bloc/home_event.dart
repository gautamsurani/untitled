abstract class HomeEvent {}

class GetSymbols extends HomeEvent {}

class GetSymbolDetail extends HomeEvent {
  String? code;
  GetSymbolDetail(String code){
    this.code = code;
  }
}
