import 'package:flutter/services.dart';
import 'package:location/location.dart';

class MyLocation {
  late Location _location;
  bool _serviceEnabled = false;
  PermissionStatus? _grantedPermission;

  MyLocation() {
    _location = Location();
  }

  Future<bool> _checkPermission() async {
    if (await _checkService()) {
      _grantedPermission = await _location.hasPermission();
      if (_grantedPermission == PermissionStatus.denied) {
        _grantedPermission = await _location.requestPermission();
      }
    }
    return _grantedPermission == PermissionStatus.granted;
  }

  Future<bool> _checkService() async {
    try {
      _serviceEnabled = await _location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await _location.requestService();
      }
    } on PlatformException catch (error) {
      print("error code is ${error.code} and massage = ${error.message}");
      _serviceEnabled = false;
      await _checkService();
    }
    return _serviceEnabled;
  }

  Future<LocationData?> getlocation() async {
    if (await _checkPermission()) {
      final locationData = _location.getLocation();
      return locationData;
    }
    return null;
  }

  //Future<String> getCityName(String longitude, String latitude) async {
  //  var lon = double.parse(longitude);
  //  var lat = double.parse(latitude);
  //  var results = await Geocoder.local
  //       .findAddressesFromCoordinates(Coordinates(lat, lon));
  //
  //  return results.first.countryName;
  // }

}
