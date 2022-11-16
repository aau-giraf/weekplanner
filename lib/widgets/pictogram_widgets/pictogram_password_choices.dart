import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/di.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:weekplanner/widgets/pictogram_image.dart';
import 'package:api_client/api/api.dart';

class PictogramChoices extends StatefulWidget {
  ///Widget with the possible pictograms in the code and the currently picked
  /// pictograms in the code.
  const PictogramChoices({
    Key key,
  }) : super(key: key);

  @override
  _PictogramChoiceState createState() => _PictogramChoiceState();
}

/// The pictograms to choose between for the code.
/// If these are changed every previously made passwords will become unusable
const List<int> CHOSENPICTOGRAMS = <int>[1,2,3,4,5,6,7,8,9,10];

class _PictogramChoiceState extends State<PictogramChoices> {
  /// Api to use for pictogram calls
  Api _api;
  /// List of currently chosen pictograms for the code
  List<PictogramModel> _inputCode;
  /// Stream of usable pictograms
  Stream<List<PictogramModel>> _pictogramChoices;

  @override
  void initState(){
    _inputCode = List<PictogramModel>.filled(4, null);
    _api = di.getDependency<Api>();
    _pictogramChoices = getStream();
    super.initState();
  }

  ///Called when one of the possible pictograms are pressed
  ///and adds it to the code
  void addToPass(PictogramModel pictogram){
    final int index = _inputCode.indexOf(null);
    if (index != -1){
      _inputCode[index] = pictogram;
    }
    //Reloads the widget with the new input
    setState(() {

    });
  }

  ///Called when a pictogram is pressed in the code and removes the pressed icon
  void removeFromPass(int index){
    _inputCode[index] = null;
    //Reloads the widget with the new code
    setState(() {

    });
  }

  ///
  Stream<List<PictogramModel>> getStream() async* {
    final List<PictogramModel> list = List<PictogramModel>.filled(
        CHOSENPICTOGRAMS.length, null);
    yield list;
    for (int i = 0; i < list.length; i++){
      final int index = CHOSENPICTOGRAMS[i];
      await for (final PictogramModel model in _api.pictogram.get(index)){
        list[i] = model;
        yield list;
      }
    }
  }

  List<Widget> passwordList() {
    final List<Widget> password = List<Widget>.filled(4, null);
    for (int i = 0; i < 4; i++){
      final PictogramModel pictogram = _inputCode[i];
      Widget widget;
      if (pictogram == null){
        widget = Container(
          width: 100,
          height: 100,
          color: Colors.red,
        );
      } else{
        widget = PictogramImage(
            pictogram: pictogram,
            onPressed: () => removeFromPass(i)
        );
      }
      password[i] = widget;
    }
    return password;
  }

  @override
  Widget build (BuildContext context) {
    return Column(
        children: <Widget>[
          //First column element
          Container(
              width: 500,
              height: 500,
              child: StreamBuilder<List<PictogramModel>>(
                  stream: _pictogramChoices,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<PictogramModel>> snapshot) {
                    if (snapshot.hasError){
                      print(snapshot.error);
                      return const Text(
                          'Fejl i forbindelse med piktogrammer.');
                    }
                    else if (snapshot.hasData){
                      return Expanded(
                          child:
                          GridView.count(
                              crossAxisCount: 5,
                              children:
                              snapshot.data.map<Widget>(
                                      (PictogramModel pictogram) {
                                if (pictogram == null) {
                                  return Container(
                                    height: 80,
                                    child: const Center(
                                        child: CircularProgressIndicator()
                                    ),
                                  );
                                } else{
                                  return PictogramImage(
                                      pictogram: pictogram,
                                      onPressed: () => addToPass(pictogram)
                                  );
                                }
                              }).toList()
                          )
                      );

                    }
                    else{
                      return const Text('Fejl');
                    }

                  })
          ),
          //Second column element


          Container(
            width: 500,
            height: 500,
            child: GridView.count(
                crossAxisCount: 4,
                children: passwordList()
            )
          ),
        ]);

  }


}