# 🔒 trascrizione automatica e diarizzazione speaker

# rundmc-whisper-nim-diarization-app

## Descrizione

**rundmc-whisper-nim-diarization-app** è una soluzione  per la trascrizione e diarizzazione automatica di contenuti audio, basata su AI.  
Tutte le funzionalità della soluzione sono fruibili via **GUI**, **CLI** e **REST API** (con documentazione Swagger)

---

## Funzionalità

- **Upload audio** (wav/mp3) via REST API, CLI o GUI
- **Trascrizione automatica** di file audio con Whisper
- **Diarizzazione speaker** (identificazione dei diversi speaker) con pyannote.audio
- **Risposta JSON**: transcript + segmenti speaker - (in vari formati (JSON, TXT, CSV))
- **Documentazione API**: Swagger/OpenAPI disponibile su `/docs`

---

## Struttura progetto

rundmc-whisper-nim-diarization-app/
│
├── Dockerfile
├── requirements.txt
├── app.py
├── README.md
├── build.sh
├── install.sh
├── helm/
    |── Chart.yaml
    ├── values.yaml
    ├── values-pcai.yaml   
    └── templates/
        ├── _helpers.tpl
        ├── deployment.yaml
        ├── service.yaml
        ├── virtualservice.yaml  # Istio/EZUA
        ├── ingress.yaml
        ├── hpa.yaml

### REST API

# Chiamata esempio: sh
curl -X POST "http://localhost:8010/api/v1/transcribe" -F audio=@file.wav



```bash
# 1. Installa le dipendenze
pip install -r requirements.txt

# הרצה
python app.py



Apri nel browser  http://localhost:8010

## Docker

```bash
# image
./build.sh

# docker
docker build -t rundmc-whisper-nim-diarization-app:1.0.0 .


docker run -p 8010:8010 rundmc-whisper-nim-diarization-app:latest

###  Kubernetes on helm
```bash
cd helm

# values.yaml 
nano values.yaml

# helm install
helm install rundmc-whisper-nim-diarization-app . -n your-namespace
```

### HPE PCAI

```bash
cd helm

# values-pcai

nano values-pcai.yaml

# PCAI

helm install rundmc-whisper-nim-diarization-app . \
  -n your-namespace \
  -f values-pcai.yaml


# values
helm upgrade rundmc-whisper-nim-diarization-app . -n your-namespace -f values.yaml
```




```json

{
  "text": "...",
  "speakers": [
    {"id": 1, "start": 0.0, "end": 10.5},
    {"id": 2, "start": 10.6, "end": 22.9}
  ]
}



## Istio / EZUA Configuration Istio VirtualService:

ezua:
  enabled: true
  virtualService:
    endpoint: "rundmc-whisper-nim-diarization-app.apps.your-domain.com"
    istioGateway: "istio-system/ezaf-gateway"
