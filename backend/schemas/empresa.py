from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class EmpresaCreate(BaseModel):
    usuario_id: Optional[int] = None
    nombre: str
    razon_social: Optional[str] = None
    rut: str
    foto_perfil: Optional[str] = None
    whatsapp: Optional[str] = None
    telefono: Optional[str] = None
    correo: Optional[str] = None
    web: Optional[str] = None
    lat: Optional[float] = None
    lng: Optional[float] = None
    ubicacion_texto: Optional[str] = None
    zona_cobertura: Optional[list[str]] = None
    descripcion: Optional[str] = None
    anios_experiencia: Optional[int] = None
    categoria_id: Optional[int] = None
    subcategoria: Optional[str] = None
    servicios_ofrecidos: Optional[list[str]] = None
    fotos_trabajos: Optional[list[str]] = None


class EmpresaDocumentacion(BaseModel):
    razon_social: Optional[str] = None
    rut: Optional[str] = None
    documento_url: Optional[str] = None


class EmpresaResponse(BaseModel):
    id: int
    usuario_id: Optional[int]
    nombre: str
    razon_social: Optional[str]
    rut: str
    foto_perfil: Optional[str]
    whatsapp: Optional[str]
    telefono: Optional[str]
    correo: Optional[str]
    web: Optional[str]
    lat: Optional[float]
    lng: Optional[float]
    ubicacion_texto: Optional[str]
    zona_cobertura: Optional[list[str]]
    descripcion: Optional[str]
    anios_experiencia: Optional[int]
    categoria_id: Optional[int]
    subcategoria: Optional[str]
    documento_url: Optional[str]
    estado_revision: str
    verificado: bool
    disponible_ahora: bool
    inversion_mensual: float
    ranking_position: int
    fotos: list[str]
    servicios: list[str]
    created_at: datetime
    updated_at: datetime
