// App.js
import React, { useState, useEffect, useRef } from "react";

// Composant pour chaque tâche
function TaskItem({ task, toggleComplete, editTask, deleteTask }) {
  return (
    <li
      style={{
        display: "flex",
        alignItems: "center",
        marginBottom: "0.5rem",
        background: "#f4f4f4",
        padding: "0.5rem",
        borderRadius: "5px"
      }}
    >
      <input
        type="checkbox"
        checked={task.completed}
        onChange={() => toggleComplete(task.id)}
      />
      <span
        contentEditable
        suppressContentEditableWarning
        onBlur={(e) => editTask(task.id, e.target.textContent)}
        style={{
          textDecoration: task.completed ? "line-through" : "none",
          flex: 1,
          marginLeft: "0.5rem",
          cursor: "text"
        }}
      >
        {task.text}
      </span>
      <button
        onClick={() => deleteTask(task.id)}
        style={{
          marginLeft: "0.5rem",
          color: "white",
          background: "red",
          border: "none",
          borderRadius: "3px",
          padding: "0.2rem 0.5rem",
          cursor: "pointer"
        }}
      >
        Supprimer
      </button>
    </li>
  );
}

// Composant pour la liste de tâches
function TaskList({ tasks, toggleComplete, editTask, deleteTask }) {
  return (
    <ul style={{ listStyle: "none", padding: 0 }}>
      {tasks.map((task) => (
        <TaskItem
          key={task.id}
          task={task}
          toggleComplete={toggleComplete}
          editTask={editTask}
          deleteTask={deleteTask}
        />
      ))}
    </ul>
  );
}

// Composant pour le filtre
function Filter({ filter, setFilter }) {
  return (
    <div style={{ marginBottom: "1rem", textAlign: "center" }}>
      <button onClick={() => setFilter("all")} style={{ margin: "0 0.5rem" }}>
        Toutes
      </button>
      <button
        onClick={() => setFilter("completed")}
        style={{ margin: "0 0.5rem" }}
      >
        Terminées
      </button>
      <button
        onClick={() => setFilter("pending")}
        style={{ margin: "0 0.5rem" }}
      >
        En cours
      </button>
    </div>
  );
}

// Composant principal
function App() {
  const [tasks, setTasks] = useState(() => {
    const saved = localStorage.getItem("tasks");
    return saved ? JSON.parse(saved) : [];
  });
  const [newTask, setNewTask] = useState("");
  const [filter, setFilter] = useState("all");
  const inputRef = useRef(null);

  useEffect(() => {
    localStorage.setItem("tasks", JSON.stringify(tasks));
  }, [tasks]);

  const addTask = () => {
    if (!newTask.trim()) return;
    setTasks([...tasks, { id: Date.now(), text: newTask, completed: false }]);
    setNewTask("");
    inputRef.current.focus();
  };

  const deleteTask = (id) => setTasks(tasks.filter((task) => task.id !== id));

  const toggleComplete = (id) =>
    setTasks(
      tasks.map((task) =>
        task.id === id ? { ...task, completed: !task.completed } : task
      )
    );

  const editTask = (id, newText) =>
    setTasks(
      tasks.map((task) => (task.id === id ? { ...task, text: newText } : task))
    );

  const filteredTasks = tasks.filter((task) => {
    if (filter === "all") return true;
    if (filter === "completed") return task.completed;
    if (filter === "pending") return !task.completed;
    return true;
  });

  return (
    <div
      style={{
        padding: "2rem",
        maxWidth: "600px",
        margin: "auto",
        fontFamily: "Arial, sans-serif"
      }}
    >
      <h1 style={{ textAlign: "center" }}>📝 To-Do List</h1>

      {/* Ajouter une tâche */}
      <div style={{ display: "flex", marginBottom: "1rem" }}>
        <input
          ref={inputRef}
          type="text"
          value={newTask}
          onChange={(e) => setNewTask(e.target.value)}
          placeholder="Nouvelle tâche..."
          style={{ flex: 1, padding: "0.5rem", fontSize: "1rem" }}
          onKeyDown={(e) => e.key === "Enter" && addTask()}
        />
        <button
          onClick={addTask}
          style={{ padding: "0.5rem 1rem", marginLeft: "0.5rem" }}
        >
          Ajouter
        </button>
      </div>

      {/* Filtre */}
      <Filter filter={filter} setFilter={setFilter} />

      {/* Liste des tâches */}
      {filteredTasks.length > 0 ? (
        <TaskList
          tasks={filteredTasks}
          toggleComplete={toggleComplete}
          editTask={editTask}
          deleteTask={deleteTask}
        />
      ) : (
        <p style={{ textAlign: "center", color: "#888" }}>
          Aucune tâche à afficher.
        </p>
      )}

      {/* Supprimer toutes les tâches */}
      {tasks.length > 0 && (
        <div style={{ textAlign: "center", marginTop: "1rem" }}>
          <button
            onClick={() => setTasks([])}
            style={{
              background: "darkred",
              color: "white",
              padding: "0.5rem 1rem",
              border: "none",
              borderRadius: "5px",
              cursor: "pointer"
            }}
          >
            Supprimer toutes les tâches
          </button>
        </div>
      )}
    </div>
  );
}

export default App;
