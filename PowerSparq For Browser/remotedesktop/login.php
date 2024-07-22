<?php
// Start a new session
session_start();

// Datele pentru conectarea la baza de date
$host = 'localhost'; // adresa IP a serverului de baze de date
$dbUsername = 'xfoflart_andrei'; // Utilizatorul bazei de date
$dbPassword = 'powersparq2024'; // Parola bazei de date
$dbName = 'xfoflart_powersparq'; // Numele bazei de date

// Crearea conexiunii la baza de date
$conn = new mysqli($host, $dbUsername, $dbPassword, $dbName);

// Verificarea conexiunii
if ($conn->connect_error) {
    die("Conexiunea a eșuat: " . $conn->connect_error);
}

// Preia username si password din POST
$username = $_POST['username'];
$password = $_POST['password'];

// Prevenirea SQL injection
$username = $conn->real_escape_string($username);
$query = "SELECT * FROM users WHERE username = '$username'";

$result = $conn->query($query);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    // Verifica daca parola se potriveste
    if (password_verify($password, $row['password'])) {
        // Parola se potriveste, initiaza sesiunea si redirectioneaza utilizatorul
        $_SESSION['loggedin'] = true;
        $_SESSION['username'] = $username;
        // Redirectioneaza catre folderul specific
        header("Location: https://websockify.andreinita.com");
        exit;
    } else {
        // Parola incorecta, redirectioneaza catre error.html
        header("Location: error.html");
        exit;
    }
} else {
    // Utilizatorul nu exista, redirecționeaza catre error.html
    header("Location: error.html");
    exit;
}

$conn->close();
?>