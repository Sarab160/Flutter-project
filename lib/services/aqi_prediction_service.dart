import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Service class that loads the Pure Dart AQI prediction model
/// and runs inference on user-provided atmospheric data.
class AqiPredictionService {
  Map<String, dynamic>? _scalerParams;
  Map<String, dynamic>? _labelMapping;
  List<dynamic>? _modelWeights;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  /// Load the model weights and parameters from assets.
  Future<void> loadModel() async {
    try {
      final scalerJson = await rootBundle.loadString('assets/scaler_params.json');
      _scalerParams = json.decode(scalerJson);

      final labelJson = await rootBundle.loadString('assets/label_mapping.json');
      _labelMapping = json.decode(labelJson);

      final weightsJson = await rootBundle.loadString('assets/model_weights.json');
      _modelWeights = json.decode(weightsJson);

      _isLoaded = true;
      debugPrint('✅ AQI Pure Dart model loaded successfully');
    } catch (e) {
      _isLoaded = false;
      debugPrint('❌ Failed to load AQI model: $e');
      rethrow;
    }
  }

  /// Run a prediction.
  ///
  /// [features] must contain exactly 4 values: [CO, Ozone, NO2, PM2.5].
  /// Returns a Map with 'category' and 'probability'.
  Map<String, dynamic> predict(List<double> input) {
    if (!_isLoaded) {
      throw StateError('Model not loaded. Call loadModel() first.');
    }
    if (input.length != 4) {
      throw ArgumentError('Expected 4 features, got ${input.length}');
    }

    // Apply StandardScaler: z = (x - mean) / scale
    List<double> mean = List<double>.from(_scalerParams!['mean']);
    List<double> scale = List<double>.from(_scalerParams!['scale']);

    List<double> current = [];
    for (int i = 0; i < input.length; i++) {
      current.add((input[i] - mean[i]) / scale[i]);
    }

    // Forward pass through layers
    for (var layer in _modelWeights!) {
      List<dynamic> weights = layer['weights'];
      List<dynamic> biases = layer['biases'];
      String activation = layer['activation'];

      List<double> next = List.filled(biases.length, 0.0);

      for (int j = 0; j < biases.length; j++) {
        double sum = (biases[j] as num).toDouble();
        for (int i = 0; i < current.length; i++) {
          sum += current[i] * (weights[i][j] as num).toDouble();
        }
        
        if (activation == 'relu') {
          next[j] = math.max(0.0, sum);
        } else {
          next[j] = sum;
        }
      }

      if (activation == 'softmax') {
        next = _softmax(next);
      }
      current = next;
    }

    // Get index of highest probability
    int maxIdx = 0;
    double maxProb = -1.0;
    for (int i = 0; i < current.length; i++) {
      if (current[i] > maxProb) {
        maxProb = current[i];
        maxIdx = i;
      }
    }

    String category = _labelMapping![maxIdx.toString()] ?? "Unknown";
    
    return {
      'category': category,
      'probability': maxProb,
    };
  }

  /// Calculates a numeric AQI score using EPA standard breakpoints.
  /// Standard formula: I = [(I_high - I_low) / (C_high - C_low)] * (C - C_low) + I_low
  double calculateNumericAqi(List<double> input) {
    if (input.length != 4) return 0.0;

    double co = input[0];
    double ozone = input[1];
    double no2 = input[2];
    double pm25 = input[3];

    // Calculate individual AQIs
    double aqiCo = _calculateCoAqi(co);
    double aqiOzone = _calculateOzoneAqi(ozone);
    double aqiNo2 = _calculateNo2Aqi(no2);
    double aqiPm25 = _calculatePm25Aqi(pm25);

    // AQI is the maximum of the individual pollutant indices
    return [aqiCo, aqiOzone, aqiNo2, aqiPm25].reduce(math.max);
  }

  double _calculatePm25Aqi(double c) {
    if (c <= 12.0) return _linearInterpolate(c, 0, 12.0, 0, 50);
    if (c <= 35.4) return _linearInterpolate(c, 12.1, 35.4, 51, 100);
    if (c <= 55.4) return _linearInterpolate(c, 35.5, 55.4, 101, 150);
    if (c <= 150.4) return _linearInterpolate(c, 55.5, 150.4, 151, 200);
    if (c <= 250.4) return _linearInterpolate(c, 150.5, 250.4, 201, 300);
    if (c <= 350.4) return _linearInterpolate(c, 250.5, 350.4, 301, 400);
    return _linearInterpolate(c, 350.5, 500.4, 401, 500);
  }

  double _calculateCoAqi(double c) {
    if (c <= 4.4) return _linearInterpolate(c, 0, 4.4, 0, 50);
    if (c <= 9.4) return _linearInterpolate(c, 4.5, 9.4, 51, 100);
    if (c <= 12.4) return _linearInterpolate(c, 9.5, 12.4, 101, 150);
    if (c <= 15.4) return _linearInterpolate(c, 12.5, 15.4, 151, 200);
    if (c <= 30.4) return _linearInterpolate(c, 15.5, 30.4, 201, 300);
    if (c <= 40.4) return _linearInterpolate(c, 30.5, 40.4, 301, 400);
    return _linearInterpolate(c, 40.5, 50.4, 401, 500);
  }

  double _calculateOzoneAqi(double c) {
    if (c <= 54) return _linearInterpolate(c, 0, 54, 0, 50);
    if (c <= 70) return _linearInterpolate(c, 55, 70, 51, 100);
    if (c <= 85) return _linearInterpolate(c, 71, 85, 101, 150);
    if (c <= 105) return _linearInterpolate(c, 86, 105, 151, 200);
    if (c <= 200) return _linearInterpolate(c, 106, 200, 201, 300);
    return 301; // Hazardous
  }

  double _calculateNo2Aqi(double c) {
    if (c <= 53) return _linearInterpolate(c, 0, 53, 0, 50);
    if (c <= 100) return _linearInterpolate(c, 54, 100, 51, 100);
    if (c <= 360) return _linearInterpolate(c, 101, 360, 101, 150);
    if (c <= 649) return _linearInterpolate(c, 361, 649, 151, 200);
    if (c <= 1249) return _linearInterpolate(c, 650, 1249, 201, 300);
    return 301;
  }

  double _linearInterpolate(double c, double cLow, double cHigh, double iLow, double iHigh) {
    if (c < cLow) return iLow;
    if (c > cHigh) return iHigh;
    return ((iHigh - iLow) / (cHigh - cLow)) * (c - cLow) + iLow;
  }

  List<double> _softmax(List<double> x) {
    double max = x.reduce((a, b) => a > b ? a : b);
    List<double> exp = x.map((e) => math.exp(e - max)).toList();
    double sum = exp.reduce((a, b) => a + b);
    return exp.map((e) => e / sum).toList();
  }

  /// Classify an AQI category into UI info.
  static AqiCategory classifyCategory(String category) {
    switch (category.toLowerCase()) {
      case 'good':
        return const AqiCategory(
          label: 'GOOD',
          description: 'Air quality is satisfactory and poses little or no risk.',
          color: 0xFF4CAF50, // Green
          icon: 'check_circle',
        );
      case 'moderate':
        return const AqiCategory(
          label: 'MODERATE',
          description: 'Air quality is acceptable. Some pollutants may pose a risk for sensitive groups.',
          color: 0xFFFF9800, // Orange
          icon: 'info',
        );
      case 'unhealthy':
        return const AqiCategory(
          label: 'UNHEALTHY',
          description: 'Everyone may begin to experience health effects. Sensitive groups may experience more serious effects.',
          color: 0xFFFF5722, // Deep Orange
          icon: 'error',
        );
      case 'hazardous':
        return const AqiCategory(
          label: 'HAZARDOUS',
          description: 'Health warnings of emergency conditions. The entire population is likely to be affected.',
          color: 0xFFF44336, // Red
          icon: 'report',
        );
      default:
        return const AqiCategory(
          label: 'UNKNOWN',
          description: 'Air quality data unavailable or category unknown.',
          color: 0xFF9E9E9E, // Grey
          icon: 'help_outline',
        );
    }
  }


  /// Classify a numeric AQI value into a category.
  static AqiCategory classifyAqi(double aqi) {
    if (aqi <= 50) return classifyCategory('good');
    if (aqi <= 100) return classifyCategory('moderate');
    if (aqi <= 200) return classifyCategory('unhealthy');
    return classifyCategory('hazardous');
  }


  void dispose() {
    _isLoaded = false;
  }
}

class AqiCategory {
  final String label;
  final String description;
  final int color;
  final String icon;

  const AqiCategory({
    required this.label,
    required this.description,
    required this.color,
    required this.icon,
  });
}
