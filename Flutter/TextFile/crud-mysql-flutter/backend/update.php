<?php
include 'config.php';

$data = json_decode(file_get_contents("php://input"));

$id    = $data->id ?? '';
$name  = $data->name ?? '';
$email = $data->email ?? '';

$sql = "UPDATE users SET name='$name', email='$email' WHERE id=$id";

if ($conn->query($sql)) {
    echo json_encode(["message" => "Data berhasil diupdate"]);
} else {
    echo json_encode(["error" => $conn->error]);
}
?>
