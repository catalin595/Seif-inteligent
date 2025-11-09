
# -*- coding: utf-8 -*-
from flask import Flask, render_template, request, redirect, session, url_for
import mysql.connector

app = Flask(__name__)
app.secret_key = 'some_secret_key'  # Schimba cu o cheie secreta pentru produc?ie

def get_db_connection():
    conn = mysql.connector.connect(
        host="localhost",
        user="utilizator",       # Asigura-te ca utilizatorul exista ?i are acces
        password="1234",         # Parola asociata
        database="seif_access"
    )
    return conn

# Ruta de login (exemplu simplu)
@app.route('/login', methods=['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
        username = request.form.get('username', '').strip()
        password = request.form.get('password', '').strip()
        # Creden?iale hard-coded; extinde dupa nevoie
        if username == "admin" and password == "admin":
            session['logged_in'] = True
            return redirect(url_for('dashboard'))
        else:
            error = "Creden?iale invalide. ncearca din nou."
    return render_template('login.html', error=error)
@app.route('/')
def index():
    if not session.get('logged_in'):
        return redirect(url_for('login'))
    return redirect(url_for('dashboard'))

# Dashboard simplu
@app.route('/dashboard')
def dashboard():
    if not session.get('logged_in'):
        return redirect(url_for('login'))
    return render_template('dashboard.html')

# Activity Log: folosim event_type din activity_log pentru status
@app.route('/activity')
def activity():
    if not session.get('logged_in'):
        return redirect(url_for('login'))
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    sql = """
        SELECT 
            al.log_id as id,
            al.card_uid,
            COALESCE(rc.owner_name, 'N/A') as owner_name,
            al.event_type,
            al.event_time 
        FROM activity_log al
        LEFT JOIN rfid_cards rc ON al.card_uid = REPLACE(rc.card_uid, ':', '')
        ORDER BY al.event_time DESC;
    """
    cursor.execute(sql)
    logs = cursor.fetchall()
cursor.close()
    conn.close()
    return render_template('activity.html', logs=logs)

@app.route('/reset_activity', methods=['POST'])
def reset_activity():
    if not session.get('logged_in'):
        return redirect(url_for('login'))
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM activity_log")
    conn.commit()
    cursor.close()
    conn.close()
    return redirect(url_for('activity'))


# RFID Manager: permite modificarea starii de acces n rfid_cards
@app.route('/rfid', methods=['GET', 'POST'])
def rfid():
    if not session.get('logged_in'):
        return redirect(url_for('login'))
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    message = None

    if request.method == 'POST':
        card_id = request.form.get('card_id')
        action = request.form.get('action')  # "allow" sau "disallow"
        if card_id and action:
            allowed = 1 if action == 'allow' else 0
            cursor.execute("UPDATE rfid_cards SET allowed = %s WHERE card_id = %s", (allowed, card_id))
conn.commit()
            message = "RFID actualizat cu succes."
    
    cursor.execute("SELECT * FROM rfid_cards ORDER BY card_id ASC")
    rfid_cards = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('rfid_manage.html', rfid_cards=rfid_cards, message=message)

@app.route('/logout')
def logout():
    session['logged_in'] = False
    return redirect(url_for('login'))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
