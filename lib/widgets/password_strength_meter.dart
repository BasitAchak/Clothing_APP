import 'package:flutter/material.dart';

class PasswordStrengthMeter extends StatelessWidget {
  final String password;

  const PasswordStrengthMeter({super.key, required this.password});

  double _calculateStrength() {
    int score = 0;

    if (password.length >= 6) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    return score / 4;
  }

  String _getStrengthText() {
    final strength = _calculateStrength();

    if (strength == 0) return 'Weak';
    if (strength <= 0.5) return 'Fair';
    if (strength <= 0.75) return 'Good';

    return 'Strong';
  }

  Color _getStrengthColor() {
    final strength = _calculateStrength();

    if (strength == 0) return Colors.red;
    if (strength <= 0.5) return Colors.orange;
    if (strength <= 0.75) return Colors.blue;

    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: _calculateStrength(),
          backgroundColor: Colors.grey[300],
          color: _getStrengthColor(),
          minHeight: 5,
        ),
        const SizedBox(height: 4),
        Text(
          'Password Strength: ${_getStrengthText()}',
          style: TextStyle(color: _getStrengthColor()),
        ),
      ],
    );
  }
}