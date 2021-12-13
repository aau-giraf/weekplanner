import 'dart:async';
import 'package:weekplanner/providers/environment_provider.dart' as environment;
import 'package:api_client/api/api.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;

///Bloc for the control of a pictograms for the citizens password
class LoginPictogramBloc extends BlocBase {
  ///Constructor for the bloc
  LoginPictogramBloc(this._api) {
    this.getPictograms(100);
    loginList = [];
    for (int i = 0; i < loginSize; i++) {
      loginList.add(null);
    }
  }

  /// Empty char to satisfy query
  static const String query = '';
  /// First page as static
  static const int page = 1;

  final Api _api;

  ///Stream listening for pictograms from server
  Stream <List<PictogramModel>> get pictograms => _pictograms.stream;

  ///Stream listening for pictograms to input in login field
  Stream <List<PictogramModel>> get selectedPictograms => _selectedPictograms.stream;

  /// Gives information about whether pictogram login is valid.
  //TODO Stream<bool> get LoginIsValidStream =>


  final rx_dart.BehaviorSubject<List<PictogramModel>> _pictograms =
  rx_dart.BehaviorSubject<List<PictogramModel>>();

  final rx_dart.BehaviorSubject<List<PictogramModel>> _selectedPictograms =
  rx_dart.BehaviorSubject<List<PictogramModel>>();

  ///Async timer
  Timer _debounceTimer;

  /// For how long the debouncer should wait
  static const int _debounceTime = 250;
  static const int _timeoutTime = 10000;

  /// Boolean used to specify if more pictograms are able to be loaded.
  bool loadingPictograms = false;

  ///Size of login field
  final int loginSize = 4;

  String loginString = '';

  ///Login list
  List<PictogramModel> loginList = [];

  ///Initializes a search for pictograms from the server
  /// Uses a given search query
  //TODO(kristnaKris): should have its own api call to specific pictograms specified for login
  /// The results are published in [pictograms].
  void getPictograms(int size) async {

    loadingPictograms = true;
    if (_debounceTimer != null) {
      _debounceTimer.cancel();
    }

    List<PictogramModel> _resultPlaceholder = [];

    _debounceTimer = Timer(const Duration(milliseconds: _debounceTime), () {
      _api.pictogram
          .getAll(page: page, pageSize: size, query: query)
          .listen((List<PictogramModel> results) {
        _resultPlaceholder = results;
        _pictograms.add(_resultPlaceholder);
        loadingPictograms = false;
      });
      //Timer for sending an error if getting pictogram results takes too long
      Timer(const Duration(milliseconds: _timeoutTime), () {
        if (_resultPlaceholder == null || _resultPlaceholder.isEmpty) {
          _pictograms.addError('Søgningen gav ingen resultater. '
              'Tjek internetforbindelsen.');
        }
      });
    });
  }

  ///Updates the loginList and adds it to the stream
  ///Removes the current element from [loginList] at the given [index]
  ///Adds the updated loginList to the [_selectedPictograms] stream
  void update(PictogramModel pictogram, int index) {
    loginList.removeAt(index);
    loginList.insert(index, pictogram);
    _selectedPictograms.add(loginList);
    if(nullInLogin() != true){
      loginString = '';
      for(int i = 0; i < loginSize; i++){
        loginString = loginString + (loginList[i].id).toString();
      }
    }
  }

  ///Returns true if there is a null in the loginList
  bool nullInLogin() {
    bool foundNull = false;
    for (int i = 0; i < loginSize; i++) {
      if (loginList[i] == null) {
        foundNull = true;
        return foundNull;
      }
    }
    return foundNull;
  }

  ///finds the first null element of the loginList
  int getNextNull() {
    int index = loginList.indexOf(null);
    return index;
  }

  void reset() {
    loginList.clear();
    for (int i = 0; i < loginSize; i++) {
      loginList.add(null);
    }
  }

  @override
  void dispose() {
    _pictograms.close();
    _selectedPictograms.close();
    loginList.clear();
  }
}
