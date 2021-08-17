import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/api/rest_client.dart';
import 'package:untitled/bloc/home_event.dart';
import 'package:untitled/bloc/home_state.dart';
import 'package:untitled/constant/locale_constant.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final client = RestClient(Dio(BaseOptions(contentType: "application/json")));

  HomeBloc() : super( HomeState.initial());

  void callSymbols() {
    add(GetSymbols());
  }

  void callSymbolDetail(String code) {
    add(GetSymbolDetail(code));
  }

  @override
  HomeState get initialState => HomeState.initial();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is GetSymbols) {
      yield HomeState(
          loading: true,
          symbols: state.symbols,
          symbolDetail: state.symbolDetail,errorMessage: null);

      SymbolModel? symbolModel = await client.getSymbols({
        "access_key": access_key
      }).catchError((Object obj) {
        switch (obj.runtimeType) {
          case DioError:
            final res = (obj as DioError).response;
            print("Got error : ${res?.statusCode} -> ${res?.statusMessage}");
            break;
          default:
        }
      });
      yield HomeState(
          loading: false,
          symbols: symbolModel,
          symbolDetail: state.symbolDetail,errorMessage: null);
    } else if (event is GetSymbolDetail) {
      yield HomeState(
          loading: true,
          symbols: state.symbols,
          symbolDetail: state.symbolDetail,errorMessage: null);
      var res;
      SymbolDetail? symbolDetail = await client.getSymbolDetail({
        "access_key": access_key,
        "symbols": event.code,
        "for%20mat": 1
      }).catchError((Object obj) {
        switch (obj.runtimeType) {
          case DioError:
            res = (obj as DioError).response;
            print("Got error : ${res?.statusCode} -> ${res?.statusMessage}");
            break;
          default:
        }
      });
      if(symbolDetail!=null) {
        symbolDetail.code = event.code;
        yield HomeState(
            loading: false, symbols: state.symbols, symbolDetail: symbolDetail,errorMessage: null);
      }else{
        yield HomeState(
            loading: false, symbols: state.symbols, symbolDetail: null,errorMessage: res?.statusMessage);
      }
    }
  }
}
