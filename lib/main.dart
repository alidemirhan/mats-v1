import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MathStarsApp());
}

class MathStarsApp extends StatelessWidget {
  const MathStarsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Matematik Oyunu',
      theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true),
      home: const MainMenuPage(),
    );
  }
}

// --- RENKLİ VE EĞLENCELİ ANA GİRİŞ MENÜSÜ ---
class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  Widget menuButton({
    required BuildContext context,
    required String title,
    required String emoji,
    required Color startColor,
    required Color endColor,
    required Widget targetPage,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Container(
        width: 290,
        height: 85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: endColor.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => targetPage),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 36)),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(1, 2),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade50,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned(
              top: 40,
              left: 30,
              child: Text("🎈", style: TextStyle(fontSize: 40)),
            ),
            const Positioned(
              top: 120,
              right: 40,
              child: Text("🚀", style: TextStyle(fontSize: 45)),
            ),
            const Positioned(
              bottom: 50,
              left: 40,
              child: Text("🎨", style: TextStyle(fontSize: 40)),
            ),
            const Positioned(
              bottom: 150,
              right: 30,
              child: Text("🧩", style: TextStyle(fontSize: 45)),
            ),

            Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: 420,
                  height: 850,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("⭐ ", style: TextStyle(fontSize: 30)),
                              Text("🌟 ", style: TextStyle(fontSize: 40)),
                              Text("⭐", style: TextStyle(fontSize: 30)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "MATEMATİK\nOYUNU",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 46,
                              fontWeight: FontWeight.w900,
                              color: Colors.indigo,
                              height: 1.2,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 70),

                      menuButton(
                        context: context,
                        title: "TOPLAMA",
                        emoji: "➕",
                        startColor: Colors.green.shade400,
                        endColor: Colors.green.shade800,
                        targetPage: const GamePage(isAddition: true),
                      ),

                      menuButton(
                        context: context,
                        title: "ÇIKARMA",
                        emoji: "➖",
                        startColor: Colors.orange.shade400,
                        endColor: Colors.deepOrange.shade700,
                        targetPage: const GamePage(isAddition: false),
                      ),
                    ],
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

// --- OYUN ALANI (KUSURSUZ MİZANPAJ) ---
class GamePage extends StatefulWidget {
  final bool isAddition;

  const GamePage({super.key, required this.isAddition});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Random random = Random();

  int number1 = 0;
  int number2 = 0;
  int score = 0;
  int questionCount = 0;
  String answer = "";

  int lastNumber1 = -1;
  int lastNumber2 = -1;

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  void generateQuestion() {
    if (questionCount >= 30) {
      showFinalDialog();
      return;
    }

    setState(() {
      questionCount++;
      int nextNum1 = 0;
      int nextNum2 = 0;

      do {
        if (questionCount <= 10) {
          nextNum1 = random.nextInt(10);
          nextNum2 = random.nextInt(10);
        } else {
          nextNum1 = 10 + random.nextInt(90);
          nextNum2 = random.nextInt(10);
        }

        if (!widget.isAddition && questionCount <= 10 && nextNum1 < nextNum2) {
          int temp = nextNum1;
          nextNum1 = nextNum2;
          nextNum2 = temp;
        }
      } while (nextNum1 == lastNumber1 && nextNum2 == lastNumber2);

      number1 = nextNum1;
      number2 = nextNum2;
      lastNumber1 = number1;
      lastNumber2 = number2;

      answer = "";
    });
  }

  void addDigit(String digit) {
    setState(() {
      if (answer.length < 3) {
        answer += digit;
      }
    });
  }

  void clearAnswer() {
    setState(() {
      answer = "";
    });
  }

  void checkAnswer() {
    if (answer.isEmpty) return;

    int? userAnswer = int.tryParse(answer);
    int top = max(number1, number2);
    int bottom = min(number1, number2);

    int correctAnswer = widget.isAddition ? (top + bottom) : (top - bottom);

    if (userAnswer == correctAnswer) {
      setState(() {
        score += 10;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text("⭐", style: TextStyle(fontSize: 26)),
                  Text("⭐", style: TextStyle(fontSize: 26)),
                  Text("⭐", style: TextStyle(fontSize: 26)),
                  Text("⭐", style: TextStyle(fontSize: 26)),
                  Text("⭐", style: TextStyle(fontSize: 26)),
                ],
              ),
              SizedBox(height: 15),
              Text(
                "TEBRİKLER!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        Navigator.pop(context);
        generateQuestion();
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("❌", style: TextStyle(fontSize: 60)),
              SizedBox(height: 10),
              Text(
                "Yanlış",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 5),
              Text("Tekrar Dene", style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ).then((_) {
        clearAnswer();
      });
    }
  }

  void showFinalDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.yellow.shade100,
        title: const Text(
          "🏆 OYUN BİTTİ! 🏆",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("🎉 🎉 🎉", style: TextStyle(fontSize: 40)),
            const SizedBox(height: 15),
            const Text(
              "Harika bir matematik şampiyonusun!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 15),
            Text(
              "Toplam Puanın: $score",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  score = 0;
                  questionCount = 0;
                  lastNumber1 = -1;
                  lastNumber2 = -1;
                });
                generateQuestion();
              },
              child: const Text(
                "Yeniden Başla",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget numberButton(String text) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: SizedBox(
        width: 90,
        height: 70,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade100,
            foregroundColor: Colors.blue.shade900,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: () => addDigit(text),
          child: Text(
            text,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget actionButton(
    String text,
    VoidCallback onPressed,
    Color bgColor,
    Color textColor,
  ) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: SizedBox(
        width: 90,
        height: 70,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int top = max(number1, number2);
    int bottom = min(number1, number2);
    String operationSymbol = widget.isAddition ? "+" : "-";

    // Tüm rakamların ve harflerin genişliklerini eşitlemek için standart monospace kullanıyoruz.
    // Bu sayede 1 ve 6 yan yana geldiğinde kayma yapmaz.
    const TextStyle numStyle = TextStyle(
      fontSize: 65,
      fontWeight: FontWeight.bold,
      color: Colors.indigo,
      fontFamily: 'monospace',
    );

    return Scaffold(
      backgroundColor: Colors.yellow.shade50,
      body: SafeArea(
        child: Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: 420,
              height: 850,
              child: Column(
                children: [
                  const SizedBox(height: 15),

                  // Üst Durum Çubuğu
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.indigo,
                            size: 28,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            "📝 Soru: $questionCount / 30",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                        Text(
                          "⭐ Puan: $score",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // 📌 EKRANIN TAM ORTASINDA DURAN MATEMATİK BLOĞU
                  Center(
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .end, // İçindeki her şeyi sağa (birler basamağına) yaslar
                        children: [
                          // Üstteki Sayı (Örn: 26 veya 3)
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Text("$top", style: numStyle),
                          ),

                          // Alttaki Sayı ve İşlem İşareti Satırı
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // İşlem İşareti sol tarafta doğal sınırında kalır
                              Text(
                                operationSymbol,
                                style: const TextStyle(
                                  fontSize: 55,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                              const SizedBox(
                                width: 35,
                              ), // Sayı ile artı işareti arasındaki ideal boşluk
                              // Alttaki Sayı
                              Text("$bottom", style: numStyle),
                              const Padding(padding: EdgeInsets.only(right: 5)),
                            ],
                          ),

                          // Matematik Çizgisi (Genişliğini üstteki elemanlara göre otomatik ayarlar)
                          const Divider(
                            color: Colors.indigo,
                            thickness: 4.5,
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Sonuç Giriş Kutusu (İşlem bloğunun tam altında, merkezde dengeli durur)
                  Center(
                    child: Container(
                      width: 160,
                      height: 75,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 3, color: Colors.indigo),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        answer,
                        style: const TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  // Klavye Bölümü
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            numberButton("1"),
                            numberButton("2"),
                            numberButton("3"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            numberButton("4"),
                            numberButton("5"),
                            numberButton("6"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            numberButton("7"),
                            numberButton("8"),
                            numberButton("9"),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            actionButton(
                              "C",
                              clearAnswer,
                              Colors.orange.shade200,
                              Colors.orange.shade900,
                            ),
                            numberButton("0"),
                            actionButton(
                              "✓",
                              checkAnswer,
                              Colors.green.shade200,
                              Colors.green.shade900,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
