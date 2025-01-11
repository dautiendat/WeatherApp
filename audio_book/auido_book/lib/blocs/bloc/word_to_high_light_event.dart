part of 'word_to_high_light_bloc.dart';

@immutable
sealed class WordToHighLightEvent {}

class WordHighLight extends WordToHighLightEvent{
  // final int startIndex;
  // final int endIndex;

  // WordHighLight(this.startIndex,this.endIndex);
  final String word;
  WordHighLight(this.word);

  // final List<Map<String,int>> listIndex;
  // WordHighLight(this.listIndex);
}
