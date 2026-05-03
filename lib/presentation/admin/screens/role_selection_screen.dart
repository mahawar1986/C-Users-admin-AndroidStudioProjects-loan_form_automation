import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import 'form_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  final String token;

  const RoleSelectionScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Role'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Who are you?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select your role in this loan application',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              _RoleCard(
                icon: Icons.person,
                title: 'Applicant',
                description: 'Primary loan applicant',
                color: AppTheme.primary,
                onTap: () => _navigateToForm(context, 'applicant'),
              ),
              const SizedBox(height: 16),
              _RoleCard(
                icon: Icons.people,
                title: 'Co-Applicant',
                description: 'Joint applicant for the loan',
                color: AppTheme.accent,
                onTap: () => _navigateToForm(context, 'co_applicant'),
              ),
              const SizedBox(height: 16),
              _RoleCard(
                icon: Icons.shield,
                title: 'Guarantor',
                description: 'Loan guarantor',
                color: Colors.orange.shade300,
                onTap: () => _navigateToForm(context, 'guarantor'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToForm(BuildContext context, String role) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormScreen(token: token, role: role),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
