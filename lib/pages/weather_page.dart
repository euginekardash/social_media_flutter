import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/services/weather_service.dart';

import '../models/weather_model.dart';
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  //api key
  final _weatherService = WeatherService('0c3721088b45e634a8360a9626bfd006');
  Weather? _weather;


  //fetch weather
  _fetchWeather() async{
    //get current city
    String cityName = await _weatherService.getCurrentCity();

    //get weather for the city
    try{
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    //errors
    catch(e){
      print(e);
    }
  }

  //weather animations
  String getWeatherAnimation (String? mainCondition){
    if(mainCondition == null){
      return 'assets/loading.json';
    }
    switch(mainCondition.toLowerCase()){
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return('assets/cloud.json');
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return('assets/rain.json');
      case 'thunderstorm':
        return('assets/storm.json');
      case 'clear':
        return('assets/sun.json');
      case 'snow':
        return('assets/snow.json');
      default:
        return "assets/sun.json";
    }
  }

  //init state
  @override
  void initState() {
    super.initState();

    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton(icon: Icon(Icons.update),
        onPressed: (){
          setState(() {
            _fetchWeather();
          });
        },

      ),
      backgroundColor: Colors.blue[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //date


            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(DateFormat('dd MMM yyyy').format(DateTime.now()), style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),),
            ),

            //city name
            Text(_weather?.cityName ?? "", style: TextStyle(fontFamily: 'Roboto',fontSize: 25, fontWeight: FontWeight.bold),),

            //animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            //temp
            Text("${_weather?.temperature.round()}°C", style: TextStyle(fontFamily: 'Roboto', fontSize: 25)),

            //weather condition

            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(_weather?.mainCondition ?? "", style: TextStyle(fontFamily: 'Roboto', fontSize: 20),),
            ),
          ],
        ),
      ),
    );
  }
}
