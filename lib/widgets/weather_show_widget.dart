import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../repositories/weather_repository.dart';

class WeatherShowWidget extends StatelessWidget {
  const WeatherShowWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(       
          15,
        ),
        topRight: Radius.circular( 
          15,
        ),
      ),
      color: Colors.white,
      shadowColor: Colors.grey,
      elevation: 3,
      child: SizedBox(
        height: 230,
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          WeatherRepository.temperature.toInt().toString() +
                              '°C',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 50,
                          ),
                        ),
                        FittedBox(
                          child: Text(
                            WeatherRepository.weatherMain,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 45,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 50,
                          width: 55,
                          child: Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              'http://openweathermap.org/img/wn/${WeatherRepository.weatherIcon}@2x.png',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          DateFormat.yMMMMEEEEd().format(
                            DateTime.now(),
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(
                  color: Colors.black,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WeatherRepository.textRow(
                          'Pressure: ',
                          WeatherRepository.pressure.toString(),
                        ),
                        WeatherRepository.textRow(
                          'Humidity: ',
                          WeatherRepository.humidity.toString(),
                        ),
                        WeatherRepository.textRow(
                          'Visibility: ',
                          (WeatherRepository.visibility ~/ 1000).toString() +
                              'km',
                        ),
                        WeatherRepository.textRow(
                          'Cloud Cover: ',
                          WeatherRepository.cloudCover.toString() + '%',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 3,
              right: 5,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.all(
                    4,
                  ),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black38,
                  ),
                  child: const Icon(
                    Icons.close,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
