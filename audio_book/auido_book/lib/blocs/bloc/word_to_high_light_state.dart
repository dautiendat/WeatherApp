part of 'word_to_high_light_bloc.dart';

@immutable
sealed class WordToHighLightState {}

final class WordToHighLightInitial extends WordToHighLightState {}
final class WordToHighLightLoading extends WordToHighLightState {}
final class WordToHighLightFailure extends WordToHighLightState {}
final class WordToHighLightSuccess extends WordToHighLightState {
  // final int startIndex;
  // final int endIndex;
  // WordToHighLightSuccess(this.startIndex,this.endIndex);
  final String word;
  WordToHighLightSuccess(this.word);

  //  final List<Map<String,int>> listIndex;
  // WordToHighLightSuccess(this.listIndex);
}
