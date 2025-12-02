import 'package:bus_booking_app/controllers/auth_controllers.dart';
import 'package:bus_booking_app/controllers/bus_search_controller.dart';
import 'package:bus_booking_app/screens/homepage/widgets/custom_drawer.dart';
import 'package:bus_booking_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../serives/route_service.dart';
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

  List<String> recentFrom = [];
  List<String> recentTo = [];

  @override
  void initState() {
    super.initState();
    _loadRecentJourneys();
  }

  Future<void> _loadRecentJourneys() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recentFrom = prefs.getStringList('recentFrom') ?? [];
      recentTo = prefs.getStringList('recentTo') ?? [];
    });
  }

  Future<void> _saveRecentJourneys() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recentFrom', recentFrom);
    await prefs.setStringList('recentTo', recentTo);
  }

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [

            // Top Banner
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/backgroud_image.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon:  Icon(Icons.menu_rounded, color: Colors.white, size: 26),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
                Positioned(
                  top: 45,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      "GR Tour & Travel",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black54,
                            offset: Offset(1, 1),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 116,
                  left: 20,
                  right: 0,
                  child: Row(
                    children: [
                      Text(
                        "Hello, ",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black54,
                              offset: Offset(1, 1),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 5,),
                      Text(
                        getGreeting(),
                        style: GoogleFonts.poppins(
                          color: Colors.yellow.shade800,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black54,
                              offset: Offset(1, 1),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 152,
                  left: 20,
                  right: 0,
                  child: Text(
                    "Book Your Bus Ticket Instantly!",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black54,
                          offset: Offset(1, 1),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: height * 0.03),


            Container(

              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.only(top: 20, bottom: 0),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
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
              child: Padding(
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
                            recentSearches: recentFrom,
                          ),
                        ),
                        SizedBox(width: width * 0.02),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.swap_vert_rounded, color: Colors.indigo, size: 28),
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
                            recentSearches: recentTo,
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
                              padding: EdgeInsets.symmetric(vertical: height * 0.013),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.indigo.shade900),
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.white,
                              ),
                              child: selectedDate == null
                                  ? Icon(Icons.calendar_today_outlined, color: Colors.indigo.shade900, size: width * 0.05)
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
                    SizedBox(height: height * 0.035),
                    CustomButton(
                      backgroundColor: Colors.yellow.shade800,
                      text: "Let's check!",
                      onPressed: () async {
                        FocusScope.of(context).unfocus();

                        if (fromController.text.isEmpty || toController.text.isEmpty) {
                          Get.snackbar("Error", "Please fill both From and To fields", snackPosition: SnackPosition.BOTTOM);
                          return;
                        }

                        // Save recent journey
                        String from = fromController.text.trim();
                        String to = toController.text.trim();

                        bool exists = false;
                        for (int i = 0; i < recentFrom.length; i++) {
                          if (recentFrom[i] == from && recentTo[i] == to) {
                            exists = true;
                            break;
                          }
                        }

                        if (!exists) {
                          recentFrom.insert(0, from);
                          recentTo.insert(0, to);

                          if (recentFrom.length > 5) recentFrom = recentFrom.sublist(0, 5);
                          if (recentTo.length > 5) recentTo = recentTo.sublist(0, 5);

                          _saveRecentJourneys();
                        }

                        String date;
                        final now = DateTime.now();
                        if (selectedOption == "Today") {
                          date = "${now.year}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}";
                        } else if (selectedOption == "Tomorrow") {
                          final tomorrow = now.add(Duration(days: 1));
                          date = "${tomorrow.year}-${tomorrow.month.toString().padLeft(2,'0')}-${tomorrow.day.toString().padLeft(2,'0')}";
                        } else if (selectedDate != null) {
                          date = "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2,'0')}-${selectedDate!.day.toString().padLeft(2,'0')}";
                        } else {
                          Get.snackbar("Error", "Please select a date", snackPosition: SnackPosition.BOTTOM);
                          return;
                        }

                        final token = authController.token.value;

                        Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

                        try {
                          await busController.searchBuses(
                            origin: from,
                            destination: to,
                            date: date,
                            token: token,
                          );

                          if (busController.busList.isNotEmpty) {
                            if (Get.isDialogOpen ?? false) Get.back();
                            Get.to(() => const SearchBusScreen());
                          } else {
                            if (Get.isDialogOpen ?? false) Get.back();
                            Get.snackbar("No Buses", "No buses found for selected route and date.", snackPosition: SnackPosition.BOTTOM);
                          }
                        } catch (e) {
                          if (Get.isDialogOpen ?? false) Get.back();
                          Get.snackbar("Error", "Something went wrong while searching buses", snackPosition: SnackPosition.BOTTOM);
                        }
                      },
                    ),




                  ],
                ),
              ),
            ),
            SizedBox(height: 23,),
            _recentJourneyWidget(),
          ],
        ),
      ),
    );
  }


  Widget _recentJourneyWidget() {
    if (recentFrom.isEmpty) return SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Journeys",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.indigo.shade900,
            ),
          ),
          SizedBox(height: 12,),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: recentFrom.length,
            itemBuilder: (context, index) {
              final from = recentFrom[index];
              final to = recentTo.length > index ? recentTo[index] : "";

              return GestureDetector(
                onTap: () {
                  setState(() {
                    fromController.text = from;
                    toController.text = to;
                  });
                },
                child: Container(

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo.shade100, Colors.indigo.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(2, 3),
                      ),
                    ],
                    border: Border.all(color: Colors.indigo.shade200),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  margin: EdgeInsets.symmetric(vertical: 5), // Card ke beech thoda gap
                  child: Row(
                    children: [
                      Icon(Icons.pin_drop_rounded, color: Colors.indigo.shade700, size: 22),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "$from → $to",
                          style: GoogleFonts.poppins(
                            color: Colors.indigo.shade900,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            recentFrom.removeAt(index);
                            recentTo.removeAt(index);
                          });

                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setStringList('recentFrom', recentFrom);
                          await prefs.setStringList('recentTo', recentTo);
                        },
                        child: Icon(Icons.close, color: Colors.red.shade400, size: 22),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }





  Widget _customAutocompleteTextField(String hint,
      {required TextEditingController controller, required List<String> recentSearches}) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text.isEmpty) return recentSearches;
        final results = await RouteService.fetchStops(textEditingValue.text);
        return results.map((stop) => stop['name'].toString());
      },
      onSelected: (String selection) {
        controller.text = selection;
      },
      fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
        if (textController.text.isEmpty && controller.text.isNotEmpty) {
          textController.text = controller.text;
        }
        return TextField(
          controller: textController,
          focusNode: focusNode,
          onChanged: (value) => controller.text = value,
          style: GoogleFonts.poppins(color: Colors.indigo.shade900),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            hintText: hint,
            hintStyle: GoogleFonts.poppins(color: Colors.indigo.shade900.withOpacity(0.6)),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(6),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options.elementAt(index);
                return InkWell(
                  onTap: () => onSelected(option),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(option, style: GoogleFonts.poppins()),
                  ),
                );
              },
            ),
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

  String getGreeting() {
    int hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) return "Good Morning";
    if (hour >= 12 && hour < 17) return "Good Afternoon";
    if (hour >= 17 && hour < 21) return "Good Evening";
    return "Good Night";
  }
}
