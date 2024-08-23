import 'package:clima/constst.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

class Pronostico extends StatelessWidget {
  const Pronostico({super.key});

  Future<List<Weather>> _getForecast() async {
    final WeatherFactory wf = WeatherFactory(OPENWEATHER_API_KEY, language: Language.SPANISH);
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Weather> forecast = await wf.fiveDayForecastByLocation(position.latitude, position.longitude);
    return forecast.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        title: const Text('Pronóstico aproximado de 3 Días'),
        foregroundColor: Colors.black,
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
          FutureBuilder<List<Weather>>(
            future: _getForecast(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error al obtener el pronóstico', style: TextStyle(color: Colors.black)));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No se encontró pronóstico', style: TextStyle(color: Colors.black)));
              } else {
                List<Weather> forecast = snapshot.data!;
                return ListView.builder(
                  itemCount: forecast.length,
                  itemBuilder: (context, index) {
                    Weather dayForecast = forecast[index];
                    return ListTile(
                      title: Text(
                        'Día ${index + 1}: ${dayForecast.temperature!.celsius?.toStringAsFixed(1)} °C',
                        style: TextStyle(color: Colors.black), 
                      ),
                      subtitle: Text(
                        dayForecast.weatherDescription ?? '',
                        style: TextStyle(color: Colors.black),
                      ),
                      leading: Image.network(
                        'https://openweathermap.org/img/wn/${dayForecast.weatherIcon}@2x.png',
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
