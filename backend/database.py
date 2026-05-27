import psycopg2
from psycopg2.extras import RealDictCursor

DB_CONFIG = {
    "host": "localhost",
    "database": "db_serviclic",
    "user": "postgres",
    "password": "Sagan496!",
}


def get_conn():
    return psycopg2.connect(**DB_CONFIG, cursor_factory=RealDictCursor)
