import 'dart:io';
import 'package:bus_booking_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile;
  DateTime? _selectedDate;
  String _selectedGender = "Female";
  bool _isPasswordVisible = false; // 👁 Password visibility toggle

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 70);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.indigo),
              title: const Text("Take a photo"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.indigo),
              title: const Text("Choose from gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: Colors.indigo[900],
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_ios, color: Colors.indigo.shade800),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_horiz, color: Colors.indigo.shade800, size: 30),
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage:
                    _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? const Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                  GestureDetector(
                    onTap: _showPickerOptions,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        shape: BoxShape.circle,
                        color: Colors.indigo.shade800,
                      ),
                      child:
                      const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- Personal Info Section ---
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Personal",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 15),

            _buildStaticField("Anna Miller"),
            const SizedBox(height: 12),

            // --- Gender + Date of Birth ---
            Row(
              children: [
                Expanded(child: _buildGenderField()),
                const SizedBox(width: 10),
                Expanded(child: _buildDatePickerField(context)),
              ],
            ),
            const SizedBox(height: 25),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Email and password",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildTextField("Email", "anna@profile.com"),
            const SizedBox(height: 12),
            _buildPasswordField(),
            const SizedBox(height: 25),

            // --- Save Button ---
            CustomButton(
              text: "Save",
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.indigo,
                    content: Text(
                      "Saved!\nGender: $_selectedGender\nDOB: ${_selectedDate != null ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}" : "Not selected"}",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                );
              },
              backgroundColor: Colors.yellow.shade800,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Helper Widgets ----------------

  Widget _buildStaticField(String value) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 13),
      child: Text(
        value,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Gender dropdown
  Widget _buildGenderField() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Colors.indigo, size: 28),
          items: ["Male", "Female", "Other"]
              .map((gender) => DropdownMenuItem(
            value: gender,
            child: Text(
              gender,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedGender = value!;
            });
          },
        ),
      ),
    );
  }

  /// Date picker
  Widget _buildDatePickerField(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).unfocus();
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime(2001, 5, 7),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          setState(() {
            _selectedDate = pickedDate;
          });
        }
      },
      child: AbsorbPointer(
        child: TextField(
          decoration: InputDecoration(
            labelText: _selectedDate == null
                ? "Date of Birth"
                : "${_selectedDate!.day.toString().padLeft(2, '0')}/"
                "${_selectedDate!.month.toString().padLeft(2, '0')}/"
                "${_selectedDate!.year}",
            suffixIcon: const Icon(
              Icons.date_range_rounded, // ✅ New modern icon
              color: Colors.indigo,
              size: 24,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Email & Password field
  Widget _buildTextField(String label, String hint,
      {bool obscureText = false, IconData? suffixIcon}) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        hintText: hint,
        suffixIcon:
        suffixIcon != null ? Icon(suffixIcon, color: Colors.grey) : null,
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  /// Password with visibility toggle 👁
  Widget _buildPasswordField() {
    return TextField(
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        hintText: "********",
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.indigo,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
