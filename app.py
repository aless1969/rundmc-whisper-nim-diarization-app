from fastapi import FastAPI, File, UploadFile
from pyannote.audio import Pipeline
import rundmc_whisper_nim

app = FastAPI()

diarization_pipeline = Pipeline.from_pretrained("pyannote/speaker-diarization@2.1")

@app.post("/diarize")
async def diarize(audio_file: UploadFile = File(...)):
    audio_path = f"/tmp/{audio_file.filename}"
    with open(audio_path, "wb") as f:
        f.write(await audio_file.read())
    transcript = rundmc_whisper_nim.transcribe(audio_path)
    diarization_result = diarization_pipeline(audio_path)
    segments = []
    for turn in diarization_result.iter_tracks(yield_label=True):
        segment = {
            "speaker": turn[2],
            "start": turn[0].start,
            "end": turn[0].end
        }
        segments.append(segment)
    return {
        "transcript": transcript,
        "diarization": segments
    }

#Cosa fa, passo per passo:
#Importa le librerie necessarie:

#FastAPI per creare un server web API.
#File, UploadFile per gestire l’upload di file tramite HTTP POST.
#pyannote.audio.Pipeline per caricare la pipeline di diarizzazione (cioè “chi parla e quando”).
#rundmc_whisper_nim per la trascrizione automatica dell’audio (speech-to-text).
#Crea l’applicazione FastAPI:

#app = FastAPI() crea l’istanza dell’applicazione web.
#Carica la pipeline di diarizzazione:

#Pipeline.from_pretrained("pyannote/speaker-diarization@2.1") carica un modello preaddestrato che riconosce i cambi di speaker nell’audio.
#Definisce un endpoint /diarize:

#Riceve un file audio tramite POST.
#Salva temporaneamente il file ricevuto.
#Esegue la trascrizione del file audio tramite rundmc_whisper_nim.transcribe(audio_path).
#Esegue la diarizzazione tramite la pipeline di pyannote.
#Costruisce una lista di segmenti: per ogni segmento individua chi parla, quando inizia e quando finisce.
#Restituisce una risposta JSON come questa:

#json
#  {
#    "transcript": "Testo trascritto...",
#    "diarization": [
#      {"speaker": "SPEAKER_00", "start": 0.0, "end": 3.2},
#      {"speaker": "SPEAKER_01", "start": 3.2, "end": 8.5}
#    ]
#  }
   
#transcript: la trascrizione testuale dell’audio.
#diarization: una lista di segmenti temporali, ciascuno con speaker, tempo di inizio e di fine.