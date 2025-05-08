from fastapi import FastAPI
from pydantic import BaseModel
import pickle
import pandas as pd
import datetime
from fastapi.middleware.cors import CORSMiddleware

# Cargar el modelo entrenado
with open("modelo_entrenado.pkl", "rb") as f:
    modelo = pickle.load(f)

# Crear instancia de FastAPI
app = FastAPI(title="Microservicio de Predicción de Estrés Térmico")

# Agrega esto para permitir todas las solicitudes (útil en desarrollo)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Permite cualquier origen, cámbialo en producción
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


#timestamp,temperatura_ambiente,humedad_relativa,velocidad_viento,temperatura_interior,humedad_interior,estres_termico,cantidad_pollos

# Modelo de entrada con validación
class SensorInput(BaseModel):
    timestamp: str        # formato esperado: "2025-04-16T14:30:00"
    temperatura_ambiente: float
    humedad_relativa: float
    velocidad_viento: float
    temperatura_interior: float
    humedad_interior: float
    cantidad_pollos: int

# Endpoint raíz (opcional)
@app.get("/")
def root():
    return {"mensaje": "Microservicio activo. Usa el endpoint /predecir para enviar datos."}

# Endpoint para hacer predicción
@app.post("/predecir")
def predecir(data: SensorInput):
    # Convertir timestamp a datetime
    dt = pd.to_datetime(data.timestamp)

    # Crear DataFrame con las variables que espera el modelo
    entrada = pd.DataFrame([{
        "temperatura_ambiente": data.temperatura_ambiente,
        "humedad_relativa": data.humedad_relativa,
        "velocidad_viento": data.velocidad_viento,
        "temperatura_interior": data.temperatura_interior,
        "humedad_interior": data.humedad_interior,
        "cantidad_pollos": data.cantidad_pollos,
        "hora": dt.hour,
        "dia_semana": dt.dayofweek,
        "mes": dt.month
    }])


    # Hacer predicción
    prediccion = modelo.predict(entrada)[0]
    probabilidad = modelo.predict_proba(entrada).max()

    return {
        "prediccion": int(prediccion),
        "confianza": round(probabilidad, 4),
        "mensaje": "Predicción realizada correctamente"
    }
