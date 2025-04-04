import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextFile extends StatefulWidget {
  const TextFile({super.key});

  @override
  State<TextFile> createState() => _TextFileState();
}

class _TextFileState extends State<TextFile> {
  bool _obscureText = true; //Password 1

  String? _selectedGender; //DropDown

  //khusus tanggal
  DateTime? _selectedDate;

  //password 2
  final TextEditingController _passwordController = TextEditingController();
  double strength = 0;

  //password 3
  // bool _obscureText = true;
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;
  bool _hasSymbols = false;
  bool _hasUpperCase = false;
  bool _hasLowerCase = false;

  void checkPassword3(String password) {
    setState(() {
      _isPasswordEightCharacters = password.length >= 8;
      _hasPasswordOneNumber = RegExp(r'[0-9]').hasMatch(password);
      _hasSymbols = RegExp(r'[!@#\$%^&*()]').hasMatch(password);
      _hasUpperCase = RegExp(r'[A-Z]').hasMatch(password);
      _hasLowerCase = RegExp(r'[a-z]').hasMatch(password);
    });
  }

  //khusus jumlah tanggal
  DateTimeRange? _selectedDateRange;

  //khusus tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  //khusus jumlah tanggal
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000, 1, 1),
      lastDate: DateTime(2100, 12, 31),
      saveText: 'Done',
    );
    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  //khusus password
  late String password;
  bool isObscure = false;
  // 0: No password
  // 1/4: Weak
  // 2/4: Medium
  // 3/4: Strong
  // 1: Great

  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");

  String displayText = 'Masukkan Password';

  void checkPassword(String value) {
    if (value.isEmpty) {
      setState(() {
        strength = 0;
        displayText = 'Masukkan Password';
      });
    } else if (value.length < 6) {
      setState(() {
        strength = 1 / 4;
        displayText = 'Terlalu pendek';
      });
    } else if (value.length < 8) {
      setState(() {
        strength = 2 / 4;
        displayText = 'Kurang kuat';
      });
    } else {
      if (!letterReg.hasMatch(value) || !numReg.hasMatch(value)) {
        setState(() {
          strength = 3 / 4;
          displayText = 'Cukup kuat';
        });
      } else {
        setState(() {
          strength = 1;
          displayText = 'Sangat kuat';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(62, 174, 116, 1.0),
        title: const Text("Form Input"),
      ),
      backgroundColor: const Color.fromARGB(255, 231, 231, 231),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField("Masukkan Nama Lengkap"),
            const SizedBox(height: 16),
            _buildTextField2("Masukkan Email", Icons.person),
            const SizedBox(height: 16),
            _buildPasswordField("Masukkan Password"), //password 2
            const SizedBox(height: 24),
            _buildPasswordField2("Masukkan Password"), // password 2
            const SizedBox(height: 10),
            LinearProgressIndicator(
              //password 2
              value: strength,
              backgroundColor: Colors.grey[300],
              color:
                  strength <= 1 / 4
                      ? Colors.red
                      : strength == 2 / 4
                      ? Colors.yellow
                      : strength == 3 / 4
                      ? Colors.blue
                      : Colors.green,
              minHeight: 10,
            ),
            const SizedBox(height: 10),
            Text(
              displayText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color:
                    strength <= 1 / 4
                        ? Colors.red
                        : strength == 2 / 4
                        ? Colors.yellow
                        : strength == 3 / 4
                        ? Colors.blue
                        : Colors.green,
              ),
            ),
            const SizedBox(height: 30), //password 3
            _buildPasswordField3("Enter your password"), //password 3
            const SizedBox(height: 30),
            _buildPasswordValidation(), // password 3
            const SizedBox(height: 50),
            _buildLabeledTextField4("Cari Disini", Icons.search),
            const SizedBox(height: 24),
            _buildDatePicker(),
            const SizedBox(height: 24),
            _buildDateRangePicker(),
            const SizedBox(height: 24),
            _buildGenderDropdown(),
            const SizedBox(height: 24),

            Container(
              width: MediaQuery.of(context).size.width,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B81DE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () async {},
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
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

  Widget _buildTextField2(String hintText, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
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

  Widget _buildPasswordField(String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        obscureText: _obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 15, color: Colors.grey[400]),
          fillColor: const Color(0xFFF0F0F0),
          filled: true,
          prefixIcon: const Icon(Icons.lock, color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
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

  Widget _buildLabeledTextField4(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          // labelText: label,
          labelStyle: const TextStyle(
            color: Color.fromARGB(255, 137, 138, 137),
          ),
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey[400]),
          fillColor: const Color(0xFFF0F0F0),
          filled: true,
          prefixIcon: Icon(icon, color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 255, 255, 255),
              width: 1.5,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.green, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 116, 116, 116),
              width: 2.5,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField2(String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _passwordController,
        onChanged: (value) => checkPassword(value),
        obscureText: _obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 15, color: Colors.grey[400]),
          fillColor: const Color(0xFFF0F0F0),
          filled: true,
          prefixIcon: const Icon(Icons.lock, color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
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

  //password 3
  Widget _buildPasswordField3(String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _passwordController,
        onChanged: checkPassword3,
        obscureText: _obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 15, color: Colors.grey[400]),
          fillColor: const Color(0xFFF0F0F0),
          filled: true,
          prefixIcon: const Icon(Icons.lock, color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () => setState(() => _obscureText = !_obscureText),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordValidation() {
    return Column(
      children: [
        CustomTile(
          isCheck: _isPasswordEightCharacters,
          title: "At least 8 characters",
        ),
        const SizedBox(height: 10),
        CustomTile(isCheck: _hasUpperCase, title: "Contains Uppercase"),
        const SizedBox(height: 10),
        CustomTile(isCheck: _hasLowerCase, title: "Contains Lowercase"),
        const SizedBox(height: 10),
        CustomTile(
          isCheck: _hasPasswordOneNumber,
          title: "Contains at least 1 number",
        ),
        const SizedBox(height: 10),
        CustomTile(isCheck: _hasSymbols, title: "Contains Symbols (!@#)"),
      ],
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          fillColor: const Color(0xFFF0F0F0),
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate == null
                  ? 'Pilih Tanggal Lahir'
                  : DateFormat('dd-MM-yyyy').format(_selectedDate!),
              style: const TextStyle(fontSize: 15, color: Colors.black),
            ),
            const Icon(Icons.calendar_today, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangePicker() {
    return GestureDetector(
      onTap: () => _selectDateRange(context),
      child: InputDecorator(
        decoration: InputDecoration(
          fillColor: const Color(0xFFF0F0F0),
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDateRange == null
                  ? 'Pilih Rentang Tanggal'
                  : '${DateFormat('dd-MM-yyyy').format(_selectedDateRange!.start)} - ${DateFormat('dd-MM-yyyy').format(_selectedDateRange!.end)}',
              style: const TextStyle(fontSize: 15, color: Colors.black),
            ),
            const Icon(Icons.date_range, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      items: const [
        DropdownMenuItem(value: "Laki-laki", child: Text("Laki-laki")),
        DropdownMenuItem(value: "Perempuan", child: Text("Perempuan")),
      ],
      decoration: InputDecoration(
        hintText: "Pilih Jenis Kelamin",
        fillColor: const Color(0xFFF0F0F0),
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onChanged: (value) {
        setState(() {
          _selectedGender = value;
        });
      },
    );
  }
}

//password 3
class CustomTile extends StatelessWidget {
  const CustomTile({Key? key, required this.title, required this.isCheck})
    : super(key: key);

  final bool isCheck;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: isCheck ? Colors.green : const Color.fromARGB(0, 23, 22, 22),
            border:
                isCheck
                    ? Border.all(color: Colors.transparent)
                    : Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Center(
            child: Icon(Icons.check, color: Colors.white, size: 15),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
      ],
    );
  }
}
