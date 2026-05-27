from fastapi import APIRouter, HTTPException
from database import get_conn
from schemas.empresa import EmpresaCreate, EmpresaDocumentacion, EmpresaResponse

router = APIRouter(prefix="/empresas", tags=["empresas"])


def _fetch_empresa(cur, empresa_id: int) -> dict | None:
    cur.execute("SELECT * FROM empresas WHERE id = %s", (empresa_id,))
    emp = cur.fetchone()
    if not emp:
        return None
    cur.execute(
        "SELECT url FROM empresa_fotos WHERE empresa_id = %s ORDER BY orden",
        (empresa_id,),
    )
    fotos = [r["url"] for r in cur.fetchall()]
    cur.execute(
        "SELECT servicio FROM empresa_servicios WHERE empresa_id = %s",
        (empresa_id,),
    )
    servicios = [r["servicio"] for r in cur.fetchall()]
    return {**dict(emp), "fotos": fotos, "servicios": servicios}


@router.post("/", response_model=EmpresaResponse, status_code=201)
def crear_empresa(body: EmpresaCreate):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO empresas (
                    usuario_id, nombre, razon_social, rut, foto_perfil,
                    whatsapp, telefono, correo, web,
                    lat, lng, ubicacion_texto, zona_cobertura,
                    descripcion, anios_experiencia, categoria_id, subcategoria
                ) VALUES (
                    %(usuario_id)s, %(nombre)s, %(razon_social)s, %(rut)s, %(foto_perfil)s,
                    %(whatsapp)s, %(telefono)s, %(correo)s, %(web)s,
                    %(lat)s, %(lng)s, %(ubicacion_texto)s, %(zona_cobertura)s,
                    %(descripcion)s, %(anios_experiencia)s, %(categoria_id)s, %(subcategoria)s
                ) RETURNING id
                """,
                body.model_dump(),
            )
            empresa_id = cur.fetchone()["id"]

            if body.fotos_trabajos:
                for i, url in enumerate(body.fotos_trabajos):
                    cur.execute(
                        "INSERT INTO empresa_fotos (empresa_id, url, orden) VALUES (%s, %s, %s)",
                        (empresa_id, url, i),
                    )

            if body.servicios_ofrecidos:
                for s in body.servicios_ofrecidos:
                    cur.execute(
                        "INSERT INTO empresa_servicios (empresa_id, servicio) VALUES (%s, %s)",
                        (empresa_id, s),
                    )

            conn.commit()
            result = _fetch_empresa(cur, empresa_id)
    return result


@router.put("/{empresa_id}/documentacion", response_model=EmpresaResponse)
def agregar_documentacion(empresa_id: int, body: EmpresaDocumentacion):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id FROM empresas WHERE id = %s", (empresa_id,))
            if not cur.fetchone():
                raise HTTPException(status_code=404, detail="Empresa no encontrada")
            updates = {k: v for k, v in body.model_dump().items() if v is not None}
            if updates:
                sets = ", ".join(f"{k} = %({k})s" for k in updates)
                updates["empresa_id"] = empresa_id
                cur.execute(
                    f"UPDATE empresas SET {sets}, updated_at = NOW() WHERE id = %(empresa_id)s",
                    updates,
                )
            conn.commit()
            result = _fetch_empresa(cur, empresa_id)
    return result


@router.get("/categoria/{categoria_id}", response_model=list[EmpresaResponse])
def listar_por_categoria(categoria_id: int):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT id FROM empresas
                WHERE categoria_id = %s AND estado_revision = 'aprobado'
                ORDER BY ranking_position DESC, inversion_mensual DESC
                """,
                (categoria_id,),
            )
            ids = [r["id"] for r in cur.fetchall()]
            return [_fetch_empresa(cur, i) for i in ids]


@router.get("/{empresa_id}", response_model=EmpresaResponse)
def obtener_empresa(empresa_id: int):
    with get_conn() as conn:
        with conn.cursor() as cur:
            result = _fetch_empresa(cur, empresa_id)
    if not result:
        raise HTTPException(status_code=404, detail="Empresa no encontrada")
    return result
