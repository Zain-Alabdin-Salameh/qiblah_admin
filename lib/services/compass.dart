import 'package:flutter_compass/flutter_compass.dart';
import 'package:location/location.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart';

class CompassService {
  CompassService({this.locationData});
  LocationData? locationData;
  // method to get the current heading direction
  String getDirection(double heading) {
    if (heading.round() <
            getOffsetFromNorth(locationData!.latitude!,
                        locationData!.longitude!, 21.422487, 39.826206)
                    .round() +
                5 &&
        heading.round() >
            getOffsetFromNorth(locationData!.latitude!,
                        locationData!.longitude!, 21.422487, 39.826206)
                    .round() -
                5) {
      return "Qiblah";
    }
    if (heading.round() <
            getOffsetFromNorth(locationData!.latitude!,
                        locationData!.longitude!, 31.771959, 35.217018)
                    .round() +
                5 &&
        heading.round() >
            getOffsetFromNorth(locationData!.latitude!,
                        locationData!.longitude!, 31.771959, 35.217018)
                    .round() -
                5) {
      return "Jerusalem";
    } else if (heading >= 0 && heading < 22.5) {
      return 'N';
    } else if (heading >= 22.5 && heading < 67.5) {
      return 'NE';
    } else if (heading >= 67.5 && heading < 112.5) {
      return 'E';
    } else if (heading >= 112.5 && heading < 157.5) {
      return 'SE';
    } else if ((heading >= 157.5 && heading < 202.5) ||
        (heading >= -179.5 && heading < -160)) {
      return 'S';
    } else if ((heading >= 202.5 && heading < 247.5) ||
        (heading >= -160 && heading < -110)) {
      return 'SW';
    } else if ((heading >= 247.5 && heading < 292.5) ||
        (heading >= -110 && heading < -60)) {
      return 'W';
    } else if ((heading >= 292.5 && heading < 337.5) ||
        (heading >= -60 && heading < -25)) {
      return 'NW';
    } else if (heading >= 337.5 && heading < 360) {
      return 'N';
    } else {
      return 'N';
    }
  }

  double getOffsetFromNorth(double currentLatitude, double currentLongitude,
      double targetLatitude, double targetLongitude) {
    var la_rad = radians(currentLatitude);
    var lo_rad = radians(currentLongitude);

    var de_la = radians(targetLatitude);
    var de_lo = radians(targetLongitude);

    var toDegrees = degrees(atan(sin(de_lo - lo_rad) /
        ((cos(la_rad) * tan(de_la)) - (sin(la_rad) * cos(de_lo - lo_rad)))));
    if (la_rad > de_la) {
      if ((lo_rad > de_lo || lo_rad < radians(-180.0) + de_lo) &&
          toDegrees > 0.0 &&
          toDegrees <= 90.0) {
        toDegrees += 180.0;
      } else if (lo_rad <= de_lo &&
          lo_rad >= radians(-180.0) + de_lo &&
          toDegrees > -90.0 &&
          toDegrees < 0.0) {
        toDegrees += 180.0;
      }
    }
    if (la_rad < de_la) {
      if ((lo_rad > de_lo || lo_rad < radians(-180.0) + de_lo) &&
          toDegrees > 0.0 &&
          toDegrees < 90.0) {
        toDegrees += 180.0;
      }
      if (lo_rad <= de_lo &&
          lo_rad >= radians(-180.0) + de_lo &&
          toDegrees > -90.0 &&
          toDegrees <= 0.0) {
        toDegrees += 180.0;
      }
    }
    return toDegrees;
  }

  // Getter to get current heading data stream
  Stream<double?>? get compassHeadingStream {
    return FlutterCompass.events?.map((event) => event.heading);
  }

  // Getter to get current heading direction stream
  Stream<String>? get compassDirectionStream {
    return FlutterCompass.events
        ?.map((event) => getDirection(event.heading ?? 0));
  }

  // Getter to get current compass data stream
  Stream<CompassEvent>? get compassStream {
    return FlutterCompass.events;
  }
}
