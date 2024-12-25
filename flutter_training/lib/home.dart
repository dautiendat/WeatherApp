import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_training/api_key.dart';
import 'package:flutter_training/models/myweather.dart';
import 'package:flutter_training/myweather_factory.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bool _isDayTime = DateTime.now().hour >= 6 && DateTime.now().hour < 18;
  final WeatherFactory _factory = WeatherFactory(OPEN_WEATHER_API_KEY);

  Weather? _currentWeather;
  // List<MyWeather>? _forecastWeatherList = [];
  // List<MyWeather>? _nextForecastWeatherList = [];
    List<Weather>? _forecastWeatherList = [];
    List<Weather>? _nextForecastWeatherList = [];
  Future<void> _getData(String cityName) async{
    try{
      DateTime today = DateTime.now();
      
      var currentWeather = await _factory.currentWeatherByCityName(cityName);
      var forecastWeather = await _factory.fiveDayForecastByCityName(cityName);

      setState(() {
        _currentWeather = currentWeather;        
        for(var item in forecastWeather){
          if(item.date!.day == today.day){
            _forecastWeatherList?.add(item);
          }
        }
        //Thêm các ngày mà ko trùng lặp vào nextForecastList 
        //-> hiển thị widget next Forecast
        for (var item in forecastWeather) {
          if(!_nextForecastWeatherList!.any((forecast) => 
              forecast.date!.day == item.date!.day)){
            _nextForecastWeatherList!.add(item);
          }
        }
      }); 
      
    }catch (e){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Thong bao"),
            content: Text("Khong the ket noi voi intenet: $e"),
          );
        });
    }
  }
  
  @override
  void initState() {
    super.initState();
    _getData("London"); 
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      //điều chỉnh size màn hình khi bàn phím đc bật lên
      resizeToAvoidBottomInset: true,
      backgroundColor: 
      _isDayTime 
      ? Color.fromRGBO(71, 187, 225, 1)
      :Color.fromRGBO(11, 66, 171, 1),
      body: _buildUI()
    );
  }
  //Widget chính
  Widget _buildUI() {
    if(_currentWeather==null){
      return const Center(
        child: CircularProgressIndicator(color: Colors.white,),
      );
    }
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 20,right: 20),
        child: SingleChildScrollView(
          child: Column(  
            children: [
              _mainToday(),
              SizedBox(height: 30,),
              _bonusWeather(),
              SizedBox(height: 20,),
              _todayWeather(),
              SizedBox(height: 20,),
              _nextForecast(),
            ],
          ),
        ),
    ),
    );
  }

  Container _bonusWeather() {
    return Container(
              width:343,
              height: 47,
              decoration: BoxDecoration(
                color: _isDayTime 
                  ? Color.fromRGBO(45, 200, 234, 1)
                  :Color.fromRGBO(80, 150, 255, 1),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20,right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/cloudiness.png',
                          height: 30,
                          width: 30,
                        ),
                        SizedBox(width: 5,),
                        Text(
                          '${_currentWeather!.cloudiness}%', 
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/humidity.png',
                          height: 30,
                          width: 30,
                        ),
                        SizedBox(width: 5,),
                        Text(
                          '${_currentWeather!.humidity}%', 
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/wind.png',
                          height: 30,
                          width: 30,
                        ),
                        SizedBox(width: 5,),
                        Text(
                          '${_currentWeather!.windSpeed}m/s', 
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )  
            );
  }
  //Widget dự báo thời tiết
  Container _nextForecast() {
    return Container(
                  width: 343,
                  height: 300,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:  _isDayTime 
                  ? Color.fromRGBO(45, 200, 234, 1)
                  :Color.fromRGBO(80, 150, 255, 1),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next Forecast',
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 20,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      SizedBox(height: 10,),
                      _itemNextForecast(),
                    ],
                  ),  
                );
  }
  //Widget thời tiết hôm nay
  Container _todayWeather() {
    DateTime now = _currentWeather!.date!;
    return Container(
            width: 343,
            height: 240,
            padding: EdgeInsets.all(16),
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color:  _isDayTime 
                  ? Color.fromRGBO(45, 200, 234, 1)
                  :Color.fromRGBO(80, 150, 255, 1),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      Text(
                        'Today',
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 20,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      Text(
                        '${DateFormat("MMMM d, yyyy").format(now)}',
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 18,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                  ],
                ),
                _itemWeathers(),
              ],
            ),
          );
  }

  //hàm trả về thứ mấy trong tuần
  String _myWeekDay(DateTime? datetime){
    int? weekday = datetime?.weekday;
    String weekdayName;
    switch (weekday){
      case 1:
        weekdayName = "Sunday";
        break;
      case 2:
        weekdayName = "Monday";
        break;
      case 3:
        weekdayName = "Tuesday";
        break;
      case 4:
        weekdayName = "Wednesday";
        break;
      case 5:
        weekdayName = "Thursday";
        break;
      case 6:
        weekdayName = "Friday";
        break;
      case 7:
        weekdayName = "Saturday";
        break;
      default:
        weekdayName = "Non-defined";
    }
    return weekdayName;
  }

  //item widget dự báo thời tiết
  SizedBox _itemNextForecast() {
    return SizedBox(
            height: 225, 
            child: ListView.separated(
              itemCount: _nextForecastWeatherList!.length,
              separatorBuilder: (context, index) => SizedBox(height: 15,),
              itemBuilder: (context, index) {
                var forecast = _nextForecastWeatherList![index];
                return Container(
                  width: 309,
                  decoration: BoxDecoration(
                    color:  _isDayTime 
                  ? Color.fromRGBO(45, 200, 234, 1) 
                  :Color.fromRGBO(80, 150, 255, 1),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${_myWeekDay(forecast.date)}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://openweathermap.org/img/wn/${forecast.weatherIcon}@2x.png'
                            )
                          )
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "${forecast.tempMin?.celsius?.toStringAsFixed(0)}°C/",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "${forecast.tempMax?.celsius?.toStringAsFixed(0)}°C",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          );
  }
  //item widget thời tiết hôm nay
  Padding _itemWeathers() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: Container(
                height: 155,
                decoration: BoxDecoration(
                  color:_isDayTime 
                  ? Color.fromRGBO(45, 200, 234, 1) 
                  :Color.fromRGBO(80, 150, 255, 1)
                ),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  //Trả về số lượng item cần hiển thị
                  itemCount: _forecastWeatherList!.length,
                  //Ngăn các item vs khoảng trống bằng 12px
                  separatorBuilder: (context, index) => SizedBox(width: 12,),
                  itemBuilder: (context, index) {
                    var forecast = _forecastWeatherList?[index];
                    return SizedBox(
                      width: 70,
                      child: Column(
                        children: [
                          Text(
                            "${forecast?.temperature?.celsius?.toStringAsFixed(0)}°C",
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: 18
                            ),
                          ),
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://openweathermap.org/img/wn/${forecast?.weatherIcon}@2x.png',
                                )
                              )
                            ),
                          ),
                          Text(
                            "${forecast?.date?.hour}:00",
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: 18
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                ),
              ),
    );
  }
  //Widget thời tiết thời điểm hiện tại
  Column _mainToday() {
    return Column(
            children: [
              Row(
              children: [
                SvgPicture.asset('assets/icons/Location.svg'),
                Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: _dropDownMenu(),
                ),
              ],
              ),
              SizedBox(height: 30,),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://openweathermap.org/img/wn/${_currentWeather?.weatherIcon}@2x.png',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Text(
                //toStringAsFixed - lấy sau dấu phẩy bao nhiêu chữ số
                '${_currentWeather?.temperature?.celsius?.toStringAsFixed(0)}°C',
                style: TextStyle(
                  fontSize: 64,
                  color: Colors.white
                ),
              ),
              Text(
                '${_currentWeather?.weatherDescription}',
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 18
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Max: ${_currentWeather?.tempMax?.celsius?.toStringAsFixed(0)}°C',
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 18
                    ),
                  ),
                  SizedBox(width: 15,),
                  Text(
                    'Min: ${_currentWeather?.tempMin?.celsius?.toStringAsFixed(0)}°C',
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 18
                    ),
                  ),
              ],)
            ],
          );
  }
  //Widget dropDownMenu hiển thị tên các thành phố
  Widget _dropDownMenu(){
    List<String> items = ['London','Tokyo','Bangkok','New Zealand','France'];
    String? selectedValue = _currentWeather?.areaName;
    return DropdownMenu(
      requestFocusOnTap:true,
      //set icon mũi tên
      trailingIcon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white,),
      //set icon mũi tên khi được click
      selectedTrailingIcon: Icon(Icons.keyboard_arrow_up_rounded, color: Colors.white,),
      //ẩn border của dropdown menu
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none        
        )
      ),
      //khởi tạo item được chọn khi chạy lần đầu
      initialSelection: selectedValue,
      textStyle: TextStyle(color: Colors.white,fontSize: 18),
      onSelected: (value) {
        setState(() {
          selectedValue = value;
          _getData(value!);
        });
      },
      //onSelected: (value) => setState(() => selectedValue = value),
      dropdownMenuEntries: items.map((value)=>
      DropdownMenuEntry<String>(
        value: value,
        label: value,
      )).toList(),
    );
  }
  
}