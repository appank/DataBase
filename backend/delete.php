<?php
include 'config.php';

$data = json_decode(file_get_contents("php://input"));
$id = isset($data->id) ? (int)$data->id : 0;

if ($id > 0) {
    $sql = "DELETE FROM users WHERE id=$id";
    if ($conn->query($sql)) {
        echo json_encode(["message" => "Data berhasil dihapus"]);
    } else {
        echo json_encode(["error" => $conn->error]);
    }
} else {
    echo json_encode(["error" => "ID tidak valid"]);
}
?>