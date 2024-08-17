import 'dart:convert';

import 'droplet_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;

class TokenMissingException implements Exception {
  final String message;

  TokenMissingException(this.message);

  @override
  String toString() {
    return 'TokenMissingException: $message';
  }

  String errorMessage() {
    return message;
  }
}

class DigitalDroplet {
  final String _baseURL = "https://api.digitalocean.com/v2";

  static DigitalDroplet? _instance;
  static String? _token;

  DigitalDroplet._privateContructor();

  static DigitalDroplet get instance {
    _instance ??= DigitalDroplet._privateContructor();
    return _instance!;
  }

  String? get token => _token;
  DateTime dropletsLastSynced = DateTime.now();
  DropletsResponse? dropletsCache;
  // Map<int,DropletResponse>? dropletCache;

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    if (_token == null) {
      throw TokenMissingException("Authorization token missing.");
    }
    return _token ?? "";
  }

  Future<String> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    _token = token;
    return _token ?? "";
  }

  Future<bool> isValidUser(String token) async {
    dev.log("checking isValidUser");
    dev.log(token);
    final response = await http.get(
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      Uri.parse("$_baseURL/account"),
    );
    if (response.statusCode == 200) {
      dev.log(response.statusCode.toString());
      dev.log(response.body);

      await setToken(token);
      return true;
    }
    dev.log(response.statusCode.toString());
    dev.log(response.body);
    return false;
  }

  Future<DropletsResponse> getAllDroplets() async {
    dev.log("Get Droplets");
    final timeElapsed = DateTime.now().difference(dropletsLastSynced);
    if (timeElapsed.inMinutes < 5 && dropletsCache != null) {
      dev.log("Returning Cache");
      return dropletsCache!;
    }
    dropletsLastSynced = DateTime.now();
    final response = await http.get(
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${_token ?? await getToken()}"
      },
      Uri.parse("$_baseURL/droplets?page=1"),
    );

    if (response.statusCode == 200) {
      dev.log(dropletsResponseToJson(dropletsResponseFromJson(response.body)));
      dropletsCache = dropletsResponseFromJson(response.body);
      return dropletsCache!;
    } else {
       dev.log("Failed get droplets ${response.body}");
      final errorResponse = dropletErrorResponseFromJson(response.body);
      throw Exception(errorResponse.message);
    }
  }

  Future<DropletResponse> getDroplet(int dropletID) async {
    dev.log("Get Droplet");
    final response = await http.get(
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${_token ?? await getToken()}"
      },
      Uri.parse("$_baseURL/droplets/$dropletID"),
    );

    if (response.statusCode == 200) {
      dev.log(dropletResponseToJson(dropletResponseFromJson(response.body)));
      return dropletResponseFromJson(response.body);
    } else {
      dev.log("Failed get droplet ${response.body}");
      final errorResponse = dropletErrorResponseFromJson(response.body);
      throw Exception(errorResponse.message);
    }
  }

  Future<DropletActionResponse> powerOn(int dropletID) async {
    dev.log("calling powerOn");
    final response = await http.post(
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${_token ?? await getToken()}"
      },
      Uri.parse("$_baseURL/droplets/$dropletID/actions"),
      body: jsonEncode({"type": "power_on"}),
    );
    if (response.statusCode == 201) {
      final prefs = await SharedPreferences.getInstance();

      final powerOffResponse = dropletActionResponseFromJson(response.body);
      await prefs.setString(
          dropletID.toString(), powerOffResponse.action.id.toString());
      dev.log(dropletActionResponseToJson(powerOffResponse));
      return powerOffResponse;
    } else {
      final errorResponse = dropletErrorResponseFromJson(response.body);
      dev.log(dropletErrorResponseToJson(errorResponse));
      throw Exception(errorResponse.message);
    }
  }

  Future<DropletActionResponse> powerOff(int dropletID) async {
    dev.log("calling poweroff");
    final response = await http.post(
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${_token ?? await getToken()}"
      },
      Uri.parse("$_baseURL/droplets/$dropletID/actions"),
      body: jsonEncode({"type": "power_off"}),
    );
    if (response.statusCode == 201) {
      final prefs = await SharedPreferences.getInstance();
      final powerOffResponse = dropletActionResponseFromJson(response.body);
      await prefs.setString(
          dropletID.toString(), powerOffResponse.action.id.toString());
      dev.log(dropletActionResponseToJson(powerOffResponse));
      return powerOffResponse;
    } else {
      dev.log("powerOff Failed ${response.body}");
      final errorResponse = dropletErrorResponseFromJson(response.body);
      throw Exception(errorResponse.message);
    }
  }

  Future<DropletActionResponse> getActionStatus(
      String dropletID, String actionID) async {
      dev.log("Action Status");
    final response = await http.get(
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${_token ?? await getToken()}"
      },
      Uri.parse("$_baseURL/droplets/$dropletID/actions/$actionID"),
    );
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();

      final actionStatusResponse = dropletActionResponseFromJson(response.body);
      await prefs.setString(
          dropletID, actionStatusResponse.action.id.toString());
      
      dev.log(dropletActionResponseToJson(actionStatusResponse));
      return actionStatusResponse;
    } else {
      dev.log("Action status Failed ${response.body}");
      final errorResponse = dropletErrorResponseFromJson(response.body);
      throw Exception(errorResponse.message);
    }
  }
}
