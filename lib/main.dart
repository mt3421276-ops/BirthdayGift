import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const BirthdayGiftApp());
}

class BirthdayGiftApp extends StatelessWidget {
  const BirthdayGiftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'هدية لكِ ❤️',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const LockPage(),
    );
  }
}

// ============================================================
// شاشة القفل والعد التنازلي
// ============================================================

class LockPage extends StatefulWidget {
  const LockPage({super.key});

  @override
  State<LockPage> createState() => _LockPageState();
}

class _LockPageState extends State<LockPage> {
  // ==========================================================
  // موعد فتح الهدية
  // 26 أغسطس 2026 - الساعة 00:00
  // ==========================================================
  final DateTime unlockTime = DateTime(2026, 8, 26, 0, 0);

  Timer? timer;
  Duration remaining = Duration.zero;

  @override
  void initState() {
    super.initState();

    updateTimer();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => updateTimer(),
    );
  }

  void updateTimer() {
    final now = DateTime.now();

    if (now.isBefore(unlockTime)) {
      if (!mounted) return;

      setState(() {
        remaining = unlockTime.difference(now);
      });
    } else {
      if (!mounted) return;

      setState(() {
        remaining = Duration.zero;
      });

      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String twoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    final unlocked = remaining == Duration.zero;

    final days = remaining.inDays;
    final hours = remaining.inHours % 24;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF090817),
              Color(0xFF21122D),
              Color(0xFF3A172D),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedScale(
                    scale: unlocked ? 1.15 : 1.0,
                    duration: const Duration(milliseconds: 700),
                    child: Icon(
                      unlocked
                          ? Icons.lock_open_rounded
                          : Icons.lock_rounded,
                      size: 100,
                      color: const Color(0xFFFF719E),
                      shadows: const [
                        Shadow(
                          color: Color(0x99FF719E),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  Text(
                    unlocked
                        ? 'الهدية أصبحت جاهزة 🎁'
                        : 'هذه الهدية لكِ ❤️',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    unlocked
                        ? 'حان وقت فتحها...'
                        : 'لكنها مقفلة حتى 26 أغسطس الساعة 12:00 منتصف الليل',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontSize: 17,
                      height: 1.7,
                      color: Color(0xFFFFB8CD),
                    ),
                  ),

                  const SizedBox(height: 40),

                  if (!unlocked)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TimeBox(
                          value: twoDigits(days),
                          label: 'يوم',
                        ),
                        const TimeSeparator(),
                        TimeBox(
                          value: twoDigits(hours),
                          label: 'ساعة',
                        ),
                        const TimeSeparator(),
                        TimeBox(
                          value: twoDigits(minutes),
                          label: 'دقيقة',
                        ),
                        const TimeSeparator(),
                        TimeBox(
                          value: twoDigits(seconds),
                          label: 'ثانية',
                        ),
                      ],
                    ),

                  if (!unlocked) ...[
                    const SizedBox(height: 45),
                    const Text(
                      'اصبري قليلًا... هناك شيء جميل ينتظركِ 🌷',
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                  ],

                  if (unlocked) ...[
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 900),
                            pageBuilder: (_, animation, __) =>
                                const CelebrationPage(),
                            transitionsBuilder:
                                (_, animation, __, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF719E),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(220, 58),
                        elevation: 12,
                        shadowColor: const Color(0xFFFF719E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'افتحي هديتك 🎁',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// مرحلة الاحتفال
// ============================================================

class CelebrationPage extends StatefulWidget {
  const CelebrationPage({super.key});

  @override
  State<CelebrationPage> createState() => _CelebrationPageState();
}

class _CelebrationPageState extends State<CelebrationPage>
    with TickerProviderStateMixin {
  late AnimationController entranceController;
  late AnimationController balloonsController;
  late AnimationController confettiController;
  late AnimationController heartController;

  final AudioPlayer birthdayPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();

    balloonsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _playBirthdaySong();
  }

  Future<void> _playBirthdaySong() async {
    try {
      await birthdayPlayer.setReleaseMode(ReleaseMode.stop);
      await birthdayPlayer.setVolume(0.75);

      await birthdayPlayer.play(
        AssetSource('audio/happy_birthday.mp3'),
      );
    } catch (e) {
      debugPrint('Birthday music error: $e');
    }
  }

  Future<void> _openGift() async {
    // إيقاف Happy Birthday قبل تشغيل الرسالة والموسيقى التالية.
    await birthdayPlayer.stop();

    if (!mounted) return;

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 900),
        pageBuilder: (_, animation, __) => const GiftPage(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    entranceController.dispose();
    balloonsController.dispose();
    confettiController.dispose();
    heartController.dispose();
    birthdayPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE7EF),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFDCE8),
                  Color(0xFFFFEEF4),
                  Color(0xFFFFD2E1),
                ],
              ),
            ),
          ),

          Positioned.fill(
            child: AnimatedBuilder(
              animation: confettiController,
              builder: (_, __) {
                return CustomPaint(
                  painter: ConfettiPainter(
                    progress: confettiController.value,
                  ),
                );
              },
            ),
          ),

          Positioned.fill(
            child: AnimatedBuilder(
              animation: balloonsController,
              builder: (_, __) {
                return CustomPaint(
                  painter: BalloonPainter(
                    progress: balloonsController.value,
                  ),
                );
              },
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 35,
                ),
                child: FadeTransition(
                  opacity: CurvedAnimation(
                    parent: entranceController,
                    curve: Curves.easeIn,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      const Text(
                        '🎉',
                        style: TextStyle(fontSize: 60),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'كل عام وأنتِ بخير',
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: Color(0xFF6B1738),
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'يا أجمل شخص دخل حياتي ❤️',
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: Color(0xFFB52D5E),
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 35),

                      AnimatedBuilder(
                        animation: heartController,
                        builder: (_, __) {
                          final scale =
                              0.92 + heartController.value * 0.12;

                          return Transform.scale(
                            scale: scale,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.75),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF719E)
                                        .withOpacity(0.35),
                                    blurRadius: 35,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  '🎂',
                                  style: TextStyle(fontSize: 75),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 35),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.72),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  const Color(0xFFB52D5E).withOpacity(0.12),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Column(
                          children: [
                            Text(
                              '🎈  🎁  🎈',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 27),
                            ),
                            SizedBox(height: 18),
                            Text(
                              'اليوم مو يوم عادي...',
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: Color(0xFF6B1738),
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'اليوم هو اليوم الذي وُلدت فيه إنسانة أصبحت غالية جدًا على قلبي ❤️',
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: Color(0xFF7E5263),
                                fontSize: 17,
                                height: 1.8,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 35),

                      const Text(
                        '🎉  HAPPY BIRTHDAY  🎉',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFB52D5E),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),

                      const SizedBox(height: 35),

                      ElevatedButton(
                        onPressed: _openGift,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF719E),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(230, 60),
                          elevation: 10,
                          shadowColor: const Color(0xFFFF719E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'الهدية 🎁',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        'وهذه فقط البداية... ❤️',
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: Color(0xFF9B6A7B),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 15,
            left: 10,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF7B2748),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// صفحة الهدية والرسالة
// ============================================================

class GiftPage extends StatefulWidget {
  const GiftPage({super.key});

  @override
  State<GiftPage> createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage>
    with SingleTickerProviderStateMixin {
  final AudioPlayer voicePlayer = AudioPlayer();
  final AudioPlayer musicPlayer = AudioPlayer();

  late AnimationController giftController;

  StreamSubscription<void>? voiceCompleteSubscription;

  bool opening = false;
  bool voiceFinished = false;

  final String message = '''
رهف ❤️

بمناسبة أول عيد ميلاد لكِ وأنا معكِ، أريد أن أقدم لكِ هذه الكلمات النابعة من قلبي، وأقول لكِ أولًا:

كل عام وأنتِ بخير يا أجمل ما حدث لي. ❤️

أريد أن أقول لكِ شيئًا...

أنا لا أحبكِ فقط، ولا أعشقكِ فقط، لأن المرحلة التي وصلت إليها في حبكِ فاقت كل هذه الكلمات.

لقد أصبحتُ مدمنًا عليكِ، على وجودكِ، على صوتكِ، على تفاصيلكِ، وعلى كل شيء يخصكِ.

أتدرين شيئًا؟

حياتي من دونكِ تحتاج حياةً أخرى كي أصفها، لأن وجودكِ فيها أصبح شيئًا لا أستطيع تخيله بعيدًا عني.

وأتمنى من كل قلبي أن يأتي يوم أستطيع فيه أن أقول إنكِ أصبحتِ زوجتي، وأن تكوني لي ومن نصيبي، وأن نكمل حياتنا معًا. ❤️

لا أعرف ماذا سيحمل لنا المستقبل، لكنني أعرف شيئًا واحدًا...

أنني أحبكِ.

أحبكِ أكثر مما تستطيع هذه الكلمات أن تصف. ❤️

وكل عام وأنتِ معي، وكل عام وأنتِ أقرب إنسانة إلى قلبي.

أحبكِ يا رهف. ❤️
''';

  List<String> displayedWords = [];
  Timer? typingTimer;

  @override
  void initState() {
    super.initState();

    giftController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    voiceCompleteSubscription =
        voicePlayer.onPlayerComplete.listen((_) {
      _playGoldenBrown();
    });
  }

  Future<void> _openBox() async {
    if (opening) return;

    setState(() {
      opening = true;
    });

    await giftController.forward();
    await _playVoice();
  }

  Future<void> _playVoice() async {
    try {
      await voicePlayer.setReleaseMode(ReleaseMode.stop);
      await voicePlayer.setVolume(1.0);

      await voicePlayer.play(
        AssetSource('audio/voice_message.mp3'),
      );
    } catch (e) {
      debugPrint('Voice error: $e');
      await _playGoldenBrown();
    }
  }

  Future<void> _playGoldenBrown() async {
    if (!mounted) return;

    setState(() {
      voiceFinished = true;
    });

    try {
      await musicPlayer.setReleaseMode(ReleaseMode.loop);
      await musicPlayer.setVolume(0.45);

      await musicPlayer.play(
        AssetSource(
          'audio/dopuu_aurelia_EDMUNDS_-_Golden_Brown_-_Slowed_Loop_(mp3.pm).mp3',
        ),
      );
    } catch (e) {
      debugPrint('Golden Brown error: $e');
    }

    _startTyping();
  }

  void _startTyping() {
    typingTimer?.cancel();

    final words = message
        .replaceAll('\n', ' \n ')
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    displayedWords = [];

    int index = 0;

    typingTimer = Timer.periodic(
      const Duration(milliseconds: 230),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (index >= words.length) {
          timer.cancel();
          return;
        }

        setState(() {
          displayedWords.add(words[index]);
        });

        index++;
      },
    );
  }

  @override
  void dispose() {
    typingTimer?.cancel();
    voiceCompleteSubscription?.cancel();

    giftController.dispose();
    voicePlayer.dispose();
    musicPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFE4ED),
              Color(0xFFFFF5F8),
              Color(0xFFFFD4E2),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  const Text(
                    '🎁',
                    style: TextStyle(fontSize: 32),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    voiceFinished
                        ? 'من قلبي إليكِ ❤️'
                        : 'هذه الهدية لكِ وحدكِ',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: Color(0xFF6B1738),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    voiceFinished
                        ? 'اقرئيها بهدوء... ❤️'
                        : 'اضغطي على العلبة عندما تكونين مستعدة 🎀',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: Color(0xFF9B5A70),
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(height: 45),

                  if (!voiceFinished)
                    GestureDetector(
                      onTap: _openBox,
                      child: AnimatedBuilder(
                        animation: giftController,
                        builder: (_, __) {
                          final scale =
                              1.0 + giftController.value * 0.12;

                          return Transform.scale(
                            scale: scale,
                            child: Container(
                              width: 230,
                              height: 230,
                              decoration: BoxDecoration(
                                color:
                                    Colors.white.withOpacity(0.75),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color(0xFFFF719E)
                                            .withOpacity(0.30),
                                    blurRadius: 40,
                                    spreadRadius: 8,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: AnimatedSwitcher(
                                  duration:
                                      const Duration(milliseconds: 500),
                                  child: Text(
                                    opening ? '🎀✨' : '🎁',
                                    key: ValueKey(opening),
                                    style: const TextStyle(
                                      fontSize: 110,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  if (!opening && !voiceFinished)
                    const Padding(
                      padding: EdgeInsets.only(top: 35),
                      child: Text(
                        'اضغطي على الهدية 🎁',
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: Color(0xFFB52D5E),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  if (opening && !voiceFinished)
                    const Padding(
                      padding: EdgeInsets.only(top: 35),
                      child: Column(
                        children: [
                          CircularProgressIndicator(
                            color: Color(0xFFFF719E),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'استمعي... ❤️',
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: Color(0xFFB52D5E),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (voiceFinished) ...[
                    const SizedBox(height: 25),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.82),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFFB52D5E).withOpacity(0.12),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              for (
                                int i = 0;
                                i < displayedWords.length;
                                i++
                              )
                                TextSpan(
                                  text:
                                      '${displayedWords[i]} ',
                                  style: const TextStyle(
                                    color: Color(0xFF6B1738),
                                    fontSize: 19,
                                    height: 2.0,
                                  ),
                                ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 35),

                  if (voiceFinished)
                    const Text(
                      '❤️',
                      style: TextStyle(fontSize: 35),
                    ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'رجوع',
                      style: TextStyle(
                        color: Color(0xFF9B5A70),
                      ),
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

// ============================================================
// البالونات
// ============================================================

class BalloonPainter extends CustomPainter {
  final double progress;

  BalloonPainter({
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42);

    for (int i = 0; i < 12; i++) {
      final x =
          20 + random.nextDouble() * (size.width - 40);

      final startY =
          size.height + random.nextDouble() * 300;

      final travel = size.height + 400;

      final y =
          startY -
          ((progress + i * 0.08) % 1.0) * travel;

      final radius =
          22 + random.nextDouble() * 10;

      final colors = [
        const Color(0xFFFF719E),
        const Color(0xFFFFB4C9),
        const Color(0xFFFFD166),
        const Color(0xFFB8E1FF),
        const Color(0xFFD8B4FE),
      ];

      final paint = Paint()
        ..color =
            colors[i % colors.length].withOpacity(0.85);

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x, y),
          width: radius * 1.5,
          height: radius * 1.9,
        ),
        paint,
      );

      final stringPaint = Paint()
        ..color =
            const Color(0xFF8C6573).withOpacity(0.45)
        ..strokeWidth = 1;

      canvas.drawLine(
        Offset(x, y + radius * 0.9),
        Offset(x, y + radius * 3.5),
        stringPaint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant BalloonPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress;
  }
}

// ============================================================
// الكونفيتي
// ============================================================

class ConfettiPainter extends CustomPainter {
  final double progress;

  ConfettiPainter({
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(91);

    final colors = [
      const Color(0xFFFF719E),
      const Color(0xFFFFD166),
      const Color(0xFF7DD3FC),
      const Color(0xFFC4B5FD),
      const Color(0xFF86EFAC),
    ];

    for (int i = 0; i < 70; i++) {
      final x = random.nextDouble() * size.width;

      final baseY =
          random.nextDouble() * size.height;

      final falling =
          (baseY +
                  progress * size.height * 1.4 +
                  i * 13) %
              size.height;

      final w =
          3 + random.nextDouble() * 5;

      final h =
          6 + random.nextDouble() * 10;

      final paint = Paint()
        ..color =
            colors[i % colors.length].withOpacity(0.75);

      canvas.save();

      canvas.translate(x, falling);

      canvas.rotate(
        progress * pi * 2 + i,
      );

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: w,
          height: h,
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(
    covariant ConfettiPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress;
  }
}

// ============================================================
// مربعات العد
// ============================================================

class TimeBox extends StatelessWidget {
  final String value;
  final String label;

  const TimeBox({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62,
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              const Color(0xFFFF719E).withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFFFFB8CD),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// فاصل العد
// ============================================================

class TimeSeparator extends StatelessWidget {
  const TimeSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 22,
          color: Color(0xFFFF719E),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
