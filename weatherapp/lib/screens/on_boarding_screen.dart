import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/screens/home_screen.dart';
import 'package:weatherapp/utils/constants.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  final List<Map<String, String>> _onboardingData = [
    {'image': 'assets/2.jpg', 'title': 'Selamat Datang!', 'description': 'Dapatkan informasi cuaca terkini dan akurat di kota Anda.'},
    {'image': 'assets/1.jpg', 'title': 'Prakiraan 7 Hari', 'description': 'Rencanakan aktivitas Anda dengan prakiraan cuaca hingga 7 hari ke depan.'},
    {'image': 'assets/3.jpg', 'title': 'Kualitas Udara', 'description': 'Pantau kualitas udara dan jaga kesehatan pernapasan Anda.'},
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() async {
    if (_currentPageIndex < _onboardingData.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(ApiConstants.seenOnboardingKey, true);
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (Route<dynamic> route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _onboardingData.length,
              onPageChanged: (int index) => setState(() => _currentPageIndex = index),
              itemBuilder: (context, index) => OnBoardingPage(image: _onboardingData[index]['image']!, title: _onboardingData[index]['title']!, description: _onboardingData[index]['description']!),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_onboardingData.length, (index) => _buildDot(index))),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15), backgroundColor: Colors.blueAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                onPressed: _goToNextPage,
                child: Text(_currentPageIndex == _onboardingData.length - 1 ? 'Mulai Sekarang' : 'Lanjut', style: const TextStyle(fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(margin: const EdgeInsets.only(right: 5), height: 10, width: _currentPageIndex == index ? 25 : 10, decoration: BoxDecoration(color: _currentPageIndex == index ? Colors.blueAccent : Colors.grey, borderRadius: BorderRadius.circular(5)));
  }
}

class OnBoardingPage extends StatelessWidget {
  final String image, title, description;
  const OnBoardingPage({super.key, required this.image, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(40.0), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Image.asset(image), const SizedBox(height: 40), Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold), textAlign: TextAlign.center), const SizedBox(height: 20), Text(description, style: const TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.center)]));
  }
}