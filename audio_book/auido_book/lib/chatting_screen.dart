import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:auido_book/data_highlight.dart';
import 'package:auido_book/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_highlighted_text/flutter_highlighted_text.dart';

import 'blocs/bloc/word_to_high_light_bloc.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({super.key});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = true;
  bool isOverride = true;
  final String audioUrl = 'audios/ouput.wav';
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  List<String> textSplitted = [];
  final String wordToFormat = 'Việt Nam';
  final String wordToFormat2 = 'Hoa Kỳ';
  List<Map<String, dynamic>> wordPositions = [];
  List<MyDialog> dialogs = [
    MyDialog(
        speaker: "James",
        text: "Chào Lan! Mình là James, đến từ Hoa Kỳ. Rất vui được gặp bạn.",
        timeStart: 75),
    MyDialog(
        speaker: "Lan",
        text:
            "Chào James! Mình là Lan, đến từ Việt Nam. Rất vui được làm quen với bạn.",
        timeStart: 5337),
    MyDialog(speaker: "James", text: "Bạn làm nghề gì vậy, Lan?", timeStart: 12262),
    MyDialog(
        speaker: "Lan",
        text: "Mình là cô giáo dạy ngoại ngữ. Còn bạn?",
        timeStart: 14725),
    MyDialog(speaker: "James", text: "Mình là kỹ sư hàng không.", timeStart: 18800),
    MyDialog(
        speaker: "Lan",
        text: "Nghe thú vị quá! Bạn đến Việt Nam lâu chưa?",
        timeStart: 20750),
    MyDialog(
        speaker: "James", text: "Mình mới đến đây được vài ngày.", timeStart: 24962),
    MyDialog(speaker: "Lan", text: "Hy vọng bạn sẽ thích Việt Nam!", timeStart: 26987),
    MyDialog(speaker: "James", text: "Cảm ơn Lan!", timeStart: 29500),
  ];

  void getIndexToHighLight() {
    for (var element in myTimestamp()) {
      if(element.startTime <= _position.inMilliseconds 
        && _position.inMilliseconds < element.startTime+element.duration){
        context.read<WordToHighLightBloc>().add(WordHighLight(element.text));
      }
    }
  }

  Future _setupAudioPlayer() async {
    audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _position = position;
      });
    });
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });

    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.playing) {
        setState(() {
          isPlaying = true;
        });
      } else if (state == PlayerState.paused) {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  bool checkWordToFormat(String text, String word){
    bool check = word.contains(text) ? true : false;
    return check;
  }
  List<Map<String, dynamic>> textFormatted(){
    final List<Map<String, dynamic>> format = [
    {
      "position": [32, "Lan", 8],
      "style": {"color": "#FF0000", "bold": true, "italic": false, "underline": false},
      "hyperlink": {"url": "https://en.wikipedia.org/wiki/Vietnam"}
    },
    {
      "position": [32, "Bạn làm nghề gì vậy", 6],
      "style": {"color": "#5E2736", "bold": true, "italic": true, "underline": false},
      "hyperlink": {"url": "https://en.wikipedia.org/wiki/United_States"}
    },
    ];
    return format;
  }
  int hexToColor(String hexString) {
  hexString = hexString.toUpperCase().replaceAll("#", "");
  if (hexString.length == 6) {
    hexString = "0xFF$hexString"; 
  }
  return int.parse(hexString);
}
  TextStyle buildTextFormatted(bool check){
    List<Map<String, dynamic>> fromFormat = textFormatted();
    TextStyle style1;
    TextStyle style2 = TextStyle();
    int i = 0;
      final element = fromFormat[i];
      String color = element["style"]['color'];
      bool isBold = element["style"]['bold'];
      bool isItalic = element["style"]['italic'];
      bool isUnderline = element["style"]['underline'];
      style1 = TextStyle(
        color: Color(hexToColor(color)),
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal, 
        fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        decoration: isUnderline ? TextDecoration.underline : TextDecoration.none
      );
    
      final element2 = fromFormat[++i];
      String color2 = element2["style"]['color'];
      bool isBold2 = element2["style"]['bold'];
      bool isItalic2 = element2["style"]['italic'];
      bool isUnderline2 = element2["style"]['underline'];
      style2 = TextStyle(
        color: Color(hexToColor(color2)),
        fontWeight: isBold2 ? FontWeight.bold : FontWeight.normal, 
        fontStyle: isItalic2 ? FontStyle.italic : FontStyle.normal,
        decoration: isUnderline2 ? TextDecoration.underline : TextDecoration.none
      );
    if(check) {
      return style1;
    } else {
      return style2;
    }
  }
  void _toggleAudio() async {
    isPlaying ? await audioPlayer.pause() : await audioPlayer.resume();
  }

  void _playAudio() {
    audioPlayer.play(AssetSource(audioUrl));
  }

  @override
  void initState() {
    _setupAudioPlayer();
    _playAudio();
    
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getIndexToHighLight();
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child:  _position.inMilliseconds < 5337 ?
                   Image.asset(
                    'assets/images/james-say-hello-to-lan.jpg',
                  )
                  : Image.asset(
                    'assets/images/lan-say-hello-to-james.jpg',
                  )
                ),
                GestureDetector(
                  onTap: _toggleAudio,
                  child: SizedBox(
                      width: 54,
                      height: 54,
                      child: isPlaying
                          ? Image.asset('assets/images/icon-play.png')
                          : Image.asset('assets/images/icon-pause.png')),
                ),
              ],
            ),
            Slider(
              value: _position.inMilliseconds.toDouble(),
              max: _duration.inMilliseconds.toDouble(),
              activeColor: Colors.lightBlueAccent,
              onChanged: (value) async {
                await audioPlayer.seek(Duration(milliseconds: value.toInt()));
              },
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: dialogs.length,
                    itemBuilder: (context, index) {
                      final dia=dialogs[index];
                      if (dialogs[index].speaker == 'James') {
                        return BlocBuilder<WordToHighLightBloc,
                            WordToHighLightState>(builder: (contxt, state) {
                          if (state is WordToHighLightSuccess) {
                            return ChatBubble(
                                clipper: ChatBubbleClipper9(
                                    type: BubbleType.receiverBubble),
                                backGroundColor:
                                    Colors.lightBlueAccent.shade200,
                                    child: GestureDetector(
                                      onTap: ()async {
                                      await audioPlayer.seek(Duration(milliseconds: dia.timeStart));
                                  },
                                  child: HighlightedText(
                                    dia.text, 
                                    patterns: [wordToFormat2],
                                    highLightStyle: buildTextFormatted(false),
                                    onTap: (pattern) {
                                      List<Map<String, dynamic>> te =textFormatted();
                                          String url = te[1]["hyperlink"]["url"];
                                          showDialog(
                                            context: context, 
                                            builder: (context) {
                                              return AlertDialog(
                                                content: SizedBox(
                                                  width: 100,
                                                  height: 150,
                                                  child: Center(
                                                    child: Text(
                                                      url,
                                                      style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                    });
                                    },
                                  ),
                                  ),
                                );
                          } else{
                            return Center(child: CircularProgressIndicator(),);
                          }
                        });
                      }else {
                        return BlocBuilder<WordToHighLightBloc, WordToHighLightState>(
                          builder: (contxt2, state) {
                            if(state is WordToHighLightSuccess){
                              return ChatBubble(
                                clipper: ChatBubbleClipper9(
                                    type: BubbleType.sendBubble),
                                alignment: Alignment.topRight,
                                backGroundColor: Colors.grey[200],
                                child: GestureDetector(
                                  onTap: () async{
                                    await audioPlayer.seek(Duration(milliseconds: dia.timeStart));
                                  },
                                  child:HighlightedText(
                                    dia.text, 
                                    patterns: [wordToFormat],
                                    style: TextStyle(
                                      color: Colors.black
                                    ),
                                    highLightStyle: buildTextFormatted(true),
                                    onTap: (pattern) {
                                      List<Map<String, dynamic>> te =textFormatted();
                                          String url = te[0]["hyperlink"]["url"];
                                          showDialog(
                                            context: context, 
                                            builder: (context) {
                                              return AlertDialog(
                                                content: SizedBox(
                                                  width: 100,
                                                  height: 150,
                                                  child: Center(
                                                    child: Text(
                                                      url,
                                                      style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                    });
                                    },
                                  ),
                                )
                            );
                            }else{
                              return Center(child: CircularProgressIndicator(),);
                            }
                            
                          },
                        );
                      }
                    })
                ),
          ],
        ),
      ),
    ));
  }
}
