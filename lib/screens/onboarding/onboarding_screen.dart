import 'package:bus_booking_app/screens/auth/login/login_screen.dart';
import 'package:bus_booking_app/screens/auth/welcome/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/logo/onboarding4.jpg",
      "title": "Easy Ticket Booking",
      "desc":
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore."
    },
    {
      "image": "assets/logo/logo8.png",
      "title": "Online Payment",
      "desc":
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore."
    },
    {
      "image": "assets/logo/onboarding 1.jpg",
      "title": "No Need To Queue",
      "desc":
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) => OnboardContent(
                  image: onboardingData[index]["image"]!,
                  title: onboardingData[index]["title"]!,
                  desc: onboardingData[index]["desc"]!,
                ),
              ),
            ),
            SizedBox(height: 32,),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onboardingData.length,
                            (index) => buildDot(index: index),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                           Get.to(LoginScreen());
                          },
                          child:  Text(
                            "Skip",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.indigo.shade800),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  Colors.yellow.shade800,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            if (_currentPage == onboardingData.length - 1) {
                              Get.to(WelcomeScreen());
                            } else {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            }
                          },
                          child: Text(
                            _currentPage == onboardingData.length - 1
                                ? "Get Started"
                                : "Next",
                            style:  GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: _currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: _currentPage == index
            ?  Colors.yellow.shade800
            : Colors.indigo.shade800,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class OnboardContent extends StatelessWidget {
  final String image, title, desc;

  const OnboardContent({
    super.key,
    required this.image,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Expanded(
          child: Image.asset(image, fit: BoxFit.contain),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.yellow.shade800,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(
            desc,
            textAlign: TextAlign.center,
            style:  GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black54,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ),
      ],
    );
  }
}
