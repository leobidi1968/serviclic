import 'package:flutter/material.dart';
import '../../core/models/usuario.dart';
import '../../core/services/database_service.dart';
import '../../shared/theme/app_theme.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Usuario? _usuario;

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    final u = await DatabaseService().getUsuario();
    if (mounted) setState(() => _usuario = u);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPerfilCard(),
                    const SizedBox(height: 20),
                    _buildStats(),
                    const SizedBox(height: 24),
                    _buildSeccion(
                      Icons.access_time_outlined,
                      'Mis actividades',
                      [
                        _ItemData(icon: Icons.send_outlined, iconColor: const Color(0xFF3B82F6), title: 'Consultas enviadas', subtitle: 'Ver estado de tus consultas', badge: '5'),
                        _ItemData(icon: Icons.calendar_month_outlined, iconColor: AppTheme.success, title: 'Citas agendadas', subtitle: 'Gestioná tus próximas citas', badge: '3', badgeColor: AppTheme.success),
                        _ItemData(icon: Icons.description_outlined, iconColor: const Color(0xFFA855F7), title: 'Presupuestos recibidos', subtitle: 'Revisá presupuestos y propuestas', badge: '4', badgeColor: const Color(0xFFA855F7)),
                        _ItemData(icon: Icons.check_circle_outline, iconColor: AppTheme.textSecondary, title: 'Trabajos realizados', subtitle: 'Historial de trabajos completados'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSeccion(
                      Icons.tune_outlined,
                      'Preferencias',
                      [
                        _ItemData(icon: Icons.work_outline, iconColor: const Color(0xFF3B82F6), title: 'Rubro de interés', subtitle: 'Electricistas, Plomeros, Pintores'),
                        _ItemData(icon: Icons.location_on_outlined, iconColor: AppTheme.success, title: 'Ubicación', subtitle: '${_usuario?.ciudad ?? ''}, ${_usuario?.departamento ?? ''}'),
                        _ItemData(icon: Icons.notifications_outlined, iconColor: const Color(0xFFA855F7), title: 'Notificaciones', subtitle: 'Gestioná tus preferencias'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSeccion(
                      Icons.shield_outlined,
                      'Cuenta y seguridad',
                      [
                        _ItemData(icon: Icons.person_outline, iconColor: const Color(0xFF3B82F6), title: 'Editar perfil', subtitle: 'Actualizá tu información personal', onTap: () => Navigator.pushNamed(context, '/registro')),
                        _ItemData(icon: Icons.lock_outline, iconColor: AppTheme.success, title: 'Seguridad', subtitle: 'Contraseña, verificación en dos pasos'),
                        _ItemData(icon: Icons.security_outlined, iconColor: const Color(0xFFA855F7), title: 'Privacidad', subtitle: 'Configurá tu privacidad y datos'),
                        _ItemData(icon: Icons.help_outline, iconColor: AppTheme.primary, title: 'Centro de ayuda', subtitle: 'Preguntas frecuentes y soporte', isBlue: true),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildPremiumBanner(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mi perfil',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                ),
                Text(
                  'Gestioná tu cuenta y preferencias.',
                  style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.settings_outlined, color: AppTheme.textSecondary),
              const SizedBox(height: 6),
              OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/empresa-registro'),
                icon: const Icon(Icons.business_outlined, size: 15),
                label: const Text('Registrarse como empresa'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primary,
                  side: const BorderSide(color: AppTheme.primary, width: 1.5),
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerfilCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: AppTheme.primary.withValues(alpha: 0.15),
                child: const Icon(Icons.person, size: 36, color: AppTheme.primary),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt, size: 13, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _usuario?.nombre ?? '...',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textSecondary),
                    const SizedBox(width: 2),
                    Text(
                      '${_usuario?.ciudad ?? ''}, ${_usuario?.departamento ?? ''}',
                      style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified, size: 13, color: AppTheme.primary),
                      SizedBox(width: 3),
                      Text('Usuario verificado', style: TextStyle(fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _StatItem(value: '0', label: 'Búsquedas\nrealizadas', icon: Icons.search_outlined),
          _vDivider(),
          _StatItem(value: '0', label: 'Favoritos\nguardados', icon: Icons.favorite_outline),
          _vDivider(),
          _StatItem(value: '0', label: 'Consultas\nrealizadas', icon: Icons.chat_bubble_outline),
          _vDivider(),
          _StatItem(value: '0', label: 'Citas\nagendadas', icon: Icons.calendar_today_outlined),
        ],
      ),
    );
  }

  Widget _vDivider() => Container(width: 1, height: 40, color: Colors.black.withValues(alpha: 0.08));

  Widget _buildSeccion(IconData sectionIcon, String titulo, List<_ItemData> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(sectionIcon, size: 18, color: AppTheme.textPrimary),
            const SizedBox(width: 8),
            Text(titulo, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++) ...[
                _buildItem(items[i]),
                if (i < items.length - 1)
                  Divider(height: 1, indent: 56, endIndent: 16, color: Colors.black.withValues(alpha: 0.06)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItem(_ItemData item) {
    return InkWell(
      onTap: item.onTap ?? () {},
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: item.iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, size: 18, color: item.iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: item.isBlue ? AppTheme.primary : AppTheme.textPrimary,
                    ),
                  ),
                  Text(item.subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                ],
              ),
            ),
            if (item.badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: item.badgeColor ?? AppTheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  item.badge!,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: item.badgeColor != null ? Colors.white : AppTheme.textSecondary,
                  ),
                ),
              )
            else
              const Icon(Icons.chevron_right, size: 18, color: AppTheme.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A5F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(color: AppTheme.gold, shape: BoxShape.circle),
            child: const Icon(Icons.star, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('¡Ganá beneficios con Premium!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                Text('Accedé a descuentos exclusivos y atención prioritaria.', style: TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white, width: 1),
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Conocer más', style: TextStyle(fontSize: 12)),
                SizedBox(width: 2),
                Icon(Icons.chevron_right, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBar _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 4,
      onTap: (i) {
        if (i == 0) Navigator.pushReplacementNamed(context, '/home');
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.primary,
      unselectedItemColor: AppTheme.textSecondary,
      selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontSize: 11),
      elevation: 8,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.search_outlined), activeIcon: Icon(Icons.search), label: 'Buscar'),
        BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), activeIcon: Icon(Icons.location_on), label: 'Cerca de mí'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), activeIcon: Icon(Icons.favorite), label: 'Favoritos'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label, required this.icon});
  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppTheme.primary),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary, height: 1.3)),
        ],
      ),
    );
  }
}

class _ItemData {
  const _ItemData({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.badge,
    this.badgeColor,
    this.onTap,
    this.isBlue = false,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String? badge;
  final Color? badgeColor;
  final VoidCallback? onTap;
  final bool isBlue;
}
