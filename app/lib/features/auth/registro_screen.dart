import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/usuario.dart';
import '../../core/services/database_service.dart';
import '../../shared/theme/app_theme.dart';

const _departamentos = [
  'Artigas', 'Canelones', 'Cerro Largo', 'Colonia', 'Durazno',
  'Flores', 'Florida', 'Lavalleja', 'Maldonado', 'Montevideo',
  'Paysandú', 'Río Negro', 'Rivera', 'Rocha', 'Salto',
  'San José', 'Soriano', 'Tacuarembó', 'Treinta y Tres',
];

class RegistroScreen extends ConsumerStatefulWidget {
  const RegistroScreen({super.key});

  @override
  ConsumerState<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends ConsumerState<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();
  final _ciudadCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  Usuario? _usuarioExistente;
  String? _departamento;
  bool _guardando = false;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    final usuario = await DatabaseService().getUsuario();
    if (mounted) {
      setState(() {
        _cargando = false;
        if (usuario != null) {
          _usuarioExistente = usuario;
          _nombreCtrl.text = usuario.nombre;
          _direccionCtrl.text = usuario.direccion;
          _ciudadCtrl.text = usuario.ciudad;
          _departamento = usuario.departamento;
          _telefonoCtrl.text = usuario.telefono;
          _emailCtrl.text = usuario.email;
        }
      });
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _direccionCtrl.dispose();
    _ciudadCtrl.dispose();
    _telefonoCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _guardando = true);
    try {
      if (_usuarioExistente != null) {
        await DatabaseService().updateUsuario(
          _usuarioExistente!.copyWith(
            nombre: _nombreCtrl.text.trim(),
            direccion: _direccionCtrl.text.trim(),
            ciudad: _ciudadCtrl.text.trim(),
            departamento: _departamento!,
            telefono: _telefonoCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
          ),
        );
      } else {
        await DatabaseService().insertUsuario(Usuario(
          nombre: _nombreCtrl.text.trim(),
          direccion: _direccionCtrl.text.trim(),
          ciudad: _ciudadCtrl.text.trim(),
          departamento: _departamento!,
          telefono: _telefonoCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
        ));
      }
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final esEdicion = _usuarioExistente != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          esEdicion ? 'Mi perfil' : 'Tus datos',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                esEdicion ? 'Editá tus datos' : 'Completá tu perfil',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Esta información se guarda en tu dispositivo.',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 28),
              _Campo(
                label: 'Nombre completo',
                controller: _nombreCtrl,
                hint: 'Ej: Juan Pérez',
                validator: _requerido,
              ),
              const SizedBox(height: 16),
              _Campo(
                label: 'Dirección',
                controller: _direccionCtrl,
                hint: 'Calle y número',
                validator: _requerido,
              ),
              const SizedBox(height: 16),
              _Campo(
                label: 'Ciudad',
                controller: _ciudadCtrl,
                hint: 'Ej: Montevideo',
                validator: _requerido,
              ),
              const SizedBox(height: 16),
              _DropdownDepartamento(
                valorInicial: _departamento,
                onSaved: (v) => _departamento = v,
              ),
              const SizedBox(height: 16),
              _Campo(
                label: 'Teléfono',
                controller: _telefonoCtrl,
                hint: 'Ej: +598 99 123 456',
                keyboardType: TextInputType.phone,
                validator: _requerido,
              ),
              const SizedBox(height: 16),
              _Campo(
                label: 'Email',
                controller: _emailCtrl,
                hint: 'ejemplo@correo.com',
                keyboardType: TextInputType.emailAddress,
                validator: _validarEmail,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _guardando ? null : _guardar,
                child: _guardando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(esEdicion ? 'Guardar cambios' : 'Continuar'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  String? _requerido(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Este campo es obligatorio' : null;

  String? _validarEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Este campo es obligatorio';
    final ok = RegExp(r'^[\w.-]+@[\w.-]+\.\w{2,}$').hasMatch(v.trim());
    return ok ? null : 'Ingresá un email válido';
  }
}

class _Campo extends StatelessWidget {
  const _Campo({
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

class _DropdownDepartamento extends StatelessWidget {
  const _DropdownDepartamento({
    required this.valorInicial,
    required this.onSaved,
  });

  final String? valorInicial;
  final FormFieldSetter<String> onSaved;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Departamento',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: valorInicial,
          hint: const Text('Seleccioná un departamento'),
          decoration: const InputDecoration(),
          items: _departamentos
              .map((d) => DropdownMenuItem(value: d, child: Text(d)))
              .toList(),
          onChanged: (_) {},
          onSaved: onSaved,
          validator: (v) => v == null ? 'Seleccioná un departamento' : null,
        ),
      ],
    );
  }
}
