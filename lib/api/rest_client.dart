import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_client.g.dart';

//access_key=e116afe6cfe5ff0150c5e91d49f053ea
//access_key=a92105675e22a5f932aa9fdc1153052a
//http://api.exchangeratesapi.io/v1/latest?access_key=e116afe6cfe5ff0150c5e91d49f053ea&symbols=GBP&for%20mat=1

@RestApi(baseUrl: "http://api.exchangeratesapi.io/v1")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/symbols")
  Future<SymbolModel?> getSymbols(@Queries() Map<String, dynamic> queries);

  @GET("/latest")
  Future<SymbolDetail?> getSymbolDetail(@Queries() Map<String, dynamic> queries);
}

@JsonSerializable()
class SymbolModel {
  bool? success;
  Map<String, dynamic>? symbols;

  SymbolModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    symbols = json['symbols'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.symbols != null) {
      data['symbols'] = this.symbols;
    }
    return data;
  }
}

@JsonSerializable()
class SymbolDetail {
  bool? success;
  int? timestamp;
  String? base;
  String? date;
  String? code;
  Map<String, dynamic>? rates;

  SymbolDetail.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    timestamp = json['timestamp'];
    base = json['base'];
    date = json['date'];
    rates = json['rates'] != null ? json['rates'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['timestamp'] = this.timestamp;
    data['base'] = this.base;
    data['date'] = this.date;
    if (this.rates != null) {
      data['rates'] = rates;
    }
    return data;
  }
}
