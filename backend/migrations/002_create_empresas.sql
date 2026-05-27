-- Migration 002: empresas, empresa_fotos, empresa_servicios

DO $$ BEGIN
    CREATE TYPE estado_revision AS ENUM (
        'pendiente', 'en_revision', 'en_evaluacion', 'aprobado', 'rechazado'
    );
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

CREATE TABLE IF NOT EXISTS empresas (
    id                  SERIAL PRIMARY KEY,
    usuario_id          INTEGER,  -- ID del usuario en SQLite local (no hay FK cross-db)

    -- Identidad
    nombre              VARCHAR(200) NOT NULL,
    razon_social        VARCHAR(200),
    rut                 VARCHAR(30)  NOT NULL,
    foto_perfil         TEXT,

    -- Contacto
    whatsapp            VARCHAR(30),
    telefono            VARCHAR(30),
    correo              VARCHAR(150),
    web                 VARCHAR(250),

    -- Ubicación
    lat                 NUMERIC(10, 7),
    lng                 NUMERIC(10, 7),
    ubicacion_texto     TEXT,
    zona_cobertura      TEXT[],

    -- Perfil
    descripcion         TEXT,
    anios_experiencia   INTEGER,
    categoria_id        INTEGER REFERENCES categorias(id),
    subcategoria        VARCHAR(100),

    -- Documentación (step 2)
    documento_url       TEXT,

    -- Estado de revisión
    estado_revision     estado_revision NOT NULL DEFAULT 'pendiente',
    verificado          BOOLEAN         NOT NULL DEFAULT FALSE,

    -- Disponibilidad
    disponible_ahora    BOOLEAN         NOT NULL DEFAULT FALSE,

    -- Posicionamiento pago
    inversion_mensual   NUMERIC(10, 2)  NOT NULL DEFAULT 0,
    ranking_position    INTEGER         NOT NULL DEFAULT 0,

    created_at          TIMESTAMP       NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMP       NOT NULL DEFAULT NOW()
);

-- Fotos de trabajos realizados (mínimo 3 requerido en el wizard)
CREATE TABLE empresa_fotos (
    id          SERIAL  PRIMARY KEY,
    empresa_id  INTEGER NOT NULL REFERENCES empresas(id) ON DELETE CASCADE,
    url         TEXT    NOT NULL,
    orden       INTEGER NOT NULL DEFAULT 0,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Servicios ofrecidos (checkboxes del wizard: Electricidad, Plomería, etc.)
CREATE TABLE empresa_servicios (
    empresa_id  INTEGER      NOT NULL REFERENCES empresas(id) ON DELETE CASCADE,
    servicio    VARCHAR(100) NOT NULL,
    PRIMARY KEY (empresa_id, servicio)
);

-- Índices para búsquedas frecuentes
CREATE INDEX idx_empresas_categoria  ON empresas(categoria_id);
CREATE INDEX idx_empresas_estado     ON empresas(estado_revision);
CREATE INDEX idx_empresas_ranking    ON empresas(categoria_id, ranking_position DESC);
CREATE INDEX idx_empresas_geo        ON empresas(lat, lng) WHERE lat IS NOT NULL;
CREATE INDEX idx_empresa_fotos_emp   ON empresa_fotos(empresa_id);
