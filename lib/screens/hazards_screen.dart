import 'package:flutter/material.dart';

class HazardsScreen extends StatelessWidget {
  const HazardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              children: [
                const SizedBox(height: 110),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _heroSection(context),
                ),

                const SizedBox(height: 20),
                _aqiCard(
                  context: context,
                  title: "Good",
                  color: const Color(0xFFD1FAE5),
                  accent: Colors.green,
                  icon: Icons.check_circle,
                  desc: "Air quality is considered satisfactory, and air pollution poses little or no risk.",
                  items: const [
                    ["verified", "Ideal for all outdoor activities."],
                    ["air", "Ventilate indoor spaces freely."]
                  ],
                ),

                _aqiCard(
                  context: context,
                  title: "Moderate",
                  color: const Color(0xFFFEF9C3),
                  accent: Colors.orange,
                  icon: Icons.info,
                  desc: "Air quality is acceptable; however, there may be a moderate health concern for a very small number of people.",
                  items: const [
                    ["warning", "Sensitive individuals should limit exertion."],
                    ["timer", "Reduce long outdoor activity."]
                  ],
                ),

                _aqiCard(
                  context: context,
                  title: "Unhealthy",
                  color: const Color(0xFFFFEDD5),
                  accent: Colors.deepOrange,
                  icon: Icons.error,
                  desc: "Everyone may experience health effects; sensitive groups may be affected more.",
                  items: const [
                    ["masks", "Wear N95/FFP2 masks outdoors."],
                    ["home", "Close windows and use air purifiers."]
                  ],
                ),

                _aqiCard(
                  context: context,
                  title: "Hazardous",
                  color: const Color(0xFFFEE2E2),
                  accent: Colors.red,
                  icon: Icons.report,
                  desc: "Health alert: everyone may experience serious health effects. Emergency conditions.",
                  items: const [
                    ["dangerous", "Avoid all outdoor activity."],
                    ["medical_services", "Monitor respiratory symptoms."]
                  ],
                ),

                const SizedBox(height: 30),

                _environmentalRisks(context),

                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _hardwareSection(context),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
          _topBar(context),
        ],
      ),
      bottomNavigationBar: _bottomNav(context),
    );
  }
  Widget _topBar(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/profile'),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text("A",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Air Sense",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            ],
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }
  Widget _heroSection(BuildContext context) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Image.network(
                "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
                fit: BoxFit.cover,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.black.withValues(alpha: 0.2) : null,
                colorBlendMode: BlendMode.darken,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Atmospheric Threat Analysis",
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 1.5,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Safety & Mitigation",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Comprehensive breakdown of global environmental hazards and immediate safety protocols.",
                  style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget _aqiCard({
    required BuildContext context,
    required String title,
    required Color color,
    required Color accent,
    required IconData icon,
    required String desc,
    required List<List<String>> items,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? accent.withValues(alpha: 0.15) 
                    : color,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: accent)),
                    ],
                  ),
                  Icon(icon, color: accent, size: 30),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(desc,
                      style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
                  const SizedBox(height: 12),
                  const Text("Precautions",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...items.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Icon(_icon(e[0]), size: 16, color: accent),
                          const SizedBox(width: 8),
                          Expanded(child: Text(e[1], style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8)))),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  IconData _icon(String name) {
    switch (name) {
      case "verified": return Icons.verified;
      case "air": return Icons.air;
      case "warning": return Icons.warning;
      case "timer": return Icons.timer;
      case "masks": return Icons.masks;
      case "home": return Icons.home;
      case "dangerous": return Icons.dangerous;
      case "medical_services": return Icons.medical_services;
      default: return Icons.circle;
    }
  }
  Widget _environmentalRisks(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Global Environmental Risks",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(height: 16),
          _riskItem(context, Icons.fireplace, "Wildfire Smoke", "Particulate matter that can travel thousands of miles, impacting lung health."),
          _riskItem(context, Icons.factory, "Industrial Emissions", "Sulphur dioxide and Nitrogen oxides from factory zones and power plants."),
          _riskItem(context, Icons.grass, "Pollen Surges", "Seasonal high-allergen periods that exacerbate respiratory sensitivities."),
          _riskItem(context, Icons.volcano, "Volcanic Ash", "Fine rock and glass particles that can cause severe immediate AQI drops."),
        ],
      ),
    );
  }

  Widget _riskItem(BuildContext context, IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(desc, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _hardwareSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Recommended Hardware",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _hardwareCard(context, Icons.filter_alt, "HEPA FILTER", "Grade H13")),
              const SizedBox(width: 10),
              Expanded(child: _hardwareCard(context, Icons.sensors, "SENSOR HUB", "PM2.5 Laser")),
            ],
          )
        ],
      ),
    );
  }

  Widget _hardwareCard(BuildContext context, IconData icon, String title, String sub) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 30),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4))),
          Text(sub, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
  Widget _bottomNav(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 30),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(context, Icons.dashboard_rounded, "Home", "/home", false),
          _navIcon(context, Icons.analytics_rounded, "Predict", "/prediction", false),
          _navIcon(context, Icons.history_rounded, "History", "/history", false),
          _navIcon(context, Icons.person_rounded, "Profile", "/profile", false),
        ],
      ),
    );
  }

  Widget _navIcon(BuildContext context, IconData icon, String label, String route, bool active) {
    final color = active 
      ? Theme.of(context).colorScheme.primary 
      : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4);

    return GestureDetector(
      onTap: () {
        if (!active) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: active ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

