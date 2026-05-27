from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from database import get_conn
from routers import empresas

app = FastAPI(title="ServiClic API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(empresas.router)


@app.get("/")
def root():
    return {"app": "ServiClic API", "version": "1.0.0"}


@app.get("/categorias")
def get_categorias():
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT id, nombre, icono FROM categorias WHERE activo = TRUE ORDER BY orden"
            )
            return cur.fetchall()
