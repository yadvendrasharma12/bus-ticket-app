import 'dart:io';
import 'package:bus_booking_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../serives/profile_serices.dart';
import '../../utils/shared_prefrance.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile;
  DateTime? _selectedDate;
  String _selectedGender="Select Gender";


  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final user = await ProfileService.fetchProfile();
    final imagePath = await MySharedPref.getProfileImage();

    if (mounted) {
      setState(() {
        _loading = false;

        if (user != null) {
          _nameController.text = user["name"] ?? "";
          _emailController.text = user["email"] ?? "";
          _mobileController.text = user["mobile"] ?? "";
        }

        if (imagePath != null && File(imagePath).existsSync()) {
          _imageFile = File(imagePath);
        }
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 70);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() => _imageFile = file);
      await MySharedPref.saveProfileImage(file.path);
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

        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:  _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.indigo))
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [

            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage:
                    _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? const Icon(Icons.person, size: 60, color: Colors.white)
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
                      child: const Icon(Icons.camera_alt,
                          color: Colors.white, size: 20),
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

            _buildEditableNameField(),
            const SizedBox(height: 12),

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
                "Profile Information",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildTextField("Email address", _emailController),
            const SizedBox(height: 22),
            _buildTextField("Mobile Number", _mobileController),
            const SizedBox(height: 22),
            _buildTextField("Address", _addressController),
            const SizedBox(height: 25),

            CustomButton(
              text: "Save",
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.indigo,
                    content: Text(
                      "Saved!\nName: ${_nameController.text}\nGender: $_selectedGender\nDOB: ${_selectedDate != null ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}" : "Not selected"}",
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

  // --- Editable Name Field (Top) ---
  Widget _buildEditableNameField() {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: "Full Name",
        labelStyle: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }

  // --- Gender Dropdown ---
// --- Gender Dropdown (Fixed) ---
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
          value: _selectedGender == "Select Gender" ? null : _selectedGender,
          hint: Text(
            "Select Gender",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.indigo,
            size: 28,
          ),
          items: ["Male", "Female", "Other"]
              .map(
                (gender) => DropdownMenuItem(
              value: gender,
              child: Text(
                gender,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          )
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedGender = value ?? "Select Gender";
            });
          },
        ),
      ),
    );
  }




  // --- Date Picker ---
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
            suffixIcon: const Icon(Icons.date_range_rounded,
                color: Colors.indigo, size: 24),
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

  // --- Editable Text Field (Profile Info) ---
  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
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
}



