# 🔐 Smart Safe with Multi-Factor Authentication

**Author:** Babii Cătălin-Dumitru  
**University:** UNST Politehnica București  
**Faculty:** Electronics, Telecommunications and Information Technology  
**Project Type:** Bachelor’s Thesis (2025)

---

## 🧠 Overview
This project implements a **smart safe** controlled by a **Raspberry Pi 5** and **Arduino**, secured through **multi-factor authentication**:
- Fingerprint recognition (TTL sensor)
- RFID card identification
- 4-digit PIN code

The system features a web interface for **real-time monitoring, event logging, and access management**.

---

## ⚙️ Hardware Components
- Raspberry Pi 5 (4 GB)
- Arduino (RFID + LCD)
- TTL Optical Fingerprint Sensor
- Servo Motor SG90
- 16x2 LCD Display
- RFID RC522 Module
- Battery Holders (4xR6)
- JRP7007 Touch Display

---

## 🧩 Software & Tools
- Python (Flask, MySQL Connector)
- C/C++ for Arduino
- MariaDB / MySQL
- HTML, CSS, JavaScript
- Raspberry Pi OS

---

## 🚀 Features
✅ Multi-factor authentication (Fingerprint + RFID + PIN)  
✅ Real-time web interface with logs  
✅ Alarm on unauthorized access  
✅ Separate power supply for motor & sensors  
✅ Automatic event logging to MariaDB  

---

## 🖥️ System Architecture
![System Diagram](images/system_diagram.png)

---

## 📊 Database Schema
```sql
-- Example table
CREATE TABLE access_log (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id VARCHAR(10),
  method VARCHAR(20),
  status VARCHAR(20),
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

