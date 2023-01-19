import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:qibla_compass/services/compass.dart';

class CompassController extends GetxController {
  CompassService? _compassService;
  StreamSubscription<CompassEvent>? _compassSubscription;
  double? compassHeading;
  double? qiblagOffset;
  double? jurOffset;
  String? compassDirection;
  Location location = new Location();
  Color pointerColor = Colors.transparent;
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LocationData _locationData = LocationData.fromMap({});

  CompassController() {
    // _compassDirectionSubscription =
    //     _compassService.compassDirectionStream?.listen((event) {
    //   compassDirection = event;
    //   notifyListeners();
    // });
    // _compassHeadingSubscription =
    //     _compassService.compassHeadingStream?.listen((event) {
    //   compassHeading = event;
    //   notifyListeners();
    // });
    initLocation();
  }
  void initLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    _compassService = CompassService(locationData: _locationData);
    _compassSubscription = _compassService!.compassStream?.listen((event) {
      compassHeading = event.heading;
      compassDirection = _compassService!.getDirection(event.heading ?? 0);
      qiblagOffset = _compassService!.getOffsetFromNorth(
          _locationData.latitude!,
          _locationData.longitude!,
          21.422487,
          39.826206);
      jurOffset = _compassService!.getOffsetFromNorth(_locationData.latitude!,
          _locationData.longitude!, 31.771959, 35.217018);

      if (compassDirection == "Qiblah") {
        pointerColor = Colors.green;
      } else if (compassDirection == "Jerusalem") {
        pointerColor = Colors.blue;
      } else {
        pointerColor = Colors.transparent;
      }
      update();
      print(jurOffset);
    });
  }

  @override
  void dispose() {
    // _compassHeadingSubscription?.cancel();
    // _compassDirectionSubscription?.cancel();
    _compassSubscription?.cancel();
    super.dispose();
  }
}
