import 'package:bus_booking_app/controllers/auth_controllers.dart';
import 'package:bus_booking_app/controllers/bus_search_controller.dart';
import 'package:bus_booking_app/screens/homepage/widgets/custom_drawer.dart';
import 'package:bus_booking_app/widgets/custom_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../bus_listing/search_bus_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedOption = "Today";
  DateTime? selectedDate;

  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final BusSearchController busController = Get.put(BusSearchController());
  final AuthController authController = Get.put(AuthController());

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedOption = "";
        selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    busController.dispose();
    super.dispose();
  }

  final CarouselController carouselController = CarouselController();
  int _currentPage = 0;

  final List<String> images = [
    "assets/images/1.png",
    "assets/images/2.png",
    "assets/images/3.png",
    "assets/images/4.png",
    "assets/images/5.png",
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu_rounded, color: Colors.indigo),
          ),
        ),
        title: Text(
          "GR Tour & Travel",
          style: GoogleFonts.poppins(
            fontSize: width * 0.045,
            fontWeight: FontWeight.w700,
            color: Colors.indigo[900],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: height * 0.015,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16,),
            CarouselSlider(
              items: images.map((imgPath) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      imgPath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 160,
                aspectRatio: 16 / 9,
                viewportFraction: 0.99,
                initialPage: 0,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentPage = index;
                  });
                },
              ),
            ),

            const SizedBox(height: 16),
            Center(
              child: AnimatedSmoothIndicator(
                activeIndex: _currentPage,
                count: images.length,
                effect:  ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.yellow.shade800,
                  dotColor: Colors.grey,
                ),

              ),
            ),

            SizedBox(height: height * 0.04),
            // 🔹 Search Bus Section
            Container(
              padding: const EdgeInsets.only(top: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Let’s find a bus",
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo.shade900,
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _customAutocompleteTextField(
                                "From",
                                controller: fromController,
                                options: ["Mumbai", "Pune", "Delhi", "Bangalore", "Chennai","Noida"],
                              ),
                            ),
                            SizedBox(width: width * 0.02),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.swap_vert_rounded,
                                  color: Colors.indigo,
                                  size: 28,
                                ),
                                onPressed: () {
                                  final temp = fromController.text;
                                  fromController.text = toController.text;
                                  toController.text = temp;
                                },
                              ),
                            ),
                            SizedBox(width: width * 0.02),
                            Expanded(
                              flex: 2,
                              child: _customAutocompleteTextField(
                                "To",
                                controller: toController,
                                options: ["Mumbai", "Pune", "Delhi", "Bangalore", "Chennai","Noida"],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: height * 0.025),
                        Text(
                          "Date",
                          style: GoogleFonts.poppins(
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w500,
                            color: Colors.indigo.shade900,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Row(
                          children: [
                            Expanded(child: _buildSelectableChip("Today")),
                            SizedBox(width: width * 0.015),
                            Expanded(child: _buildSelectableChip("Tomorrow")),
                            SizedBox(width: width * 0.015),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _pickDate(context),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: height * 0.013,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border:
                                    Border.all(color: Colors.indigo.shade900),
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.white,
                                  ),
                                  child: selectedDate == null
                                      ? Icon(Icons.calendar_today_outlined,
                                      color: Colors.indigo.shade900,
                                      size: width * 0.05)
                                      : Text(
                                    "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: width * 0.032,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.035),
                  CustomButton(
                    backgroundColor: Colors.yellow.shade800,
                    text: "Let's check!",
                    onPressed: () async {
                      // 🔹 Keyboard hide
                      FocusScope.of(context).unfocus();

                      if (fromController.text.isEmpty || toController.text.isEmpty) {
                        Get.snackbar("Error", "Please fill both From and To fields",
                            snackPosition: SnackPosition.BOTTOM);
                        return;
                      }

                      String date;
                      final now = DateTime.now();

                      if (selectedOption == "Today") {
                        date =
                        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
                      } else if (selectedOption == "Tomorrow") {
                        final tomorrow = now.add(const Duration(days: 1));
                        date =
                        "${tomorrow.year}-${tomorrow.month.toString().padLeft(2, '0')}-${tomorrow.day.toString().padLeft(2, '0')}";
                      } else if (selectedDate != null) {
                        date =
                        "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";
                      } else {
                        Get.snackbar("Error", "Please select a date",
                            snackPosition: SnackPosition.BOTTOM);
                        return;
                      }

                      final token = authController.token.value;

                      // 🔹 Loading dialog
                      Get.dialog(
                        const Center(child: CircularProgressIndicator()),
                        barrierDismissible: false,
                      );

                      await busController.searchBuses(
                        origin: fromController.text,
                        destination: toController.text,
                        date: date,
                        token: token,
                      );

                      // 🔹 Close loading
                      if (Get.isDialogOpen ?? false) Get.back();


                      Get.to(() => const SearchBusScreen());
                    },
                  ),



                  SizedBox(height: height * 0.02),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateCard(String month, String day, double width) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.02),
      padding: const EdgeInsets.all(10),
      width: width * 0.3,
      height: 125,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.indigo.shade800),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(month,
              style: GoogleFonts.poppins(
                fontSize: width * 0.035,
                fontWeight: FontWeight.w700,
                color: Colors.indigo[900],
              )),
          Text(day,
              style: GoogleFonts.poppins(
                fontSize: width * 0.07,
                fontWeight: FontWeight.w600,
                color: Colors.indigo[900],
              )),
          Text("Maharashtra",
              style: GoogleFonts.poppins(
                fontSize: width * 0.03,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 4),
          Text("Delhi",
              style: GoogleFonts.poppins(
                fontSize: width * 0.03,
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }

  Widget _customAutocompleteTextField(
      String hint, {
        required TextEditingController controller,
        required List<String> options,
      }) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return options.where(
              (option) => option.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          ),
        );
      },
      onSelected: (String selection) {
        controller.text = selection; // ✅ yahi sahi jagah hai update ki
      },
      fieldViewBuilder: (
          BuildContext context,
          TextEditingController textController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted,
          ) {
        // ❌ yeh line MAT likho:
        // textController.text = controller.text;

        // Bas agar external controller me value already hai
        // to sirf first time sync karna ho to:
        if (textController.text.isEmpty && controller.text.isNotEmpty) {
          textController.text = controller.text;
        }

        return TextField(
          controller: textController,
          focusNode: focusNode,
          onChanged: (value) {
            // ✅ external controller ko in-sync rakhne ke liye
            controller.text = value;
          },
          style: GoogleFonts.poppins(color: Colors.indigo.shade900),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: Colors.indigo.shade900.withOpacity(0.6),
            ),
          ),
        );
      },
      optionsViewBuilder: (
          BuildContext context,
          AutocompleteOnSelected<String> onSelected,
          Iterable<String> options,
          ) {
        return Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(6),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final option = options.elementAt(index);
              return InkWell(
                onTap: () {
                  onSelected(option);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(option, style: GoogleFonts.poppins()),
                ),
              );
            },
          ),
        );
      },
    );
  }



  Widget _buildSelectableChip(String label) {
    bool isSelected = selectedOption == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = label;
          selectedDate = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.indigo.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.indigo.shade900),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
