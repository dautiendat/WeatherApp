import 'package:auido_book/data_highlight.dart';

void getWordPositions(String text) {
List<Map<String, int>> wordPositions = [];
List<Map<String, int>> wordPositions2 = [];
  
  // Biểu thức chính quy để tìm tất cả các từ và dấu câu (.), (,), (!), ...
  RegExp regex = RegExp(r'\S+|[.,!?;]'); // Tìm các từ và dấu câu như .,!,?
  RegExp regex2 = RegExp(r'[.,!?;:]'); // Tìm các từ và dấu câu như .,!,?
  
  Iterable<Match> matches = regex.allMatches(text);
  Iterable<Match> matches2 = regex2.allMatches(text);
  for (Match match in matches) {
    wordPositions.add({
      'startIndex': match.start,  // Vị trí bắt đầu
      'length': match.end - match.start,      // Vị trí kết thúc (sau từ)
    });
    
    print(text.substring(match.start, match.end),);
  }
  for (Match match in matches2) {
    wordPositions2.add({
      'startIndex': match.start,  // Vị trí bắt đầu
      'length': match.end - match.start,      // Vị trí kết thúc (sau từ)
    });
    print(text.substring(match.start, match.end),);
  }
  print('==========> $wordPositions');
  print('==========> $wordPositions2');
}
void main(List<String> args) {
  for (var i = 0; i < mapDialogs.length; i++) {
     getWordPositions(mapDialogs[i]['text']);
  }
  
}