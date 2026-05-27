import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/remote_service.dart';
import '../../shared/theme/app_theme.dart';
import 'empresa_notifier.dart';

class EmpresaRegistroScreen extends ConsumerStatefulWidget {
  const EmpresaRegistroScreen({super.key});

  @override
  ConsumerState<EmpresaRegistroScreen> createState() =>
      _EmpresaRegistroScreenState();
}

class _EmpresaRegistroScreenState
    extends ConsumerState<EmpresaRegistroScreen> {
  final _pageCtrl = PageController();
  int _paso = 0;

  // Step 1 controllers
  final _nombreCtrl = TextEditingController();
  final _rutCtrl = TextEditingController();
  final _ubicacionCtrl = TextEditingController();
  final _webCtrl = TextEditingController();
  final _whatsappCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();

  // Step 2 controllers
  final _razonSocialCtrl = TextEditingController();
  final _rutDoc = TextEditingController();

  // Step 1 selections
  int? _categoriaId;
  String? _categoriaLabel;
  String? _subcategoria;
  final List<String> _servicios = [];
  String? _aniosExperiencia;
  String? _zonaCobertura;

  static const _serviciosOpciones = [
    'Electricidad', 'Plomería', 'Pintura', 'Carpintería', 'Cerrajería',
    'Gas', 'Albañilería', 'Aire acondicionado', 'Limpieza', 'Otro',
  ];

  static const _aniosOpciones = [
    'Menos de 1 año', '1-2 años', '3-5 años', '6-10 años',
    '11-20 años', 'Más de 20 años',
  ];

  static const _subcategorias = [
    'Instalación', 'Reparación', 'Mantenimiento', 'Diagnóstico',
    'Presupuesto', 'Urgencia', 'Otro',
  ];

  @override
  void dispose() {
    _pageCtrl.dispose();
    _nombreCtrl.dispose();
    _rutCtrl.dispose();
    _ubicacionCtrl.dispose();
    _webCtrl.dispose();
    _whatsappCtrl.dispose();
    _correoCtrl.dispose();
    _telefonoCtrl.dispose();
    _descripcionCtrl.dispose();
    _razonSocialCtrl.dispose();
    _rutDoc.dispose();
    super.dispose();
  }

  void _irPaso(int paso) {
    setState(() => _paso = paso);
    _pageCtrl.animateToPage(
      paso,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  bool _validarStep1() {
    if (_nombreCtrl.text.trim().isEmpty) {
      _snack('Ingresá el nombre del negocio');
      return false;
    }
    if (_rutCtrl.text.trim().isEmpty) {
      _snack('Ingresá el RUT del negocio');
      return false;
    }
    if (_categoriaId == null) {
      _snack('Seleccioná una categoría principal');
      return false;
    }
    if (_whatsappCtrl.text.trim().isEmpty) {
      _snack('Ingresá el WhatsApp del negocio');
      return false;
    }
    if (_correoCtrl.text.trim().isEmpty) {
      _snack('Ingresá el correo del negocio');
      return false;
    }
    if (_servicios.isEmpty) {
      _snack('Seleccioná al menos un servicio');
      return false;
    }
    return true;
  }

  bool _validarStep2() {
    if (_razonSocialCtrl.text.trim().isEmpty) {
      _snack('Ingresá la razón social');
      return false;
    }
    if (_rutDoc.text.trim().isEmpty) {
      _snack('Ingresá el RUT');
      return false;
    }
    return true;
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
  }

  Future<void> _siguientePaso() async {
    if (_paso == 0) {
      if (!_validarStep1()) return;
      final ok = await ref.read(empresaNotifierProvider.notifier).submitStep1({
        'nombre': _nombreCtrl.text.trim(),
        'rut': _rutCtrl.text.trim(),
        'categoria_id': _categoriaId,
        'subcategoria': _subcategoria,
        'ubicacion_texto': _ubicacionCtrl.text.trim().isEmpty ? null : _ubicacionCtrl.text.trim(),
        'web': _webCtrl.text.trim().isEmpty ? null : _webCtrl.text.trim(),
        'whatsapp': _whatsappCtrl.text.trim(),
        'correo': _correoCtrl.text.trim(),
        'telefono': _telefonoCtrl.text.trim().isEmpty ? null : _telefonoCtrl.text.trim(),
        'descripcion': _descripcionCtrl.text.trim().isEmpty ? null : _descripcionCtrl.text.trim(),
        'servicios_ofrecidos': _servicios,
        'anios_experiencia': _aniosExperiencia == null ? null : _aniosToInt(_aniosExperiencia!),
        if (_zonaCobertura != null) 'zona_cobertura': [_zonaCobertura!],
      });
      if (ok && mounted) _irPaso(1);
    } else if (_paso == 1) {
      if (!_validarStep2()) return;
      final ok = await ref.read(empresaNotifierProvider.notifier).submitStep2({
        'razon_social': _razonSocialCtrl.text.trim(),
        'rut': _rutDoc.text.trim(),
      });
      if (ok && mounted) _irPaso(2);
    }
  }

  int? _aniosToInt(String s) {
    if (s == 'Menos de 1 año') return 0;
    if (s == '1-2 años') return 1;
    if (s == '3-5 años') return 3;
    if (s == '6-10 años') return 6;
    if (s == '11-20 años') return 11;
    if (s == 'Más de 20 años') return 20;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final submitState = ref.watch(empresaNotifierProvider);
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (_paso > 0) {
              _irPaso(_paso - 1);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Registrarse como empresa',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
        ),
      ),
      body: Column(
        children: [
          _buildStepper(),
          if (submitState.error != null)
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Error al conectar con el servidor. Revisá tu conexión.',
                      style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: PageView(
              controller: _pageCtrl,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep1(),
                _buildStep2(),
                _buildStep3(),
              ],
            ),
          ),
          if (_paso < 2) _buildBotonInferior(submitState.isLoading),
        ],
      ),
    );
  }

  // ─── STEPPER ─────────────────────────────────────────────────────────────

  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
      child: Row(
        children: [
          _StepCircle(numero: 1, label: 'Información\nbásica', activo: _paso == 0, completado: _paso > 0),
          _StepLinea(activa: _paso > 0),
          _StepCircle(numero: 2, label: 'Documentación', activo: _paso == 1, completado: _paso > 1),
          _StepLinea(activa: _paso > 1),
          _StepCircle(numero: 3, label: 'Revisión', activo: _paso == 2, completado: false),
        ],
      ),
    );
  }

  // ─── STEP 1 ───────────────────────────────────────────────────────────────

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoBanner(Icons.business_outlined, 'Completá la información de tu negocio',
              'Esta información será visible para los usuarios de la app.'),
          const SizedBox(height: 20),

          // Foto de perfil
          _seccionLabel('Foto de perfil del negocio'),
          const Text('Será lo primero que vean los usuarios.',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          const SizedBox(height: 12),
          Row(
            children: [
              Stack(children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppTheme.surface,
                  child: const Icon(Icons.camera_alt_outlined, size: 32, color: AppTheme.textSecondary),
                ),
                Positioned(
                  bottom: 0, right: 0,
                  child: Container(
                    width: 22, height: 22,
                    decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                    child: const Icon(Icons.add, size: 14, color: Colors.white),
                  ),
                ),
              ]),
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: () => _snack('Próximamente'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primary,
                  side: const BorderSide(color: AppTheme.primary),
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Subir foto'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Nombre + RUT
          _dosColumnas(
            _campo('Nombre del negocio *', _nombreCtrl, hint: 'Ej: Electricidad Total'),
            _campo('RUT del negocio *', _rutCtrl, hint: 'Ej: 12.345.678-9'),
          ),
          const SizedBox(height: 14),

          // Categoría + Subcategoría
          _dosColumnas(
            _dropdownCategorias(),
            _dropdownLabel('Subcategoría', _subcategorias, _subcategoria,
                (v) => setState(() => _subcategoria = v)),
          ),
          const SizedBox(height: 14),

          // Ubicación
          _campo('Ubicación del negocio *', _ubicacionCtrl,
              hint: 'Dirección exacta del negocio',
              suffix: const Icon(Icons.location_on_outlined, color: AppTheme.textSecondary, size: 20)),
          const SizedBox(height: 14),

          // Web + WhatsApp
          _dosColumnas(
            _campo('Sitio web', _webCtrl, hint: 'https://tusitio.com',
                suffix: const Icon(Icons.public, color: AppTheme.textSecondary, size: 18)),
            _campo('WhatsApp *', _whatsappCtrl, hint: 'Ej: +598 99 123 456',
                suffix: const Icon(Icons.chat, color: AppTheme.textSecondary, size: 18)),
          ),
          const SizedBox(height: 14),

          // Correo + Teléfono
          _dosColumnas(
            _campo('Correo *', _correoCtrl, hint: 'ejemplo@tunegocio.com',
                keyboardType: TextInputType.emailAddress,
                suffix: const Icon(Icons.email_outlined, color: AppTheme.textSecondary, size: 18)),
            _campo('Teléfono *', _telefonoCtrl, hint: 'Ej: +598 2 123 4567',
                keyboardType: TextInputType.phone,
                suffix: const Icon(Icons.phone_outlined, color: AppTheme.textSecondary, size: 18)),
          ),
          const SizedBox(height: 14),

          // Descripción
          _seccionLabel('Descripción del negocio *'),
          const Text('Contá brevemente qué hace tu negocio y qué los diferencia.',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          const SizedBox(height: 8),
          ValueListenableBuilder(
            valueListenable: _descripcionCtrl,
            builder: (_, __, ___) => TextField(
              controller: _descripcionCtrl,
              maxLines: 4,
              maxLength: 500,
              decoration: const InputDecoration(
                hintText: 'Ej: Somos expertos en instalaciones eléctricas domiciliarias...',
                counterStyle: TextStyle(fontSize: 11),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Servicios
          _seccionLabel('Servicios que ofrecés *'),
          const Text('Seleccioná los servicios principales que brindás.',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _serviciosOpciones
                .map((s) => _ServicioChip(
                      label: s,
                      seleccionado: _servicios.contains(s),
                      onTap: () => setState(() {
                        if (_servicios.contains(s)) _servicios.remove(s);
                        else _servicios.add(s);
                      }),
                    ))
                .toList(),
          ),
          const SizedBox(height: 14),

          // Zona + Años de experiencia
          _dosColumnas(
            _dropdownLabel('Zona de cobertura *', const ['Montevideo', 'Interior', 'Todo el país'], _zonaCobertura,
                (v) => setState(() => _zonaCobertura = v)),
            _dropdownLabel('Años de experiencia *', _aniosOpciones, _aniosExperiencia,
                (v) => setState(() => _aniosExperiencia = v)),
          ),
          const SizedBox(height: 14),

          // Fotos de trabajos
          _seccionLabel('Fotos de trabajos realizados *'),
          const Text('Mostrá tu trabajo. Mínimo 3 fotos.',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          const SizedBox(height: 10),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => GestureDetector(
                onTap: () => _snack('Próximamente'),
                child: Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.textSecondary.withValues(alpha: 0.2)),
                  ),
                  child: i == 0
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_outlined, color: AppTheme.textSecondary, size: 22),
                            SizedBox(height: 4),
                            Text('Agregar', style: TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
                          ],
                        )
                      : const Icon(Icons.add, color: AppTheme.textSecondary, size: 22),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Proceso de revisión info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_user_outlined, color: AppTheme.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      children: [
                        TextSpan(text: 'Proceso de revisión\n', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600)),
                        TextSpan(text: 'Nuestro equipo revisará la información y te notificaremos por email en un plazo de 24 a 48 hs.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── STEP 2 ───────────────────────────────────────────────────────────────

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoBanner(Icons.shield_outlined, 'Documentación del negocio',
              'Para mantener la seguridad y confianza de nuestra comunidad, validamos la información de cada empresa.'),
          const SizedBox(height: 24),

          const Text('Documentos obligatorios',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 16),

          _docItem('1', 'Nombre o razón social del negocio',
              'Ingresá el nombre oficial con el que está registrado tu negocio.',
              _razonSocialCtrl, 'Ej: Electricidad Total SAS',
              'Este nombre será visible para los usuarios.'),
          const SizedBox(height: 16),

          _docItem('2', 'RUT del negocio',
              'Ingresá el RUT de tu empresa. Solo se utilizará para fines de verificación.',
              _rutDoc, 'Ej: 21.123456.001-9', null),
          const SizedBox(height: 16),

          _docUpload(),
          const SizedBox(height: 24),

          const Text('Información adicional (opcional)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 12),

          _opcionAdicional(Icons.description_outlined, 'Descripción del negocio',
              'Contanos brevemente a qué se dedica tu empresa.'),
          const Divider(height: 1),
          _opcionAdicional(Icons.location_on_outlined, 'Dirección del negocio',
              'Ingresá la dirección principal de tu negocio.'),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time_outlined, color: AppTheme.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      children: [
                        TextSpan(text: 'Proceso de revisión\n', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600)),
                        TextSpan(text: 'Nuestro equipo revisará tu información y te notificaremos por email en un plazo de 24 a 48 hs hábiles.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── STEP 3 ───────────────────────────────────────────────────────────────

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            width: 80, height: 80,
            decoration: const BoxDecoration(color: AppTheme.success, shape: BoxShape.circle),
            child: const Icon(Icons.check, color: Colors.white, size: 44),
          ),
          const SizedBox(height: 16),
          const Text('¡Solicitud enviada!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          const Text(
            'Recibimos tu información. Nuestro equipo la revisará y te avisará por email.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 32),

          // Estado tracker
          _estadoTracker(),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/home')),
              child: const Text('Volver al inicio'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _estadoTracker() {
    final pasos = [
      ('Solicitud recibida', 'Tu información fue enviada correctamente.', true),
      ('En revisión', 'Nuestro equipo está verificando tus datos.', false),
      ('En evaluación', 'Evaluamos la documentación presentada.', false),
      ('Resultado', 'Aprobado o requiere correcciones.', false),
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          for (int i = 0; i < pasos.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: pasos[i].$3 ? AppTheme.primary : AppTheme.surface,
                        shape: BoxShape.circle,
                        border: pasos[i].$3 ? null : Border.all(color: AppTheme.textSecondary.withValues(alpha: 0.3)),
                      ),
                      child: Center(
                        child: pasos[i].$3
                            ? const Icon(Icons.check, color: Colors.white, size: 14)
                            : Text('${i + 1}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    if (i < pasos.length - 1)
                      Container(width: 2, height: 32, color: i == 0 ? AppTheme.primary : AppTheme.surface),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pasos[i].$1,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: pasos[i].$3 ? AppTheme.textPrimary : AppTheme.textSecondary,
                            )),
                        Text(pasos[i].$2,
                            style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                        if (i < pasos.length - 1) const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ─── BOTÓN INFERIOR ───────────────────────────────────────────────────────

  Widget _buildBotonInferior(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: ElevatedButton(
        onPressed: isLoading ? null : _siguientePaso,
        child: isLoading
            ? const SizedBox(
                height: 22, width: 22,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              )
            : Text(_paso == 0 ? 'Continuar' : 'Enviar a revisión'),
      ),
    );
  }

  // ─── HELPERS UI ──────────────────────────────────────────────────────────

  Widget _infoBanner(IconData icon, String titulo, String subtitulo) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitulo, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _seccionLabel(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
      );

  Widget _campo(String label, TextEditingController ctrl,
      {String? hint, Widget? suffix, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _seccionLabel(label),
        TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: hint, suffixIcon: suffix),
        ),
      ],
    );
  }

  Widget _dosColumnas(Widget a, Widget b) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: a),
        const SizedBox(width: 12),
        Expanded(child: b),
      ],
    );
  }

  Widget _dropdownCategorias() {
    final asyncCats = ref.watch(categoriasProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _seccionLabel('Categoría principal *'),
        asyncCats.when(
          loading: () => const LinearProgressIndicator(),
          error: (_, __) => const Text('Error', style: TextStyle(color: Colors.red, fontSize: 12)),
          data: (cats) => DropdownButtonFormField<int>(
            value: _categoriaId,
            decoration: const InputDecoration(hintText: 'Seleccioná'),
            isExpanded: true,
            items: cats.map((c) => DropdownMenuItem(value: c.id, child: Text(c.nombre, overflow: TextOverflow.ellipsis))).toList(),
            onChanged: (v) => setState(() {
              _categoriaId = v;
              _categoriaLabel = cats.firstWhere((c) => c.id == v).nombre;
            }),
          ),
        ),
      ],
    );
  }

  Widget _dropdownLabel(String label, List<String> opciones, String? valor, void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _seccionLabel(label),
        DropdownButtonFormField<String>(
          value: valor,
          decoration: const InputDecoration(hintText: 'Seleccioná'),
          isExpanded: true,
          items: opciones.map((o) => DropdownMenuItem(value: o, child: Text(o, overflow: TextOverflow.ellipsis))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _docItem(String numero, String titulo, String subtitulo,
      TextEditingController ctrl, String hint, String? nota) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30, height: 30,
          decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
          child: Center(
            child: Text(numero, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textPrimary)),
              const SizedBox(height: 2),
              Text(subtitulo, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              const SizedBox(height: 8),
              TextField(controller: ctrl, decoration: InputDecoration(hintText: hint)),
              if (nota != null) ...[
                const SizedBox(height: 4),
                Text(nota, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _docUpload() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30, height: 30,
          decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
          child: const Center(
            child: Text('3', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Documentación que acredita la creación del negocio',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textPrimary)),
              const SizedBox(height: 2),
              const Text('Subí el documento que acredite la constitución de tu empresa (SAS, Unipersonal u otro).',
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _snack('Próximamente'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppTheme.textSecondary.withValues(alpha: 0.3),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.cloud_upload_outlined, size: 32, color: AppTheme.textSecondary),
                      SizedBox(height: 6),
                      Text('Subir archivo', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textPrimary, fontSize: 13)),
                      Text('Formatos aceptados: PDF, JPG o PNG\nTamaño máximo: 10MB',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: AppTheme.primary, size: 15),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Ejemplos: certificado de constitución, cámara de comercio, documento de creación de SAS o unipersonal.',
                        style: TextStyle(fontSize: 11, color: AppTheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _opcionAdicional(IconData icon, String titulo, String subtitulo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                Text(subtitulo, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
        ],
      ),
    );
  }
}

// ─── WIDGETS PRIVADOS ────────────────────────────────────────────────────────

class _StepCircle extends StatelessWidget {
  const _StepCircle({required this.numero, required this.label, required this.activo, required this.completado});
  final int numero;
  final String label;
  final bool activo;
  final bool completado;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: activo || completado ? AppTheme.primary : AppTheme.surface,
            shape: BoxShape.circle,
            border: activo || completado ? null : Border.all(color: AppTheme.textSecondary.withValues(alpha: 0.3)),
          ),
          child: Center(
            child: completado
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text('$numero', style: TextStyle(color: activo ? Colors.white : AppTheme.textSecondary, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: activo ? AppTheme.primary : AppTheme.textSecondary,
              fontWeight: activo ? FontWeight.w600 : FontWeight.normal,
            )),
      ],
    );
  }
}

class _StepLinea extends StatelessWidget {
  const _StepLinea({required this.activa});
  final bool activa;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20),
        color: activa ? AppTheme.primary : AppTheme.textSecondary.withValues(alpha: 0.2),
      ),
    );
  }
}

class _ServicioChip extends StatelessWidget {
  const _ServicioChip({required this.label, required this.seleccionado, required this.onTap});
  final String label;
  final bool seleccionado;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: seleccionado ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: seleccionado ? AppTheme.primary : AppTheme.textSecondary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (seleccionado) ...[
              const Icon(Icons.check, size: 13, color: Colors.white),
              const SizedBox(width: 4),
            ],
            Text(label, style: TextStyle(fontSize: 12, color: seleccionado ? Colors.white : AppTheme.textPrimary, fontWeight: seleccionado ? FontWeight.w600 : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
