<?php
// Conectare la baza de date
$mysqli = new mysqli("localhost", "xfoflart_andrei", "powersparq2024", "xfoflart_powersparq");

// Verifică conexiunea
if ($mysqli->connect_error) {
    die("Conexiunea a eșuat: " . $mysqli->connect_error);
}

// Preia datele trimise prin POST
$username = $mysqli->real_escape_string($_POST['username']);
$password = password_hash($_POST['password'], PASSWORD_DEFAULT); // Cripteaza parola

// Creeaza si executa interogarea SQL
$sql = "INSERT INTO users (username, password) VALUES ('$username', '$password')";
if ($mysqli->query($sql) === TRUE) {
    echo "Utilizatorul a fost înregistrat cu succes.";
} else {
    echo "Eroare: " . $sql . "<br>" . $mysqli->error;
}

// Inchide conexiunea
$mysqli->close();
?>
