import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/di.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:weekplanner/widgets/pictogram_image.dart';
import 'package:api_client/api/api.dart';

import 'giraf_notify_dialog.dart';

///Widget to show possible pictograms for pictogram password
///and the currently input pictograms
class PictogramChoices extends StatefulWidget {
  ///Widget with the possible pictograms in the code and the currently picked
  /// pictograms in the code.
  // const PictogramChoices({
  //   Key key,
  //   @required this.api,
  // }) : super(key: key);

  const PictogramChoices(this.api);

  final Api api;
  @override
  _PictogramChoiceState createState() => _PictogramChoiceState(api);
}

/// The pictograms to choose between for the code.
/// If these are changed all previously made passwords will become unusable
const List<int> CHOSENPICTOGRAMS = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

/// The maximum width that is shared by both gridviews
const double MAXWIDTH = 500;

class _PictogramChoiceState extends State<PictogramChoices> {
  _PictogramChoiceState(this._api);
  /// Api to use for pictogram calls
  Api _api;
  /// List of currently chosen pictograms for the code
  List<PictogramModel> _inputCode;

  /// Stream of usable pictograms
  Stream<List<PictogramModel>> _pictogramChoices;

  @override
  void initState() {
    _inputCode = List<PictogramModel>.filled(4, null);
    //_api = di.getDependency<Api>();
    _pictogramChoices = getStream();
    super.initState();
  }

  ///Called when one of the possible pictograms are pressed
  ///and adds it to the code
  void addToPass(PictogramModel pictogram) {
    final int index = _inputCode.indexOf(null);
    if (index != -1) {
      _inputCode[index] = pictogram;
    }
    //Reloads the widget with the new input
    setState(() {});
  }

  ///Called when a pictogram is pressed in the code and removes the pressed icon
  void removeFromPass(int index) {
    _inputCode[index] = null;
    //Reloads the widget with the new code
    setState(() {});
  }

  ///
  Stream<List<PictogramModel>> getStream() async* {
    final List<PictogramModel> list =
        List<PictogramModel>.filled(CHOSENPICTOGRAMS.length, null);
    yield list;
    try{
      for (int i = 0; i < list.length; i++) {
        final int index = CHOSENPICTOGRAMS[i];
        await for (final PictogramModel model in _api.pictogram.get(index)) {
          list[i] = model;
          yield list;
        }
      }
    }catch(e){
      showErrorMessage(e, context);
    }
  }

  void showErrorMessage(Object error, BuildContext context) {
    showDialog<Center>(

      /// exception handler to handle web_api exceptions
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return const GirafNotifyDialog(
              title: 'Fejl',
              description: 'Fejl i forbindelse med at vise piktogrammer',
              key: Key('ErrorMessageDialog'));
        });
  }

  List<Widget> passwordList() {
    final List<Widget> password = List<Widget>.filled(4, null);
    for (int i = 0; i < 4; i++) {
      final PictogramModel pictogram = _inputCode[i];
      Widget widget;
      if (pictogram == null) {
        widget = Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFFe0dede),
          ),
        );
      } else {
        widget = PictogramImage(
            pictogram: pictogram, onPressed: () => removeFromPass(i));
      }
      password[i] = widget;
    }
    return password;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      // Grid view with available pictograms
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              constraints: const BoxConstraints(
                  maxHeight: double.infinity, maxWidth: MAXWIDTH),
              child: StreamBuilder<List<PictogramModel>>(
                  stream: _pictogramChoices,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<PictogramModel>> snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return const Text('Fejl i forbindelse med piktogrammer.');
                    } else if (snapshot.hasData) {
                      return GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 5,
                          physics: const NeverScrollableScrollPhysics(),
                          children: snapshot.data
                              .map<Widget>((PictogramModel pictogram) {
                            if (pictogram == null) {
                              return Container(
                                height: 80,
                                child: const Center(
                                    child: CircularProgressIndicator()),
                              );
                            } else {
                              return PictogramImage(
                                  pictogram: pictogram,
                                  onPressed: () => addToPass(pictogram));
                            }
                          }).toList());
                    } else {
                      return const Text('Fejl');
                    }
                  })),
        ],
      ),
      // This acts as a spacer.
      const SizedBox(
        height: 10,
      ),
      // Password grid view
      Container(
        color: Colors.grey,
        width: MediaQuery.of(context).size.width,
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                constraints: const BoxConstraints(
                    maxHeight: double.infinity, maxWidth: MAXWIDTH),
                child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 4,
                    crossAxisSpacing: 20,
                    children: passwordList())),
          ],
        ),
      )
    ]);
  }
}
