import 'package:flutter/material.dart';

void main() {
  runApp(const ConverterApp());
}

class ConverterApp extends StatelessWidget {
  const ConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: ConverterScreen(),
    );
  }
}

class ConverterScreen extends StatefulWidget {
  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  String mode = "currency";
  String fromUnit = "MAD";
  String toUnit = "EUR";
  double value = 0;
  String result = "";

  final Map<String, double> currencyRates = {
    "MAD": 1,
    "EUR": 0.092,
    "USD": 0.10,
  };

  List<String> get units {
    if (mode == "currency") return ["MAD", "EUR", "USD"];
    if (mode == "temperature") return ["Celsius", "Fahrenheit"];
    return ["m", "km", "mi"];
  }

  void convert() {
    double out = 0;

    if (mode == "currency") {
      double valueInMAD = value / currencyRates[fromUnit]!;
      out = valueInMAD * currencyRates[toUnit]!;
    } else if (mode == "temperature") {
      if (fromUnit == "Celsius" && toUnit == "Fahrenheit") {
        out = value * 9 / 5 + 32;
      } else if (fromUnit == "Fahrenheit" && toUnit == "Celsius") {
        out = (value - 32) * 5 / 9;
      } else {
        out = value;
      }
    } else if (mode == "distance") {
      const toMeters = {"m": 1.0, "km": 1000.0, "mi": 1609.344};
      double inMeters = value * toMeters[fromUnit]!;
      out = inMeters / toMeters[toUnit]!;
    }

    setState(() {
      result = out.toStringAsFixed(3);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue.shade600,
        title: const Text(
          "Convertisseur",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // CARD MODE
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: mode,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: "currency", child: Text("💰 Devise")),
                    DropdownMenuItem(value: "temperature", child: Text("🌡 Température")),
                    DropdownMenuItem(value: "distance", child: Text("📏 Distance")),
                  ],
                  onChanged: (v) {
                    setState(() {
                      mode = v!;
                      fromUnit = units[0];
                      toUnit = units[1];
                      value = 0;
                      result = "";
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // INPUT FIELD
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Valeur à convertir",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.edit),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onChanged: (val) {
                value = double.tryParse(val) ?? 0;
              },
            ),

            const SizedBox(height: 20),

            // SELECT UNITS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButton<String>(
                        value: fromUnit,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                        onChanged: (v) => setState(() => fromUnit = v!),
                      ),
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(Icons.swap_horiz, size: 30),
                ),

                Expanded(
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButton<String>(
                        value: toUnit,
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                        onChanged: (v) => setState(() => toUnit = v!),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: convert,
                child: const Text(
                  "Convertir",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // RESULT CARD
            if (result.isNotEmpty)
              Card(
                elevation: 4,
                color: Colors.blue.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Résultat : $result",
                    style: const TextStyle(
                      fontSize: 24,
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
}


