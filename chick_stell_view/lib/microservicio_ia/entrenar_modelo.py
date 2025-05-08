import pandas as pd
import argparse
import pickle
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix, roc_auc_score
from sklearn.preprocessing import LabelBinarizer

# 📥 Argumentos desde la terminal
parser = argparse.ArgumentParser(description="Entrenar modelo de detección de estrés térmico.")
parser.add_argument('--dataset', type=str, required=True, help="Ruta del archivo CSV")
args = parser.parse_args()

# 📊 Cargar datos
df = pd.read_csv(args.dataset)

# 🕒 Procesar columna timestamp
df['timestamp'] = pd.to_datetime(df['timestamp'])
df['hora'] = df['timestamp'].dt.hour
df['dia_semana'] = df['timestamp'].dt.dayofweek
df['mes'] = df['timestamp'].dt.month
df = df.drop(columns=['timestamp'])

# 🎯 Separar X (características) y y (etiqueta)
X = df.drop(columns=['estres_termico'])
y = df['estres_termico']

# 🔀 Dividir datos en entrenamiento y prueba
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, stratify=y, random_state=42
)

# 🌲 Entrenar modelo
modelo = RandomForestClassifier(n_estimators=100, random_state=42)
modelo.fit(X_train, y_train)

# 💾 Guardar modelo entrenado
with open("modelo_entrenado.pkl", "wb") as f:
    pickle.dump(modelo, f)

# 📈 Evaluar
y_pred = modelo.predict(X_test)
y_proba = modelo.predict_proba(X_test)

accuracy = accuracy_score(y_test, y_pred)
print(f"✅ Accuracy: {accuracy:.4f}")

print("\n📋 Reporte de Clasificación:")
print(classification_report(y_test, y_pred))

print("📉 Matriz de Confusión:")
print(confusion_matrix(y_test, y_pred))

# 🎯 ROC AUC Score con codificación one-hot
lb = LabelBinarizer()
y_test_bin = lb.fit_transform(y_test)
roc_auc = roc_auc_score(y_test_bin, y_proba, multi_class='ovr')
print(f"\n🎯 ROC AUC Score: {roc_auc:.4f}")
