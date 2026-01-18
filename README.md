# 📋 Task Management App

A simple and efficient **Task Management Application** built using **Flutter**.  
The app allows users to create, edit, delete, and filter tasks with persistent local storage.

---

## 🚀 Features

- ➕ Create new tasks
- ✏️ Edit existing tasks
- 🗑️ Delete tasks
- 📅 Set due date for tasks
- ✅ Mark tasks as **Completed** or **Pending**
- 🔍 Filter tasks:
    - All Tasks
    - Completed Tasks
    - Pending Tasks
- 💾 Offline data persistence using **Hive**
- 🎨 Clean and responsive **Material UI**
- ⚡ Smooth UI interactions

---

## 🧠 Architecture & State Management

- **State Management:** Provider
- **Architecture Pattern:** MVVM (Model–View–ViewModel)
- **Local Storage:** Hive (NoSQL database)

---

## 📱 Screens

- Splash Screen
- Task List Screen
- Add Task Screen
- Edit Task Screen
- Delete Confirmation Dialog

---

## 🛠️ Tech Stack

- **Flutter**
- **Dart**
- **Provider** – State management
- **Hive & Hive Flutter** – Local database
- **UUID** – Unique task IDs
- **Intl** – Date formatting

---

## 📦 Dependencies

```yaml
provider: ^6.1.5+1
hive: ^2.2.3
hive_flutter: ^1.1.0
uuid: ^4.5.2
intl: ^0.20.2
