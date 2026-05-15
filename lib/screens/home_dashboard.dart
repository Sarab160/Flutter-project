import 'package:flutter/material.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int currentIndex = 0;

  void onNavTap(int index) {
    setState(() {
      currentIndex = index;
    });

    if (index == 1) {
      Navigator.pushNamed(context, '/prediction');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/history');
    } else if (index == 3) {
      Navigator.pushNamed(context, '/insights');
    } else if (index == 4) {
      Navigator.pushNamed(context, '/hazards');
    }

    debugPrint("Bottom Nav Index: $index");
  }

  void onPrediction() {
    debugPrint("Prediction Clicked");
    Navigator.pushNamed(context, '/prediction');
  }

  void onInsights() {
    debugPrint("Insights Clicked");
    Navigator.pushNamed(context, '/insights');
  }

  void onHazards() {
    debugPrint("Hazards Clicked");
    Navigator.pushNamed(context, '/hazards');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
            border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/profile'),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primaryContainer,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "A",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Text(
                      "Air Sense",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 48), 
              ],
            ),
          ),
        ),
      ),

      
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STATUS
            Text(
              "CURRENT STATUS: OPTIMAL",
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 2,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Air quality in your area is excellent today. Predictive models suggest clear conditions for the next 48 hours.",
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 28),

        
            DashboardCard(
              icon: Icons.analytics,
              iconBg: Theme.of(context).colorScheme.primaryContainer,
              iconColor: Theme.of(context).colorScheme.primary,
              title: "Make Prediction",
              subtitle:
                  "Run high-fidelity atmospheric simulations for the next 7 days.",
              onTap: onPrediction,
            ),

            const SizedBox(height: 20),

            DashboardCard(
              icon: Icons.query_stats,
              iconBg: Theme.of(context).colorScheme.secondaryContainer,
              iconColor: Theme.of(context).colorScheme.secondary,
              title: "Model Insights",
              subtitle:
                  "Deep dive into neural network data sources and reliability scores.",
              onTap: onInsights,
            ),

            const SizedBox(height: 20),

            DashboardCard(
              icon: Icons.warning,
              iconBg: Theme.of(context).colorScheme.errorContainer,
              iconColor: Theme.of(context).colorScheme.error,
              title: "Safety Hazards",
              subtitle:
                  "Active alerts for wildfire smoke, industrial emissions, and pollen peaks.",
              onTap: onHazards,
              leftBorder: true,
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
          border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black.withValues(alpha: 0.05))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: BottomNavItem(
                icon: Icons.dashboard,
                label: "Home",
                active: currentIndex == 0,
                onTap: () => onNavTap(0),
              ),
            ),
            Expanded(
              child: BottomNavItem(
                icon: Icons.analytics,
                label: "Predict",
                active: currentIndex == 1,
                onTap: () => onNavTap(1),
              ),
            ),
            Expanded(
              child: BottomNavItem(
                icon: Icons.history,
                label: "History",
                active: currentIndex == 2,
                onTap: () => onNavTap(2),
              ),
            ),
            Expanded(
              child: BottomNavItem(
                icon: Icons.query_stats,
                label: "Insights",
                active: currentIndex == 3,
                onTap: () => onNavTap(3),
              ),
            ),
            Expanded(
              child: BottomNavItem(
                icon: Icons.warning,
                label: "Hazards",
                active: currentIndex == 4,
                onTap: () => onNavTap(4),
              ),
            ),
            Expanded(
              child: BottomNavItem(
                icon: Icons.person,
                label: "Profile",
                active: false,
                onTap: () => Navigator.pushNamed(context, '/profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool leftBorder;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.leftBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Theme.of(context).dividerColor),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (leftBorder)
              Container(
                width: 4,
                height: 90,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: iconBg,
                    ),
                    child: Icon(icon, color: iconColor),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= BOTTOM NAV ITEM =================

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active 
      ? Theme.of(context).colorScheme.primary 
      : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
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
    );
  }
}
