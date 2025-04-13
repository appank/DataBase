<?php
include 'config.php';

$data = json_decode(file_get_contents("php://input"));

$name = $data->name ?? '';
$email = $data->email ?? '';

$sql = "INSERT INTO users (name, email) VALUES ('$name', '$email')";

if ($conn->query($sql)) {
    echo json_encode(["message" => "Data berhasil ditambahkan"]);
} else {
    echo json_encode(["error" => $conn->error]);
}
?>
