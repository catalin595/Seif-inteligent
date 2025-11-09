<!doctype html>
<html lang="ro">
<head>
    <meta charset="UTF-8">
    <title>Activity Log</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
</head>
<body>
    <h1>Activity Log</h1>
    <form action="{{ url_for('reset_activity') }}" method="post" onsubmit="return confirm('Sigur doresti  sa resetezi log-ul de activitate?');">
        <button type="submit">Reset Activity Log</button>
    </form>
    <table border="1">
        <thead>
            <tr>
                <th>Card UID</th>
                <th>Utilizator</th>
                <th>Acces</th>
                <th>Data si ora</th>
            </tr>
        </thead>
        <tbody>
            {% for log in logs %}
            <tr>
                <td>{{ log.card_uid }}</td>
                <td>{{ log.owner_name }}</td>
                <td>{{ log.event_type }}</td>
                <td>{{ log.event_time }}</td>
            </tr>
            {% endfor %}
        </tbody>
    </table>
    <br>
    <a href="{{ url_for('dashboard') }}">Inapoi la Dashboard</a>
</body>
</html>
