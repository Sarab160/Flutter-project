import 'package:flutter/material.dart';

class ModelInsightsScreen extends StatelessWidget {
  const ModelInsightsScreen({super.key});

  // Theme-aware colors defined in build()

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final primaryContainer = Theme.of(context).colorScheme.primaryContainer;
    final tertiary = Theme.of(context).colorScheme.tertiary;
    final textPrimary = Theme.of(context).colorScheme.onSurface;
    final textSecondary = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // BACKGROUND EFFECTS
          Positioned(
            top: -120,
            left: -120,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primary.withValues(alpha: 0.03),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -120,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: tertiary.withValues(alpha: 0.03),
              ),
            ),
          ),

          Column(
            children: [
              // TOP APP BAR
              Container(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/profile'),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: primaryContainer,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primary.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "A",
                            style: TextStyle(
                              color: primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                        const SizedBox(width: 12),
                        Text(
                          "Air Sense",
                          style: TextStyle(
                            color: primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 28), // Spacer to balance the layout after removing search
                  ],
                ),
              ),

              // MAIN CONTENT
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 140),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TITLE SECTION
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "SYSTEM ANALYSIS",
                            style: TextStyle(
                              color: primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Model Insights",
                          style: TextStyle(
                            fontSize: 48,
                            height: 1.1,
                            letterSpacing: -2,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: 320,
                        child: Text(
                          "Global atmospheric analysis based on 23,463 city-level sensor readings. We utilize a Multi-Layer Perceptron (MLP) Artificial Neural Network to predict AQI categories with high precision.",
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // MODEL ACCURACY CARD
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: Theme.of(context).dividerColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "MODEL\nACCURACY",
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            height: 1.1,
                                            color: Theme.of(context).colorScheme.onSurface,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Confidence Level over 24h",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: primaryContainer,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(color: primary.withValues(alpha: 0.2)),
                                  ),
                                  child: Text(
                                    "98.4% CORRELATION",
                                    style: TextStyle(
                                      color: primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            // CHART
                            Container(
                              height: 192,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _bar(140, primary),
                                  _bar(96, primary.withValues(alpha: 0.7)),
                                  _bar(155, Theme.of(context).colorScheme.secondary),
                                  _bar(125, Theme.of(context).colorScheme.secondary.withValues(alpha: 0.7)),
                                  _bar(175, tertiary),
                                  _bar(125, tertiary.withValues(alpha: 0.7)),
                                  _bar(70, primary.withValues(alpha: 0.5)),
                                  _bar(140, primary),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Divider(color: Theme.of(context).dividerColor),
                            const SizedBox(height: 16),
                            Text(
                              "The model achieved an outstanding 98.4% test accuracy during validation, ensuring reliable air quality classifications for city environments.",
                              style: TextStyle(fontSize: 13, color: textSecondary, height: 1.4),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // MODEL ARCHITECTURE CARD
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: Theme.of(context).dividerColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ANN Architecture",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPrimary),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "TensorFlow-based Sequential Model:",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primary),
                            ),
                            const SizedBox(height: 12),
                            _architectureStep(Icons.login, "Input Layer", "4 Environmental Features", primary, textSecondary, textPrimary),
                            _architectureStep(Icons.layers, "Dense Layer 1", "11 Neurons (ReLU)", primary, textSecondary, textPrimary),
                            _architectureStep(Icons.layers, "Dense Layer 2", "10 Neurons (ReLU)", primary, textSecondary, textPrimary),
                            _architectureStep(Icons.layers, "Dense Layer 3", "8 Neurons (ReLU)", primary, textSecondary, textPrimary),
                            _architectureStep(Icons.layers, "Dense Layer 4", "7 Neurons (ReLU)", primary, textSecondary, textPrimary),
                            _architectureStep(Icons.logout, "Output Layer", "6 Categories (Softmax)", primary, textSecondary, textPrimary),
                            const SizedBox(height: 16),
                            Text(
                              "This deep neural network was trained using the Adam optimizer and Sparse Categorical Crossentropy loss function to optimize for multi-class classification.",
                              style: TextStyle(fontSize: 12, color: textSecondary, height: 1.4),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // DATASET OVERVIEW CARD
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: Theme.of(context).dividerColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Dataset Overview",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: textPrimary,
                                  ),
                                ),
                                Icon(Icons.analytics, color: primary),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _infoRow("Total Data Points", "23,463 Samples", context, textSecondary, textPrimary),
                            _infoRow("Unique Cities", "23,462 Locations", context, textSecondary, textPrimary),
                            _infoRow("Primary Risk", "PM2.5 AQI", context, textSecondary, textPrimary),
                            _infoRow("Most Common", "Good (42.3%)", context, textSecondary, textPrimary),
                            _infoRow("Average AQI", "72.01 (Moderate)", context, textSecondary, textPrimary),
                            _infoRow("Update Frequency", "Static CSV Dataset", context, textSecondary, textPrimary),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // BOTTOM NAVIGATION
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 30),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(child: _navItem(context, Icons.dashboard_outlined, "Home", "/home", false, primary, textSecondary)),
                  Expanded(child: _navItem(context, Icons.analytics_outlined, "Predict", "/prediction", false, primary, textSecondary)),
                  Expanded(child: _navItem(context, Icons.history, "History", "/history", false, primary, textSecondary)),
                  Expanded(child: _navItem(context, Icons.query_stats, "Insights", "/insights", true, primary, textSecondary)),
                  Expanded(child: _navItem(context, Icons.warning_amber_rounded, "Hazards", "/hazards", false, primary, textSecondary)),
                  Expanded(child: _navItem(context, Icons.person_outline, "Profile", "/profile", false, primary, textSecondary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _bar(double height, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        constraints: const BoxConstraints(maxWidth: 32),
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(999), bottom: Radius.circular(999)),
        ),
      ),
    );
  }

  static Widget _infoRow(String title, String value, BuildContext context, Color textSecondary, Color textPrimary) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title, style: TextStyle(color: textSecondary, fontSize: 15))),
          const SizedBox(width: 8),
          Text(value, style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1)),
        ],
      ),
    );
  }

  static Widget _navItem(BuildContext context, IconData icon, String title, String route, bool active, Color primary, Color textSecondary) {
    return GestureDetector(
      onTap: () {
        if (!active) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: active ? primary : textSecondary, size: 26),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: active ? primary : textSecondary,
                fontSize: 10,
                fontWeight: active ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _architectureStep(IconData icon, String layer, String detail, Color primary, Color textSecondary, Color textPrimary) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 14, color: primary),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(layer, style: TextStyle(fontSize: 13, color: textSecondary)),
                Text(detail, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
