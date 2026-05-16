import 'package:flutter_test/flutter_test.dart';
import 'package:project_final/services/aqi_prediction_service.dart';

void main() {
  group('AqiPredictionService Logic Tests', () {
    test('AQI Category Classification', () {
      expect(AqiPredictionService.classifyAqi(25).label, 'GOOD');
      expect(AqiPredictionService.classifyAqi(75).label, 'MODERATE');
      expect(AqiPredictionService.classifyAqi(125).label, 'SENSITIVE');
      expect(AqiPredictionService.classifyAqi(175).label, 'UNHEALTHY');
      expect(AqiPredictionService.classifyAqi(250).label, 'VERY UNHEALTHY');
      expect(AqiPredictionService.classifyAqi(400).label, 'HAZARDOUS');
    });

    test('Unknown Category handling', () {
      final unknown = AqiPredictionService.classifyCategory('invalid_category');
      expect(unknown.label, 'UNKNOWN');
      expect(unknown.icon, 'help_outline');
    });
  });
}
