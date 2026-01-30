# 🔒 Code Security Scanner

מערכת לבדיקת קוד לחולשות אבטחה ובעיות באמצעות LLM.

## תכונות

- ✅ העלאת קוד ידנית או מקובץ
- ✅ תמיכה במגוון שפות תכנות
- ✅ זיהוי אוטומטי של שפת התכנות
- ✅ חיבור לכל LLM endpoint (OpenAI-compatible)
- ✅ **Endpoint וטוקן ניתנים לשינוי בזמן אמת דרך ה-UI**
- ✅ אפשרות להתאמה אישית של ה-prompt
- ✅ תמיכה בעברית
- ✅ Helm Chart עם תמיכה ב-Istio/EZUA

## מבנה הפרויקט

```
code-scanner/
├── app.py              # אפליקציית Gradio
├── requirements.txt    # תלויות Python
├── Dockerfile          # בניית Docker image
├── build.sh           # סקריפט בנייה
├── install.sh         # סקריפט התקנה
├── README.md          # תיעוד
└── helm/              # Helm Chart
    ├── Chart.yaml
    ├── values.yaml
    ├── values-pcai.yaml   # הגדרות לסביבת HPE PCAI
    └── templates/
        ├── _helpers.tpl
        ├── deployment.yaml
        ├── service.yaml
        ├── virtualservice.yaml  # Istio/EZUA
        ├── ingress.yaml
        ├── hpa.yaml
        └── NOTES.txt
```

## הרצה מקומית

```bash
# התקנת dependencies
pip install -r requirements.txt

# הרצה
python app.py

# או עם הגדרות ברירת מחדל:
LLM_ENDPOINT="http://localhost:8000/v1/chat/completions" \
LLM_MODEL="llama3" \
python app.py
```

פתח בדפדפן: http://localhost:7860

## הרצה עם Docker

```bash
# בניית image
./build.sh

# או ידנית:
docker build -t code-scanner:1.0.0 .

# הרצה
docker run -p 7860:7860 \
  -e LLM_ENDPOINT="http://your-llm:8000/v1/chat/completions" \
  -e LLM_MODEL="llama3" \
  code-scanner:1.0.0
```

## פריסה על Kubernetes עם Helm

### התקנה בסיסית

```bash
cd helm

# ערוך את values.yaml עם ההגדרות שלך
nano values.yaml

# התקנה
helm install code-scanner . -n your-namespace
```

### התקנה על HPE PCAI

```bash
cd helm

# ערוך את values-pcai.yaml
nano values-pcai.yaml

# התקנה עם הגדרות PCAI
helm install code-scanner . \
  -n your-namespace \
  -f values-pcai.yaml
```

### עדכון הגדרות

```bash
# עדכון endpoint
helm upgrade code-scanner . \
  -n your-namespace \
  --set app.env.LLM_ENDPOINT="http://new-llm:8000/v1/chat/completions"

# או עדכון מקובץ values
helm upgrade code-scanner . -n your-namespace -f values.yaml
```

## שימוש

1. **הגדר endpoint** - הזן את כתובת ה-LLM API שלך (ניתן לשנות בכל עת!)
   - דוגמאות:
     - OpenAI: `https://api.openai.com/v1/chat/completions`
     - Local LLM: `http://localhost:8000/v1/chat/completions`
     - HPE PCAI: `http://llama-service.namespace.svc.cluster.local:8000/v1/chat/completions`

2. **הזן token** - אם נדרש אימות (ניתן לשנות בכל עת!)

3. **בחר model** - שם המודל (llama3, gpt-4, mistral, וכו')

4. **בחר שפת תכנות** - או השאר על Auto-detect

5. **הזן/העלה קוד** - הדבק קוד או העלה קובץ

6. **לחץ "נתח קוד"** - וקבל ניתוח מפורט

## Endpoints נתמכים

המערכת תומכת בכל API שמקבל פורמט OpenAI-compatible:

```json
{
  "model": "...",
  "messages": [
    {"role": "user", "content": "..."}
  ]
}
```

## משתני סביבה

| משתנה | תיאור | ברירת מחדל |
|-------|-------|------------|
| `LLM_ENDPOINT` | כתובת ה-LLM API | ריק |
| `LLM_TOKEN` | טוקן אימות | ריק |
| `LLM_MODEL` | שם המודל | llama3 |

**הערה:** כל ההגדרות ניתנות לשינוי גם דרך ה-UI בזמן אמת!

## התאמה אישית

ניתן להגדיר prompt מותאם אישית לבדיקות ספציפיות:
- Code review כללי
- בדיקת ביצועים
- תאימות לסטנדרטים
- בדיקת תיעוד

## דוגמאות לחולשות שהמערכת מזהה

- SQL Injection
- XSS (Cross-Site Scripting)
- Hardcoded credentials
- Command injection
- Path traversal
- Insecure deserialization
- Missing input validation
- Error handling issues

## Istio / EZUA Configuration

המערכת כוללת תמיכה מלאה ב-Istio VirtualService:

```yaml
ezua:
  enabled: true
  virtualService:
    endpoint: "code-scanner.apps.your-domain.com"
    istioGateway: "istio-system/ezaf-gateway"
```
