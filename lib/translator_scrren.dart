import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;

  String _wordsSpoken = "";

  double _confidenceLevel = 0;

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _confidenceLevel = 0;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
      _confidenceLevel = result.confidence;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'Speech Text',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                _speechToText.isListening
                    ? "Listening..."
                    : _speechEnabled
                        ? "Tap the Microphone to Start Listening..."
                        : "Speech Not Available.",
                style: const TextStyle(fontSize: 20),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _wordsSpoken,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w300),
                ),
              ),
            ),
            if (_speechToText.isNotListening && _confidenceLevel > 0)
              const Padding(padding: EdgeInsets.only(bottom: 100)),
            Text(
              "Confidence: ${(_confidenceLevel * 100).toStringAsFixed(1)}%",
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w200,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _speechToText.isListening ? _stopListening : _startListening,
        tooltip: 'Listen',
        backgroundColor: Colors.red,
        child: Icon(
          _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
          color: Colors.white,
        ),
      ),
    );
  }
}
