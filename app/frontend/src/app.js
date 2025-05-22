import React, { useEffect, useState } from "react";
import axios from "axios";

const API_URL = "http://a0e72b77a635a46df8cabe892b6d65bd-477770728.us-east-1.elb.amazonaws.com:8000/"; // inside Kubernetes

function App() {
  const [books, setBooks] = useState([]);
  const [newBook, setNewBook] = useState({ title: "", author: "", year: "" });

  const fetchBooks = async () => {
    const res = await axios.get(`${API_URL}/books`);
    setBooks(res.data);
  };

  const addBook = async () => {
    if (!newBook.title || !newBook.author || !newBook.year) return;
    await axios.post(`${API_URL}/books`, {
      title: newBook.title,
      author: newBook.author,
      year: parseInt(newBook.year)
    });
    setNewBook({ title: "", author: "", year: "" });
    fetchBooks();
  };

  const deleteBook = async (id) => {
    await axios.delete(`${API_URL}/books/${id}`);
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
