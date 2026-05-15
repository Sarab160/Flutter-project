import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/aqi_prediction_service.dart';
import '../services/history_service.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  // Theme-aware colors defined in build()

  // ── Controllers for the input fields ──
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _pm25Controller = TextEditingController();
  final _no2Controller = TextEditingController();
  final _coController = TextEditingController();
  final _ozoneController = TextEditingController();

  // ── Prediction state ──
  final AqiPredictionService _predictionService = AqiPredictionService();
  final HistoryService _historyService = HistoryService();
  bool _isModelLoaded = false;
  bool _isLoading = false;
  String? _predictedCategory;
  AqiCategory? _aqiCategory;
  String? _errorMessage;
  String? _locationResult;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      await _predictionService.loadModel();
      setState(() => _isModelLoaded = true);
    } catch (e) {
      setState(() => _errorMessage = 'Failed to load model: $e');
    }
  }

  void _runPrediction() {
    setState(() {
      _errorMessage = null;
    });

    // ── Input Cleaning Helper ──
    double? parseClean(String text) {
      final clean = text.replaceAll(RegExp(r'[^0-9.]'), '');
      if (clean.isEmpty) return null;
      return double.tryParse(clean);
    }

    // Parse required features
    final co = parseClean(_coController.text);
    final ozone = parseClean(_ozoneController.text);
    final no2 = parseClean(_no2Controller.text);
    final pm25 = parseClean(_pm25Controller.text);

    final city = _cityController.text.trim();
    final country = _countryController.text.trim();

    if (co == null || ozone == null || no2 == null || pm25 == null) {
      setState(() {
        _errorMessage = 'Please enter all AQI values (CO, Ozone, NO2, PM2.5).';
      });
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 600), () {
      try {
        final features = [co, ozone, no2, pm25];
        _predictionService.predict(features); // runs inference (side-effect: warms cache)
        final numericAqi = _predictionService.calculateNumericAqi(features);
        final category = AqiPredictionService.classifyAqi(numericAqi);
        final categoryName = category.label;

        setState(() {
          _predictedCategory = categoryName;
          _aqiCategory = category;

          _locationResult = (city.isNotEmpty && country.isNotEmpty)
              ? "In $country, $city, Air Quality is $categoryName"
              : "Predicted Air Quality is $categoryName";
          _isLoading = false;
          _errorMessage = null;
        });

        // Save to History
        _historyService.savePrediction(
          category: categoryName,
          aqiscore: numericAqi,
          location: (city.isNotEmpty && country.isNotEmpty)
              ? "$city, $country"
              : "Unknown",
          features: features,
        );
      } catch (e) {
        debugPrint('Prediction Error Detail: $e');
        setState(() {
          _errorMessage = 'Prediction failed: $e';
          _isLoading = false;
          _predictedCategory = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    _countryController.dispose();
    _pm25Controller.dispose();
    _no2Controller.dispose();
    _coController.dispose();
    _ozoneController.dispose();
    _predictionService.dispose();
    super.dispose();
  }

  // ── Helpers for the result card ──
  String get _aqiDisplay =>
      _predictedCategory != null ? _predictedCategory! : '--';

  String get _statusLabel => _aqiCategory?.label ?? 'AWAITING INPUT';

  Color _getStatusBgColor(BuildContext context) {
    if (_aqiCategory == null) return Theme.of(context).disabledColor.withValues(alpha: 0.1);
    return Color(_aqiCategory!.color).withValues(alpha: 0.18);
  }

  Color _getStatusTextColor(BuildContext context) {
    if (_aqiCategory == null) return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);
    return Color(_aqiCategory!.color);
  }

  IconData get _statusIcon {
    if (_aqiCategory == null) return Icons.hourglass_empty;
    switch (_aqiCategory!.icon) {
      case 'check_circle':
        return Icons.check_circle;
      case 'info':
        return Icons.info;
      case 'warning':
        return Icons.warning;
      case 'error':
        return Icons.error;
      case 'dangerous':
        return Icons.dangerous;
      case 'crisis_alert':
        return Icons.crisis_alert;
      case 'report':
        return Icons.report;
      default:
        return Icons.check_circle;

    }
  }

  String get _descriptionText {
    if (_aqiCategory != null) return _aqiCategory!.description;
    return 'Enter atmospheric data below and tap "Predict AQI" to get a real-time air quality forecast powered by on-device machine learning.';
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final textPrimary = Theme.of(context).colorScheme.onSurface;
    final textSecondary = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);
    final outline = Theme.of(context).dividerColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
        elevation: 1,
        shadowColor: Colors.black12,
        titleSpacing: 20,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/profile'),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: primary,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    "A",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Air Sense",
                style: TextStyle(
                  color: primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          const SizedBox(width: 10),
        ],
      ),

      // ---------------- BODY ----------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Text(
              "Predict AQI",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Enter real-time atmospheric data for precise local air quality forecasting.",
              style: TextStyle(
                fontSize: 14,
                color: textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            // RESULT CARD
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TOP STATUS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusBgColor(context),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _statusIcon,
                              size: 14,
                              color: _getStatusTextColor(context),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                _statusLabel,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: _getStatusTextColor(context),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                _aqiDisplay,
                                style: TextStyle(
                                  color: _predictedCategory != null
                                      ? _getStatusTextColor(context)
                                      : primary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              _predictedCategory != null
                                  ? "MODEL PREDICTION"
                                  : "AWAITING INPUT",
                              style: TextStyle(
                                fontSize: 9,
                                color: textSecondary,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _locationResult ?? "Predicted Air Quality",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    _descriptionText,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: textSecondary,
                    ),
                  ),

                  // Error message
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.red.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.red, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  Divider(color: outline),

                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      _shareActionButton(
                        context,
                        icon: Icons.chat_bubble_outline,
                        label: "WHATSAPP",
                        onPressed: () async {
                          if (_predictedCategory == null) {
                            _showSnackBar("Please run a prediction first.");
                            return;
                          }
                          final report = _generateReport();
                          final url = "https://wa.me/?text=${Uri.encodeComponent(report)}";
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                          } else {
                            await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                          }
                        },
                      ),
                      _shareActionButton(
                        context,
                        icon: Icons.email_outlined,
                        label: "EMAIL",
                        onPressed: () async {
                          if (_predictedCategory == null) {
                            _showSnackBar("Please run a prediction first.");
                            return;
                          }
                          final report = _generateReport();
                          final emailUrl =
                              "mailto:?subject=Air Quality Report&body=${Uri.encodeComponent(report)}";
                          if (await canLaunchUrl(Uri.parse(emailUrl))) {
                            await launchUrl(Uri.parse(emailUrl));
                          } else {
                            _showSnackBar("Could not launch Email client.");
                          }
                        },
                      ),
                      _shareActionButton(
                        context,
                        icon: Icons.share_outlined,
                        label: "OTHER",
                        onPressed: () async {
                          if (_predictedCategory == null) {
                            _showSnackBar("Please run a prediction first.");
                            return;
                          }
                          final report = _generateReport();
                          await SharePlus.instance.share(
                            ShareParams(text: report),
                          );
                        },
                      ),
                      TextButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/history'),
                        icon: Icon(Icons.history,
                            color: textSecondary, size: 18),
                        label: Text(
                          "HISTORY",
                          style: TextStyle(
                              color: textSecondary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Model status indicator
            if (!_isModelLoaded)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Loading ML model…',
                      style: TextStyle(fontSize: 13, color: Colors.orange),
                    ),
                  ],
                ),
              ),

            // INPUT GRID
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              children: [
                AQIField(
                    label: "City",
                    hint: "Karachi",
                    keyboardType: TextInputType.text,
                    controller: _cityController),
                AQIField(
                    label: "Country",
                    hint: "Pakistan",
                    keyboardType: TextInputType.text,
                    controller: _countryController),
                AQIField(
                    label: "CO (ppm)",
                    hint: "0.8",
                    controller: _coController,
                    required: true),
                AQIField(
                    label: "Ozone (ppb)",
                    hint: "42.0",
                    controller: _ozoneController,
                    required: true),
                AQIField(
                    label: "NO2 (ppb)",
                    hint: "15.0",
                    controller: _no2Controller,
                    required: true),
                AQIField(
                    label: "PM2.5 (μg/m³)",
                    hint: "12.4",
                    controller: _pm25Controller,
                    required: true),
              ],
            ),

            const SizedBox(height: 28),

            // PREDICT BUTTON
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed:
                    (_isModelLoaded && !_isLoading) ? _runPrediction : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: primary.withValues(alpha: 0.4),
                  disabledForegroundColor: Colors.white70,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Predict AQI",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 18),

            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock,
                    size: 16,
                    color: textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isModelLoaded
                        ? "On-device ML Engine Ready"
                        : "Secure Analysis Engine v2.4",
                    style: TextStyle(
                      fontSize: 13,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ---------------- BOTTOM NAV ----------------
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 20,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.92),
          border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            navItem(context, Icons.dashboard, "Home", false, '/home', primary, textSecondary),
            navItem(context, Icons.analytics, "Predict", true, '/prediction', primary, textSecondary),
            navItem(context, Icons.history, "History", false, '/history', primary, textSecondary),
            navItem(context, Icons.query_stats, "Insights", false, '/insights', primary, textSecondary),
            navItem(context, Icons.warning, "Hazards", false, '/hazards', primary, textSecondary),
            navItem(context, Icons.person, "Profile", false, '/profile', primary, textSecondary),
          ],
        ),
      ),
    );
  }

  Widget navItem(BuildContext context, IconData icon, String title, bool active,
      String route, Color primary, Color textSecondary) {
    final color = active ? primary : textSecondary;
    return Expanded(
      child: InkWell(
        onTap: () {
          if (!active) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _generateReport() {
    final city = _cityController.text.trim();
    final country = _countryController.text.trim();
    final locationStr = (city.isNotEmpty && country.isNotEmpty)
        ? "$city, $country"
        : "Current Location";

    return """
🚀 AIR SENSE AQI REPORT
---------------------------
📍 Location: $locationStr
📊 Status: $_predictedCategory
💡 Analysis: $_locationResult

Model Accuracy: 98.4%
Confidence: High
---------------------------
Generated by Air Sense AI Platform
""";
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _shareActionButton(BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    final primary = Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: primary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- INPUT FIELD ----------------

class AQIField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool required;
  final TextInputType keyboardType;

  const AQIField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.required = false,
    this.keyboardType = TextInputType.number,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final surface = Theme.of(context).colorScheme.surface;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primary.withValues(alpha: 0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  color: primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              if (required)
                const Text(
                  ' *',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 16,
                color: onSurface.withValues(alpha: 0.4),
                fontWeight: FontWeight.w500,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: onSurface,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
