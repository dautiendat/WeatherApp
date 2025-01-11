import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'word_to_high_light_event.dart';
part 'word_to_high_light_state.dart';

class WordToHighLightBloc extends Bloc<WordHighLight, WordToHighLightState> {
  WordToHighLightBloc() : super(WordToHighLightInitial()) {
    on<WordHighLight>((event, emit) async{
     await _getIndexToHighLight(event.word, emit);
    });
  }
  _getIndexToHighLight(String text,Emitter emit) async{
    WordToHighLightLoading();
    try {
      //int end = await _getEndIndex(startIndex, endIndex);
      emit(WordToHighLightSuccess(text));
    } catch (e) {
      WordToHighLightFailure();
    }
  }

  Future<int> _getEndIndex(int startIndex,int endIndex)async{
    int index = startIndex + (endIndex);
    return index;
  }
 
}
