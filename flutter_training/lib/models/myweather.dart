import 'package:weather/weather.dart';

class MyTemperature {
  double? _kelvin;

  MyTemperature(this._kelvin);

  double? get kelvin => _kelvin;
  double? get celsius => _kelvin != null ? _kelvin! - 273.15 : null;
}

class MyWeather {
  String? _description, _icon, _areaName;
  Temperature? _tempMin, _tempMax, _temp;
  DateTime? _date, _datetime;
  double? _wind = 0.0; 
  int? _cloudiness = 0, _humidity = 0;
  //int? _wind = 0, _cloudiness = 0, _humidity = 0;
  MyWeather(Map<String, dynamic> jsonData) {
    Map<String, dynamic> main = jsonData['main'];
    Map<String, dynamic> cloud = jsonData['clouds'];
    Map<String, dynamic> wind = jsonData['wind'];
    Map<String, dynamic> weather = jsonData['weather'][0];

    _icon = weather['icon'];
    _description = weather['description'];

    _temp = Temperature(main['temp'].round());
    _tempMin = Temperature(main['temp_min'].round());
    _tempMax = Temperature(main['temp_max'].round());
    
    print('hello: Nhiệt độ: ${Temperature(main['temp'])},${Temperature(main['temp']).runtimeType}');
    print('hello: Max: ${Temperature(main['temp_max'])},${Temperature(main['temp_max']).runtimeType}');
    print('hello: Min: ${Temperature(main['temp_min'])},${Temperature(main['temp_min']).runtimeType}');
    _date = _formatDate(jsonData['dt']);
    if (jsonData['dt_txt'] != null) {
      _datetime = DateTime.parse(jsonData['dt_txt']);
    }

    _areaName = jsonData['name'];
    // _cloudiness = cloud['all'];
    // _wind = wind['speed'];
    // _humidity = main['humidity'];
    print('hello: Mây: ${cloud['all']} ,${cloud['all'].runtimeType}');
    print('hello: Gió: ${wind['speed']} ,${wind['speed'].runtimeType}');
    print('hello: Độ ẩm: ${main['humidity']} ,${main['humidity'].runtimeType}');
    // if (cloud['all'] is int) {
    //   _cloudiness = (cloud['all'] as int).toDouble();
    // } else if (cloud['all'] is double) {
    //   _cloudiness = cloud['all'] as double;
    // } else {
    //   _cloudiness = 0.0; 
    // }
  }

  String? get weatherIcon => _icon;
  String? get weatherDescription => _description;
  String? get weatherAreaName => _areaName;

  Temperature? get weatherTempMin => _tempMin;
  Temperature? get weatherTempMax => _tempMax;
  Temperature? get weatherTemp => _temp;

  DateTime? get weatherDate => _date;
  DateTime? get weatherDateTime => _datetime;

  int? get weatherCloud => _cloudiness;
  double? get weatherWindSpeed => _wind;
  int? get weatherHumidity => _humidity;
  // int? get weatherCloud => _cloudiness;
  // int? get weatherWindSpeed => _wind;
  // int? get weatherHumidity => _humidity;
}

//định dạng ngày tháng (VD:2024-2-12 12:00:00:00)
DateTime? _formatDate(int dateAPI) {
  int fomatted = dateAPI * 1000;
  return DateTime.fromMillisecondsSinceEpoch(fomatted);
}

//chuyển map thành list
List<MyWeather> parseToList(Map<String, dynamic> jsonForecast) {
  List<dynamic> forecastList = jsonForecast['list'];
  return forecastList.map((item) => MyWeather(item)).toList();
}
