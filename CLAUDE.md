# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project: ServiClic

Mobile platform connecting users with local service professionals. Folder is `ServiTec`; app brand name is **ServiClic** ("Encontrá todo lo que necesitás, en un clic.").

La aplicación es una plataforma móvil diseñada para conectar de forma rápida y eficiente a usuarios con empresas y profesionales de servicios locales. 
Su objetivo principal es centralizar la oferta de servicios en un solo lugar, permitiendo a los usuarios encontrar soluciones a sus necesidades de manera simple, confiable y en pocos pasos. 
A través de un sistema de búsqueda por categorías o palabras clave, la app muestra resultados específicos según el servicio requerido, filtrados por ubicación, relevancia y disponibilidad.
La plataforma incorpora geolocalización en tiempo real, lo que permite visualizar profesionales cercanos mediante un mapa interactivo o listados organizados. 
Cada empresa cuenta con un perfil detallado que incluye información del negocio, servicios ofrecidos, calificaciones, tiempo de respuesta y evidencia visual de trabajos realizados, lo que facilita la toma de decisiones del usuario. 
El contacto se realiza de forma directa mediante herramientas externas como WhatsApp, llamadas o correo electrónico, eliminando intermediaciones innecesarias.
El modelo de negocio se basa en un sistema de posicionamiento competitivo, donde las empresas pueden obtener mayor visibilidad dentro de los resultados mediante un esquema de subasta o inversión, 
destacándose en los primeros lugares de cada categoría. Asimismo, la aplicación incorpora un proceso de registro y validación de empresas que garantiza la autenticidad y calidad de los prestadores.
En conjunto, la aplicación busca optimizar la conexión entre oferta y demanda en el sector de servicios, ofreciendo una experiencia ágil, segura y escalable.

**Stage:** Design phase. All screens are JPEGs in `/`. No code yet.  

**Target market:** Argentina / Rioplatense Spanish-speaking region (voseo copy throughout).  
**Reference project:** `C:\Users\Leonardo\cortinas` — same stack, carry over all conventions from there.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile | Flutter (Dart ^3.x) |
| State management | Riverpod — `StateNotifier` pattern (same as cortinas) |
| Navigation | Named routes (Navigator 1.0) — same as cortinas |
| Maps | `flutter_map` + OpenStreetMap (free, no billing) |
| Push notifications | Firebase FCM |
| HTTP | `http` package |
| Backend | FastAPI (Python) |
| Database | PostgreSQL — raw `psycopg2`, no ORM |
| Auth | JWT (email + password) + bcrypt — same as cortinas |
| PDF | `pdf` package (for receipts/quotes if needed) |

No admin panel for now — company review is handled manually.

---

## Flutter Conventions (from cortinas)

### Folder structure
```
lib/
├── main.dart
├── app.dart                  # MaterialApp + named routes
├── core/
│   ├── models/               # Pure data classes + enums
│   └── services/             # HTTP, DB, notifications, auth
├── features/
│   └── <feature>/
│       ├── <feature>_screen.dart
│       ├── <feature>_notifier.dart   # StateNotifier
│       └── widgets/          # Screen-specific widgets
└── shared/
    └── theme/
        └── app_theme.dart
```

### Naming
- Files: `snake_case.dart`
- Classes/Enums: `PascalCase`
- Variables/methods: `camelCase`
- Enum values: `camelCase`

### Riverpod pattern
```dart
final featureProvider = StateNotifierProvider<FeatureNotifier, FeatureState>(
  (ref) => FeatureNotifier(),
);

class FeatureState {
  // immutable fields
}

class FeatureNotifier extends StateNotifier<FeatureState> {
  // methods that call state = state.copyWith(...)
}
```

### Theme
- Primary: electric blue (match mockups — approx `#1B44CC`)
- Background: white for content screens, blue for splash
- Buttons: solid blue, full-width, pill-shaped
- Cards: white, rounded corners, subtle shadow
- Icons: outline style; filled only for active nav tab
- Material Design 3 enabled (`useMaterial3: true`)

---

## Backend Conventions (from cortinas)

- **No ORM.** Raw SQL via `psycopg2`. Pydantic models for request/response validation.
- **CORS:** `allow_origins=["*"]` during development.
- **Auth:** JWT via `python-jose`, passwords via `passlib[bcrypt]`.
- **JSON fields:** `snake_case` everywhere (matches DB column names).
- **Startup:** seed admin user if not exists.

### Suggested backend structure
```
backend/
├── main.py
├── database.py          # psycopg2 connection pool
├── auth.py              # JWT helpers
├── routers/
│   ├── auth.py
│   ├── usuarios.py
│   ├── empresas.py
│   ├── categorias.py
│   └── busqueda.py
└── schemas/             # Pydantic models
```

---

## Business Model

- **Consumers** search and contact professionals via WhatsApp, phone, or email — no in-app messaging.
- **Companies** register free, go through manual review (24–48 business hours), then appear in results.
- **Paid positioning:** verified companies can pay to rank higher. The ranking number badge (1, 2, 3…) on cards reflects this.
- **User Premium tier:** discounts and priority attention (upsell on profile screen).

---

## User Types

Two distinct account types in the DB and API:

| Type | Description |
|---|---|
| `usuario` | Consumer — searches, contacts, saves favorites |
| `empresa` | Professional/business — has a profile, appears in search results |

A user can register as a company from their profile screen ("Registrarse como empresa" CTA).

---

## Screens & Navigation

### Bottom tab bar (5 tabs — all content screens)
`Inicio · Buscar · Cerca de mí · Favoritos · Perfil`

### Screen inventory

| File | Screen | Notes |
|---|---|---|
| `Home.jpeg` | Splash / Landing | "Comenzar" + "Iniciar sesión". Blue branded. |
| `Pantalla 1.jpeg` | Main Home | Search bar, category chips, promo banner, "Populares cerca tuyo" |
| `Busqueda.jpeg` | Search | Category grid (3×3) + "Profesionales destacados para vos" |
| `Electricistas.jpeg` | Category Results | Ranked list. Tabs: Todos / Calificados / Favoritos / Cerca de mí |
| `Cerca de Mi.jpeg` | Near Me (Map) | `flutter_map` map + ranked list below. Filters: category, radius, sort |
| `Contacto.jpeg` | Contact | Bridges to WhatsApp / phone / email. Reason tags + optional message |
| `Empresa.jpeg` | Company Registration — Step 1 | Basic info wizard |
| `Empresa 2.jpeg` | Company Registration — Step 2 | Legal docs upload (PDF/JPG/PNG ≤ 10 MB) |
| `Estado de la solicitud.jpeg` | Review Status | 4-step tracker sent via FCM notifications |
| `Favoritos.jpeg` | Favorites | Saved professionals list |
| `Notificaciones.jpeg` | Notifications | FCM-driven activity feed |
| `Mi Perfil.jpeg` | User Profile | Stats, activities, preferences, account settings |

---

## Key Business Rules (from mockups)

- **No in-app messaging.** Contact always bridges to external channels. WhatsApp is tagged "Más rápido".
- **"Verificado" badge** appears only after manual 3-step company review. Must be visible on all professional cards.
- **"Disponible ahora"** green badge = real-time availability flag on the company profile.
- **Ranking numbers** on cards (1, 2, 3…) are the paid positioning output.
- **Contact reasons** pre-fill the outbound message: Consulta de precio / Agendar visita / Urgencia hoy / Otro motivo.
- **Company registration** is a 3-step wizard: Información básica → Documentación → Revisión. Review SLA: 24–48 business hours. FCM notification on status change.
- **User stats tracked:** búsquedas realizadas, favoritos guardados, consultas realizadas, citas agendadas.

---

## Company Registration Flow

**Step 1 — Información básica:**
- Profile photo, nombre, RUT, categoría principal, subcategoría, ubicación, web, WhatsApp, correo, teléfono, descripción (≤500 chars), servicios ofrecidos (checkboxes), zona de cobertura, años de experiencia, fotos de trabajos (min 3).

**Step 2 — Documentación:**
- Razón social, RUT, document upload (PDF/JPG/PNG ≤ 10 MB — constitución/cámara de comercio/SAS).

**Step 3 — Revisión:**
- Read-only status tracker. FCM push on each status change (En revisión → En evaluación → Aprobado/Rechazado).

---

## Service Categories (from mockups)

Top-level: `Hogar · Electricidad · Plomería · Tecnología`

Sub-categories visible: Aire Acondicionado, Albañilería, Limpieza, Pintura, Cerrajería, Jardinería, Mudanzas, Técnicos de Refrigeración.

---

## Design System

- **Primary color:** electric blue (`~#1B44CC`)
- **CTA buttons:** solid blue, full-width, rounded pill
- **Backgrounds:** white (content), blue (splash)
- **Cards:** white, rounded corners, subtle shadow
- **Typography:** bold display for titles, regular for body. Clean sans-serif.
- **Icons:** outline style, blue on white; filled only for active nav tab
- **Rating:** gold star + numeric score + review count `(128)`
- **Distance:** `"A X,X km de vos"` — voseo throughout all copy
- **Badges:** `✔ Verificado` (blue), `Disponible ahora` (green), ranking number circle (blue)
