<?php include 'config.php'; ?>

<!DOCTYPE html>
<html lang="en">
<head>
  <title>CRUD PHP MySQL</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container py-4">
  <h2 class="mb-4">Form Input Data</h2>
  <form action="" method="POST" class="mb-4">
    <div class="mb-3">
      <input type="text" name="nama" class="form-control" placeholder="Nama" required>
    </div>
    <div class="mb-3">
      <input type="email" name="email" class="form-control" placeholder="Email" required>
    </div>
    <button type="submit" name="simpan" class="btn btn-primary">Simpan</button>
  </form>

  <?php
  if (isset($_POST['simpan'])) {
      $nama  = $_POST['nama'];
      $email = $_POST['email'];
      $query = mysqli_query($conn, "INSERT INTO users (nama, email) VALUES ('$nama', '$email')");
      if ($query) echo "<div class='alert alert-success'>Data berhasil disimpan!</div>";
  }
  ?>

  <h3>Data Tersimpan</h3>
  <table class="table table-bordered">
    <thead>
      <tr><th>#</th><th>Nama</th><th>Email</th><th>Aksi</th></tr>
    </thead>
    <tbody>
      <?php
      $no = 1;
      $data = mysqli_query($conn, "SELECT * FROM users");
      while ($row = mysqli_fetch_assoc($data)) {
          echo "<tr>
                  <td>$no</td>
                  <td>{$row['nama']}</td>
                  <td>{$row['email']}</td>
                  <td>
                    <a href='edit.php?id={$row['id']}' class='btn btn-warning btn-sm'>Edit</a>
                    <a href='delete.php?id={$row['id']}' class='btn btn-danger btn-sm' onclick='return confirm("Yakin?")'>Hapus</a>
                  </td>
                </tr>";
          $no++;
      }
      ?>
    </tbody>
  </table>
</body>
</html>