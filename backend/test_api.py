import os
from dotenv import load_dotenv
from google import genai

load_dotenv()
key = os.environ.get("GEMINI_API_KEY", "")
client = genai.Client(api_key=key)

response = client.models.generate_content(
    model="models/gemini-2.5-flash",
    contents="Hola, responde solo la palabra: funciona"
)
print("RESPUESTA:", response.text)