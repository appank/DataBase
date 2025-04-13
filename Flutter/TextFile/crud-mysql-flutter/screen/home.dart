import 'package:flutter/material.dart';
import 'package:crud_mysql_flutter/class/class.dart';
import 'package:crud_mysql_flutter/providers/read.dart';
import 'package:crud_mysql_flutter/providers/create.dart';
import 'package:crud_mysql_flutter/providers/update.dart';
import 'package:crud_mysql_flutter/providers/delete.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<User>> futureUsers;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  int? selectedId; // null = tambah, ada id = edit

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() {
    setState(() {
      futureUsers = fetchUsers();
    });
  }

  void clearForm() {
    nameController.clear();
    emailController.clear();
    selectedId = null;
  }

  void saveData() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();

    if (name.isEmpty || email.isEmpty) return;

    if (selectedId == null) {
      // Tambah
      await createUser(name, email);
    } else {
      // Edit
      await updateUser(selectedId!, name, email);
    }

    clearForm();
    refreshData();
  }

  void editUser(User user) {
    setState(() {
      nameController.text = user.name;
      emailController.text = user.email;
      selectedId = user.id;
    });
  }

  void deleteUserConfirm(User user) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Hapus Data'),
            content: Text('Yakin ingin menghapus ${user.name}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await deleteUser(user.id);
                  Navigator.pop(context);
                  refreshData();
                },
                child: Text('Hapus'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manajemen User')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Form input/edit
            _buildTextField(nameController, "Data Barang"),
            const SizedBox(height: 16),
            _buildTextField2(emailController, "Masukkan Email", Icons.person),
            const SizedBox(height: 16),

            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B81DE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: saveData,
                  child: Text(
                    selectedId == null ? 'Tambah' : 'Simpan',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                if (selectedId != null)
                  TextButton(onPressed: clearForm, child: Text('Batal Edit')),
              ],
            ),
            SizedBox(height: 16),

            // List data
            Expanded(
              child: FutureBuilder<List<User>>(
                future: futureUsers,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final users = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width,
                          ),
                          child: DataTable(
                            columnSpacing: 20,
                            headingRowColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 196, 94, 94),
                            ),
                            columns: const [
                              DataColumn(label: Text('No')),
                              DataColumn(label: Text('Nama')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('')),
                            ],
                            rows:
                                users.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final user = entry.value;

                                  // Warna selang-seling
                                  final isEven = index % 2 == 0;
                                  final rowColor =
                                      isEven ? Colors.white : Colors.grey[100];

                                  return DataRow(
                                    color: MaterialStateProperty.all(rowColor),
                                    cells: [
                                      DataCell(Text('${index + 1}')),
                                      DataCell(Text(user.name)),
                                      DataCell(Text(user.email)),
                                      DataCell(
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              right: 20.0,
                                            ), // Padding kanan
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.edit,
                                                    color: Colors.orange,
                                                  ),
                                                  onPressed:
                                                      () => editUser(user),
                                                  tooltip: 'Edit',
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed:
                                                      () => deleteUserConfirm(
                                                        user,
                                                      ),
                                                  tooltip: 'Hapus',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildTextField(TextEditingController controller, String hintText) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 15, color: Colors.grey[400]),
        fillColor: const Color(0xFFF0F0F0),
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
      ),
    ),
  );
}

Widget _buildTextField2(
  TextEditingController controller,
  String hintText,
  IconData icon,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 15, color: Colors.grey[400]),
        fillColor: const Color(0xFFF0F0F0),
        filled: true,
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
      ),
    ),
  );
}
