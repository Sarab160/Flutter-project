import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/theme_service.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Colors are fetched dynamically using Theme.of(context)

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Stack(
        children: [
          _mainContent(context, user),

          // TOP BAR
          _topBar(context),
        ],
      ),
      bottomNavigationBar: _bottomNav(context),
    );
  }

  // ---------------- MAIN CONTENT ----------------
  Widget _mainContent(BuildContext context, User? user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 110, bottom: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _profileHeader(context, user),

                const SizedBox(height: 20),

                // GRID
                LayoutBuilder(
                  builder: (context, c) {
                    bool wide = c.maxWidth > 700;

                    return GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: wide ? 2 : 1,
                        childAspectRatio: wide ? 1.5 : 1.3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      children: [
                        _accountCard(context, user),
                        _preferencesCard(context),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 30),

                // LOGOUT
                _logoutButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- TOP BAR ----------------
  Widget _topBar(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.only(top: 40, left: 10, right: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 5),
          Text(
            "Profile Settings",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- PROFILE HEADER ----------------
  Widget _profileHeader(BuildContext context, User? user) {
    final initials = (user?.displayName?.isNotEmpty == true)
        ? user!.displayName![0].toUpperCase()
        : (user?.email?.isNotEmpty == true
            ? user!.email![0].toUpperCase()
            : "?");

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(initials,
                    style: const TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
              const Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.verified, size: 16, color: Colors.white),
                ),
              )
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user?.displayName ?? "Eco Sentinel",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("Air Sense Analyst",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/edit_profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Edit Profile",
                      style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- CARDS ----------------
  Widget _accountCard(BuildContext context, User? user) {
    return _glassCard(
      context: context,
      title: "Account Details",
      icon: Icons.account_circle,
      child: Column(
        children: [
          _InfoTile("Email", user?.email ?? "Not logged in"),
          const _InfoTile("Status", "Standard Member"),
        ],
      ),
    );
  }

  Widget _preferencesCard(BuildContext context) {
    return _glassCard(
      context: context,
      title: "App Preferences",
      icon: Icons.tune,
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeService.themeMode,
        builder: (context, mode, child) {
          return Column(
            children: [
              _Toggle(
                "Dark Mode",
                mode == ThemeMode.dark,
                onChanged: (val) => themeService.toggleTheme(val),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _glassCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 10),
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(child: child),
        ],
      ),
    );
  }

  // ---------------- SMALL WIDGETS ----------------
  Widget _logoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await authService.signOut();
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.05),
          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 10),
            Text("Sign Out from Air Sense",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // ---------------- BOTTOM NAV ----------------
  Widget _bottomNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
        border: Border(top: BorderSide(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
              child:
                  _navIcon(context, Icons.dashboard_outlined, "/home", false)),
          Expanded(
              child: _navIcon(
                  context, Icons.analytics_outlined, "/prediction", false)),
          Expanded(child: _navIcon(context, Icons.history, "/history", false)),
          Expanded(
              child: _navIcon(context, Icons.query_stats, "/insights", false)),
          Expanded(
              child: _navIcon(
                  context, Icons.warning_amber_rounded, "/hazards", false)),
          Expanded(child: _navIcon(context, Icons.person, "/profile", true)),
        ],
      ),
    );
  }

  Widget _navIcon(
      BuildContext context, IconData icon, String route, bool active) {
    return GestureDetector(
      onTap: () {
        if (!active) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: active ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            size: 26,
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              route == "/home"
                  ? "Home"
                  : route == "/prediction"
                      ? "Predict"
                      : route == "/history"
                          ? "History"
                          : route == "/insights"
                              ? "Insights"
                              : route == "/hazards"
                                  ? "Hazards"
                                  : "Profile",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: active ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                fontSize: 10,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- HELPERS ----------------
class _InfoTile extends StatelessWidget {
  final String t, v;
  const _InfoTile(this.t, this.v);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title:
          Text(t, style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
      subtitle: Text(v,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface)),
    );
  }
}

class _Toggle extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _Toggle(this.title, this.value, {required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontSize: 15)),
      value: value,
      onChanged: onChanged,
      activeThumbColor: Theme.of(context).colorScheme.primary,
    );
  }
}
