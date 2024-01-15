import 'package:flutter/material.dart';

void main() {
  runApp(BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: BMICalculatorScreen(),
    );
  }
}

class BMICalculatorScreen extends StatefulWidget {
  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  TextEditingController heightFeetController = TextEditingController();
  TextEditingController heightInchesController = TextEditingController();
  TextEditingController weightPoundsController = TextEditingController();
  double? bmiResult;
  String? healthCategory;
  String? errorMessage;

  void calculateBMI() {
    try {
      if (heightFeetController.text.isEmpty ||
          heightInchesController.text.isEmpty ||
          weightPoundsController.text.isEmpty) {
        throw Exception("Please enter all values for height and weight.");
      }

      double heightFeet = double.parse(heightFeetController.text);
      double heightInches = double.parse(heightInchesController.text);
      double weightPounds = double.parse(weightPoundsController.text);

      if (heightFeet <= 0 || heightInches < 0 || weightPounds <= 0) {
        throw Exception("Height and weight must be positive values.");
      }

      double heightCm = convertFeetInchesToCm(heightFeet, heightInches);
      double weightKg = convertPoundsToKg(weightPounds);

      double bmi = weightKg / (heightCm * heightCm / 10000);
      setState(() {
        bmiResult = bmi;
        healthCategory = getHealthCategory(bmi);
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        bmiResult = null;
        healthCategory = null;
      });
    }
  }

  double convertFeetInchesToCm(double feet, double inches) {
    return (feet * 30.48) + (inches * 2.54);
  }

  double convertPoundsToKg(double pounds) {
    return pounds * 0.453592;
  }

  String getHealthCategory(double bmi) {
    if (bmi < 18.5) {
      return "Underweight";
    } else if (bmi >= 18.5 && bmi < 25) {
      return "Normal";
    } else if (bmi >= 25 && bmi < 30) {
      return "Overweight";
    } else {
      return "Obese";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.accessibility,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: TextField(
                    controller: heightFeetController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      labelText: 'Feet',
                      labelStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: heightInchesController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      labelText: 'Inches',
                      labelStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: weightPoundsController,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                labelText: 'Enter Weight (lbs)',
                labelStyle: TextStyle(fontSize: 18),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                calculateBMI();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.pink,
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 20),
              ),
              child: Text('Calculate BMI'),
            ),
            SizedBox(height: 20),
            errorMessage != null
                ? Text(
              errorMessage!,
              style: TextStyle(fontSize: 18, color: Colors.red),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}
