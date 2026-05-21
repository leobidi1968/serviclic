class Usuario {
  final int? id;
  final String nombre;
  final String direccion;
  final String ciudad;
  final String departamento;
  final String telefono;
  final String email;
  final bool sesionActiva;

  const Usuario({
    this.id,
    required this.nombre,
    required this.direccion,
    required this.ciudad,
    required this.departamento,
    required this.telefono,
    required this.email,
    this.sesionActiva = true,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'nombre': nombre,
        'direccion': direccion,
        'ciudad': ciudad,
        'departamento': departamento,
        'telefono': telefono,
        'email': email,
        'sesion_activa': sesionActiva ? 1 : 0,
      };

  factory Usuario.fromMap(Map<String, dynamic> map) => Usuario(
        id: map['id'] as int?,
        nombre: map['nombre'] as String,
        direccion: map['direccion'] as String,
        ciudad: map['ciudad'] as String,
        departamento: map['departamento'] as String,
        telefono: map['telefono'] as String,
        email: map['email'] as String,
        sesionActiva: (map['sesion_activa'] as int) == 1,
      );

  Usuario copyWith({
    int? id,
    String? nombre,
    String? direccion,
    String? ciudad,
    String? departamento,
    String? telefono,
    String? email,
    bool? sesionActiva,
  }) =>
      Usuario(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        direccion: direccion ?? this.direccion,
        ciudad: ciudad ?? this.ciudad,
        departamento: departamento ?? this.departamento,
        telefono: telefono ?? this.telefono,
        email: email ?? this.email,
        sesionActiva: sesionActiva ?? this.sesionActiva,
      );
}
