import React, { useEffect, useState } from "react";
import axios from "axios";

const API_URL = ""; // inside Kubernetes

function App() {
  const [books, setBooks] = useState([]);
  const [newBook, setNewBook] = useState({ title: "", author: "", year: "" });

  const fetchBooks = async () => {
    const res = await axios.get('/api/books');
    setBooks(res.data);
  };

  const addBook = async () => {
    if (!newBook.title || !newBook.author || !newBook.year) return;
    await axios.post('/api/books', {  
      title: newBook.title,
      author: newBook.author,
      year: parseInt(newBook.year)
    });
    setNewBook({ title: "", author: "", year: "" });
    fetchBooks();
  };
  
  const deleteBook = async (id) => {
    await axios.delete(`/api/books/${id}`); 
    fetchBooks();
  };

  useEffect(() => {
    fetchBooks();
  }, []);

  return (
    <div style={{ padding: "20px" }}>
      <h1>📚 Book Library</h1>

      <div style={{ marginBottom: "20px" }}>
        <input
          placeholder="Title"
          value={newBook.title}
          onChange={(e) => setNewBook({ ...newBook, title: e.target.value })}
        />
        <input
          placeholder="Author"
          value={newBook.author}
          onChange={(e) => setNewBook({ ...newBook, author: e.target.value })}
        />
        <input
          placeholder="Year"
          value={newBook.year}
          onChange={(e) => setNewBook({ ...newBook, year: e.target.value })}
        />
        <button onClick={addBook}>Add Book</button>
      </div>

      <ul>
        {books.map((book) => (
          <li key={book.id}>
            <b>{book.title}</b> by {book.author} ({book.year})  
            <button onClick={() => deleteBook(book.id)}>❌ Delete</button>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default App;
