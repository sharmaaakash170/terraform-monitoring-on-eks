from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List
from pymongo import MongoClient
from bson.objectid import ObjectId
from prometheus_fastapi_instrumentator import Instrumentator
from fastapi.middleware.cors import CORSMiddleware

import os

# ------------------------
# App Initialization
# ------------------------
app = FastAPI()
app.add_middleware(
  CORSMiddleware,
  allow_origins=["*"],           
  allow_methods=["*"],
  allow_headers=["*"],
  allow_credentials=True,
)

# ------------------------
# MongoDB Secure Connection
# ------------------------
MONGO_HOST = os.environ.get("MONGO_HOST", "mongodb-service")
MONGO_PORT = int(os.environ.get("MONGO_PORT", 27017))
MONGO_DB = os.environ.get("MONGO_DB", "library")
MONGO_USER = os.environ.get("MONGO_USER", "root")
MONGO_PASSWORD = os.environ.get("MONGO_PASSWORD", "example")

mongo_uri = f"mongodb://{MONGO_USER}:{MONGO_PASSWORD}@{MONGO_HOST}:{MONGO_PORT}/"
client = MongoClient(mongo_uri)
db = client[MONGO_DB]
books_collection = db["books"]

# ------------------------
# Prometheus Instrumentation
# ------------------------
Instrumentator().instrument(app).expose(app)

# ------------------------
# Pydantic Models
# ------------------------
class Book(BaseModel):
    title: str
    author: str
    year: int

class BookOut(Book):
    id: str

# ------------------------
# Routes
# ------------------------

@app.get("/books", response_model=List[BookOut])
def list_books():
    books = []
    for book in books_collection.find():
        books.append(BookOut(
            id=str(book["_id"]),
            title=book["title"],
            author=book["author"],
            year=book["year"]
        ))
    return books

@app.post("/books", response_model=BookOut)
def add_book(book: Book):
    result = books_collection.insert_one(book.dict())
    return BookOut(id=str(result.inserted_id), **book.dict())

@app.delete("/books/{book_id}")
def delete_book(book_id: str):
    result = books_collection.delete_one({"_id": ObjectId(book_id)})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Book not found")
    return {"message": "Book deleted successfully"}
