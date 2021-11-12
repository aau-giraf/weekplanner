import 'dart:async';

import 'package:api_client/api/api.dart';
import 'package:api_client/models/pictogram_model.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/blocs/bloc_base.dart';
import 'package:rxdart/rxdart.dart' as rx_dart;

///Bloc for the creation of a citizens password
class NewCitizenLoginBloc extends BlocBase{

  ///Constructor for the bloc
  NewCitizenLoginBloc(this._api){
    this.getPictograms(20);
    for (int i = 0; i < loginSize; i++ ){
      loginList.add(null);
    }
  }

  /// Random char to satisfy query
  static const String query = 'd';
  /// First page as static
  static const int page = 1;

  final Api _api;

  Stream <List<PictogramModel>> get pictograms => _pictograms.stream;
  Stream <List<PictogramModel>> get selectedPictograms => _selectedPictograms.stream;

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

  ///Login list
  List<PictogramModel> loginList = [];

  void getPictograms (int size){

    loadingPictograms = true;
    if (_debounceTimer != null) {
      _debounceTimer.cancel();
    }

    List<PictogramModel> _resultPlaceholder = [];

    _debounceTimer = Timer(const Duration(milliseconds: _debounceTime), ()
    {
      //Timer for sending an error if getting pictogram results takes too long
      Timer(const Duration(milliseconds: _timeoutTime), () {
        if (_resultPlaceholder == null || _resultPlaceholder.isEmpty) {
          _pictograms.addError('Søgningen gav ingen resultater. '
              'Tjek internetforbindelsen.');
        }
      });

      _api.pictogram
          .getAll(page: page, pageSize: size, query: query)
          .listen((List<PictogramModel> results) {
        _resultPlaceholder = results;
        _pictograms.add(_resultPlaceholder);
        loadingPictograms = false;
      });
    });
  }

  void update (PictogramModel pictogram, int index){
    loginList.removeAt(index);
    loginList.insert(index, pictogram);
    _selectedPictograms.add(loginList);
  }

  int getNextNull (){
    int index = loginList.indexOf(null);
    return index;
  }


  @override
  void dispose() {
    _pictograms.close();
    _selectedPictograms.close();
    loginList.clear();
  }
}
