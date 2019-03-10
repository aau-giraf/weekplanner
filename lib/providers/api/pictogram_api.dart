import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weekplanner/models/pictogram_model.dart';
import 'package:weekplanner/providers/api/http.dart';
import 'package:weekplanner/providers/persistence.dart';

class PictogramApi {
    final Http _http;
    final Persistence persist;

  PictogramApi(this._http, this.persist);

  Observable<List<PictogramModel>> getAllPictogram(){
     return _http.get('/pictogram').map((Response res) {
         List<PictogramModel> pictogram = (res.json['data'] as List).map((map) {
             return PictogramModel.fromJson(map);
         }); 
         return pictogram;
     });
  }

  Observable<PictogramModel> getPictogram(int id){
      return _http.get('/' + id.toString()).map((Response res) {
          return  PictogramModel.fromJson(res.json['data']);
      });
  }


  Observable<PictogramModel> createPictogram(PictogramModel pictogram){
      Map<String, String> body =  pictogram.toJson();
      return _http.post('/', body).map((Response res) {
          return res.json['data'];
      });
  }

  Observable<PictogramModel> updatePictogram(PictogramModel pictogram){
      Map<String, String> body = pictogram.toJson();
      return _http.put('/' + pictogram.id.toString(), body).map((Response res) {
          return PictogramModel.fromJson(res.json['data']);
      });
  }

    Observable<bool> deletePictogram(int id){
        return _http.delete('/delete/' + id.toString()).map((Response res) {
            return res.json['success'];
    });
}

  Observable<PictogramModel> updatePictogramImage(PictogramModel pictogram){
      Map<String, String> body =pictogram.toJson();
      return _http.put('/' + pictogram.id.toString() + '/image', body).map((Response res) {
          return  PictogramModel.fromJson(res.json['data']);
      });
  }

    Observable<Image> getPictogramImageRaw (PictogramModel pictogram){
      return _http.get('/${pictogram.id}/image/raw').map((Response res) {
          return  Image.memory(res.response.bodyBytes);
      });
    }
}