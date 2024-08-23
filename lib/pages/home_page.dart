import 'package:clima/constst.dart';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
import 'pronostico.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY, language: Language.SPANISH);
  bool _hasLocationPermission = false;
  Future<Map<String, dynamic>>? _weatherData;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    var status = await Permission.location.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      status = await Permission.location.request();
    }
    if (status.isGranted) {
      setState(() {
        _hasLocationPermission = true;
        _weatherData = _getWeather(); 
      });
    } else {
      setState(() {
        _hasLocationPermission = false;
      });
      print('Permiso de ubicación denegado.');
    }
  }

  Future<Map<String, dynamic>> _getWeather() async {
    if (_hasLocationPermission) {
      try {
        // ignore: deprecated_member_use
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
        Weather weather = await _wf.currentWeatherByLocation(position.latitude, position.longitude); 
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        Placemark place = placemarks[0];
        return {
          'weather': weather,
          'location': '${place.locality}, ${place.country}'
        };
      } catch (e) {
        print('Error obteniendo el clima: $e');
        return {
          'weather': null,
          'location': 'No se pudo obtener la ubicación'
        };
      }
    } else {
      return {
        'weather': null,
        'location': 'Permiso de ubicación denegado'
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        title: Text('App Climatologica'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _weatherData = _getWeather();
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Fondo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<Map<String, dynamic>>(
                  future: _weatherData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.black));
                    } else if (snapshot.hasData) {
                      var data = snapshot.data!;
                      var weather = data['weather'];
                      var location = data['location'];
                      String? iconCode = weather?.weatherIcon;
                      String iconUrl = iconCode != null
                          ? 'http://openweathermap.org/img/wn/$iconCode@2x.png'
                          : 'https://via.placeholder.com/50'; 
                      String weatherDescription = weather?.weatherDescription ?? 'No disponible'; 
                      return Column(
                        children: [
                          Text('Ubicación: $location', style: TextStyle(color: Colors.black)),
                          Image.network(iconUrl),
                          Text('Clima: $weatherDescription', style: TextStyle(color: Colors.black)), 
                          Text('Temperatura: ${weather?.temperature?.celsius ?? 'No disponible'}°C', style: TextStyle(color: Colors.black)),
                        ],
                      );
                    } else {
                      return Text('No hay datos disponibles', style: TextStyle(color: Colors.black));
                    }
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Pronostico()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 198, 214, 211),
                  ),
                  child: Text('Pronóstico de los próximos 3 días', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}