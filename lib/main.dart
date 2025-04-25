import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  TextEditingController controlWeight = TextEditingController();
  TextEditingController controlHeight = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _info = "Report your data";
  double _bmiValue = 0.0;
  String _currentLanguage = 'en'; // Default to English

  final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'BMI CALCULATOR',
      'weight': 'Weight (Kg)',
      'height': 'Height (cm)',
      'calculate': 'Calculate',
      'reset': 'Reset',
      'report': 'Report your data',
      'invalid': 'Invalid input!',
      'underweight': 'Below weight',
      'normal': 'Ideal Weight',
      'overweight': 'Slightly Overweight',
      'obesity1': 'Obesity Grade I',
      'obesity2': 'Obesity Grade II',
      'obesity3': 'Obesity Grade III',
    },
    'fr': {
      'title': 'CALCULATEUR IMC',
      'weight': 'Poids (Kg)',
      'height': 'Taille (cm)',
      'calculate': 'Calculer',
      'reset': 'Réinitialiser',
      'report': 'Entrez vos données',
      'invalid': 'Entrée invalide!',
      'underweight': 'Poids insuffisant',
      'normal': 'Poids idéal',
      'overweight': 'Surpoids léger',
      'obesity1': 'Obésité Niveau I',
      'obesity2': 'Obésité Niveau II',
      'obesity3': 'Obésité Niveau III',
    },
    'ar': {
      'title': 'حاسبة مؤشر كتلة الجسم',
      'weight': 'الوزن (كغ)',
      'height': 'الطول (سم)',
      'calculate': 'احسب',
      'reset': 'إعادة تعيين',
      'report': 'أدخل بياناتك',
      'invalid': 'إدخال غير صحيح!',
      'underweight': 'نقص في الوزن',
      'normal': 'وزن مثالي',
      'overweight': 'زيادة وزن طفيفة',
      'obesity1': 'سمنة درجة أولى',
      'obesity2': 'سمنة درجة ثانية',
      'obesity3': 'سمنة درجة ثالثة',
    },
  };

  String _translate(String key) {
    return _localizedValues[_currentLanguage]?[key] ?? key;
  }

  void _changeLanguage(String languageCode) {
    setState(() {
      _currentLanguage = languageCode;
      // Update info text when language changes
      if (_info != "Report your data" && _info != _translate('report')) {
        calculate();
      } else {
        _info = _translate('report');
      }
    });
  }

  void _resetFields() {
    controlHeight.clear();
    controlWeight.clear();
    setState(() {
      _info = _translate('report');
      _bmiValue = 0.0;
      _formKey.currentState?.reset();
    });
  }

  void calculate() {
    setState(() {
      double? weight = double.tryParse(controlWeight.text);
      double? height = double.tryParse(controlHeight.text);

      if (weight == null || height == null || height == 0) {
        _info = _translate('invalid');
        _bmiValue = 0.0;
        return;
      }

      height = height / 100;
      double imc = weight / (height * height);
      _bmiValue = imc;

      if (imc < 18.6) {
        _info = "${_translate('underweight')} (${imc.toStringAsPrecision(4)})";
      } else if (imc <= 24.9) {
        _info = "${_translate('normal')} (${imc.toStringAsPrecision(4)})";
      } else if (imc <= 29.9) {
        _info = "${_translate('overweight')} (${imc.toStringAsPrecision(4)})";
      } else if (imc <= 34.9) {
        _info = "${_translate('obesity1')} (${imc.toStringAsPrecision(4)})";
      } else if (imc <= 39.9) {
        _info = "${_translate('obesity2')} (${imc.toStringAsPrecision(4)})";
      } else {
        _info = "${_translate('obesity3')} (${imc.toStringAsPrecision(4)})";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_translate('title'), style: TextStyle(fontFamily: "Segoe UI")),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetFields,
            tooltip: _translate('reset'),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.language),
            onSelected: _changeLanguage,
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'en',
                child: Text('English'),
              ),
              PopupMenuItem<String>(
                value: 'fr',
                child: Text('Français'),
              ),
              PopupMenuItem<String>(
                value: 'ar',
                child: Text('العربية'),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Directionality(
          textDirection: _currentLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.person, size: 120.0, color: Colors.green),
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: _translate('weight'),
                    labelStyle: TextStyle(color: Colors.green),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 25.0),
                  controller: controlWeight,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _currentLanguage == 'ar'
                          ? "أدخل وزنك!"
                          : _currentLanguage == 'fr'
                              ? "Entrez votre poids!"
                              : "Insert your weight!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: _translate('height'),
                    labelStyle: TextStyle(color: Colors.green),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 25.0),
                  controller: controlHeight,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _currentLanguage == 'ar'
                          ? "أدخل طولك!"
                          : _currentLanguage == 'fr'
                              ? "Entrez votre taille!"
                              : "Insert your height!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        calculate();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text(
                      _translate('calculate'),
                      style: TextStyle(color: Colors.white, fontSize: 25.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _buildBMIGauge(),
                SizedBox(height: 20),
                Text(
                  _info,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 25.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBMIGauge() {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 10,
          maximum: 50,
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 10,
              endValue: 18.5,
              color: Colors.blue,
              label: _translate('underweight'),
            ),
            GaugeRange(
              startValue: 18.5,
              endValue: 24.9,
              color: Colors.green,
              label: _translate('normal'),
            ),
            GaugeRange(
              startValue: 24.9,
              endValue: 29.9,
              color: Colors.yellow,
              label: _translate('overweight'),
            ),
            GaugeRange(
              startValue: 29.9,
              endValue: 34.9,
              color: Colors.orange,
              label: _translate('obesity1'),
            ),
            GaugeRange(
              startValue: 34.9,
              endValue: 39.9,
              color: Colors.red,
              label: _translate('obesity2'),
            ),
            GaugeRange(
              startValue: 40,
              endValue: 50,
              color: Colors.purple,
              label: _translate('obesity3'),
            ),
          ],
          pointers: <GaugePointer>[
            NeedlePointer(value: _bmiValue, enableAnimation: true),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Text(
                _bmiValue.toStringAsPrecision(4),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              positionFactor: 0.8,
              angle: 90,
            ),
          ],
        ),
      ],
    );
  }
}