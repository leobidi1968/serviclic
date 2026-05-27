import 'package:flutter/material.dart';
import '../../shared/theme/app_theme.dart';

class EmpresaRegistroScreen extends StatelessWidget {
  const EmpresaRegistroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Registrarse como empresa'),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimary,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildStepper(),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.business_outlined, color: AppTheme.primary, size: 32),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Completá la información de tu negocio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textPrimary)),
                          SizedBox(height: 2),
                          Text('Esta información será visible para los usuarios de la app.', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Text(
                'Wizard de registro — próximamente',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      children: [
        _Step(number: 1, label: 'Información\nbásica', active: true),
        _StepLine(active: false),
        _Step(number: 2, label: 'Documentación', active: false),
        _StepLine(active: false),
        _Step(number: 3, label: 'Revisión', active: false),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.label, required this.active});
  final int number;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: active ? AppTheme.primary : AppTheme.surface,
            shape: BoxShape.circle,
            border: active ? null : Border.all(color: AppTheme.textSecondary.withValues(alpha: 0.3)),
          ),
          child: Center(
            child: Text(
              '$number',
              style: TextStyle(
                color: active ? Colors.white : AppTheme.textSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: active ? AppTheme.primary : AppTheme.textSecondary,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _StepLine extends StatelessWidget {
  const _StepLine({required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20),
        color: active ? AppTheme.primary : AppTheme.textSecondary.withValues(alpha: 0.2),
      ),
    );
  }
}
