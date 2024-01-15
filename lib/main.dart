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
  TextEditingController weightKgController = TextEditingController();
  double? bmiResult;
  String? healthCategory;
  String? errorMessage;

  void calculateBMI() {
    try {
      if ([heightFeetController, heightInchesController, weightKgController]
          .any((controller) => controller.text.isEmpty)) {
        throw Exception("Please enter all values for height and weight.");
      }

      double heightFeet = double.parse(heightFeetController.text);
      double heightInches = double.parse(heightInchesController.text);
      double weightKg = double.parse(weightKgController.text);

      if (heightFeet <= 0 || heightInches < 0 || weightKg <= 0) {
        throw Exception("Height and weight must be positive values.");
      }

      double heightCm = (heightFeet * 30.48) + (heightInches * 2.54);

      double bmi = weightKg / (heightCm * heightCm / 10000);
      setState(() {
        bmiResult = bmi;
        healthCategory = _getHealthCategory(bmi);
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

  String _getHealthCategory(double bmi) {
    if (bmi < 18.5) {
      return "Underweight";
    } else if (bmi < 25) {
      return "Normal";
    } else if (bmi < 30) {
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
                  child: _buildTextField(
                    controller: heightFeetController,
                    label: 'Feet',
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: _buildTextField(
                    controller: heightInchesController,
                    label: 'Inches',
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildTextField(
              controller: weightKgController,
              label: 'Weight (kg)',
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateBMI,
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
            SizedBox(height: 20),
            bmiResult != null && healthCategory != null
                ? Column(
              children: [
                _buildResultText('BMI Result: ${bmiResult!.toStringAsFixed(2)}'),
                SizedBox(height: 10),
                _buildResultText('Health Category: $healthCategory'),
              ],
            )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 18),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildResultText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 18),
    );
  }
}
