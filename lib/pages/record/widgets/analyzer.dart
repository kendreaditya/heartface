import 'dart:convert';

import 'package:http/http.dart' as http;
import './../../../constants.dart';

Future<Prediction> analyzeSamples(sampleStack) async {
  final response = await (http.post(urlPOST,
      headers: {"Accept": "application/json"},
      body: jsonEncode({"samples": sampleStack})));
  return response.statusCode == 200
      ? Prediction.fromJson(jsonDecode(response.body))
      : Prediction(prediction: "-", confidence: 0);
}

class Prediction {
  final String prediction;
  final int confidence;
  Prediction({this.prediction, this.confidence});

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      prediction: json["prediction"],
      confidence: json["confidence"],
    );
  }
}
