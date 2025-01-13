from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
import uvicorn

app = FastAPI()

app.mount("/", StaticFiles(directory="./dist"), name="static")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=3307)