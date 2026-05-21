from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import psycopg2
from psycopg2.extras import RealDictCursor

app = FastAPI(title="ServiClic API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

DB_CONFIG = {
    "host": "localhost",
    "database": "db_serviclic",
    "user": "postgres",
    "password": "Sagan496!",
}


def get_conn():
    return psycopg2.connect(**DB_CONFIG, cursor_factory=RealDictCursor)


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
