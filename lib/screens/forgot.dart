import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/shared_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isCodeMode = false;

  Future<void> _sendReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showSnackBar("Please enter your email address");
      return;
    }
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSnackBar("Reset link sent! Click it in your email, or copy the 'oobCode' to use here.");
    } on FirebaseAuthException catch (e) {
      _showSnackBar(e.message ?? "Error");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetWithCode() async {
    final code = _codeController.text.trim();
    final newPw = _newPasswordController.text.trim();
    final confirmPw = _confirmPasswordController.text.trim();

    if (code.isEmpty || newPw.isEmpty) {
      _showSnackBar("Please enter the code and your new password");
      return;
    }

    if (newPw != confirmPw) {
      _showSnackBar("Passwords do not match");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.confirmPasswordReset(
        code: code,
        newPassword: newPw,
      );
      if (mounted) {
        _showSnackBar("Password successfully reset! You can now log in.");
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      _showSnackBar(e.message ?? "Failed to reset password");
    } catch (e) {
      _showSnackBar("Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _goToSignIn(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient glow
          Positioned(
            top: -120,
            left: -100,
            child: GlowEffect(color: Theme.of(context).colorScheme.primary, opacity: 0.12),
          ),
          Positioned(
            bottom: -120,
            right: -100,
            child: GlowEffect(color: Theme.of(context).colorScheme.tertiary, opacity: 0.12),
          ),

          // Particle background
          ParticleBackground(color: Theme.of(context).colorScheme.primary),

          // Main content
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Icon(
                                Icons.eco,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Air Sense",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => _goToSignIn(context),
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_back,
                                size: 18,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                              SizedBox(width: 6),
                              Text(
                                "BACK",
                                style: TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 2,
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Glass Card
                  Container(
                    width: 420,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _isCodeMode 
                            ? "Enter the code from your email and your new password to complete the reset."
                            : "Enter the email address associated with your account and we'll send you a link to reset your password.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 25),

                        if (!_isCodeMode) ...[
                          // Email label
                          Text(
                            "EMAIL ADDRESS",
                            style: TextStyle(
                              fontSize: 11,
                              letterSpacing: 2,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.mail, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
                              hintText: "alex@airsense.com",
                              hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)),
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ] else ...[
                          // CODE FIELD
                          _manualField(_codeController, "RESET CODE (oobCode)", Icons.vibration),
                          const SizedBox(height: 15),
                          _manualField(_newPasswordController, "NEW PASSWORD", Icons.lock_outline, obscure: true),
                          const SizedBox(height: 15),
                          _manualField(_confirmPasswordController, "CONFIRM PASSWORD", Icons.verified_user, obscure: true),
                        ],

                        const SizedBox(height: 25),

                        // Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : (_isCodeMode ? _resetWithCode : _sendReset),
                            icon: _isLoading 
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.send, size: 18),
                            label: Text(
                              _isLoading 
                                ? (_isCodeMode ? "Resetting..." : "Sending...") 
                                : (_isCodeMode ? "Reset Password" : "Send Reset Link"),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Toggle Mode
                        Center(
                          child: TextButton(
                            onPressed: () => setState(() => _isCodeMode = !_isCodeMode),
                            child: Text(
                              _isCodeMode ? "Back to Email Link" : "I have a reset code",
                              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 13),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 15),

                        Center(
                          child: GestureDetector(
                            onTap: () => _goToSignIn(context),
                            child: Text(
                              "Remember your password? Sign In",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Footer text
                  Text(
                    "PRECISION ENVIRONMENTAL MONITORING",
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 2,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _manualField(TextEditingController controller, String label, IconData icon, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 11, letterSpacing: 1.5, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), size: 20),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

