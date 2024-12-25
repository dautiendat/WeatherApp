import 'dart:convert';

import 'package:flutter_training/consts.dart';
import 'package:flutter_training/models/myweather.dart';
import 'package:http/http.dart' as http;
import 'package:weather/weather.dart';
class MyweatherFactory {

  final String? _apiKey;
  late http.Client _client;
  
  MyweatherFactory(this._apiKey){
    _client = http.Client();
  }

  Future<MyWeather> getWeatherByCityName(String cityName) async{
    Map<String,dynamic>? response = 
      await _sendRequest(CURRENT_WEATHER, cityName);
    return MyWeather(response!);
  }

  Future<List<MyWeather>> getWeatherForecastByCityName(String cityName) async{
    Map<String,dynamic>? response = 
      await _sendRequest(FORECAST_WEATHER, cityName);
      List<MyWeather> forecast = parseToList(response!);
    return forecast;
  }

  Future<Map<String,dynamic>?> 
  _sendRequest(String? tag, String? cityName) async{
    //tạo url để call api
    String url = _buildUrl(tag, cityName);

    //call api 
    http.Response response = await _client.get(Uri.parse(url));

    //nếu call thành công
    if(response.statusCode == STATUS_OK){
      Map<String,dynamic> data = json.decode(response.body);
      return data;
    }else{
      throw OpenWeatherAPIException("Exception: ${response.body}");
    }
  }
  String _buildUrl(String? tag, String? cityName){

    String url = 'https://api.openweathermap.org/data/2.5/$tag?';

    if(cityName != null){
      url += 'q=$cityName&';
    }else{
      //mặc định London
      url += 'q=London&';
    }
    url += 'appid=$_apiKey&';
    return url;
  }
  
}