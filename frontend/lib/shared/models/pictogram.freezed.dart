// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pictogram.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Pictogram {

 int get id; String get name;@JsonKey(name: 'image_url') String? get imageUrl;@JsonKey(name: 'sound_url') String? get soundUrl;@JsonKey(name: 'organization_id') int? get organizationId;
/// Create a copy of Pictogram
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PictogramCopyWith<Pictogram> get copyWith => _$PictogramCopyWithImpl<Pictogram>(this as Pictogram, _$identity);

  /// Serializes this Pictogram to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Pictogram&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.soundUrl, soundUrl) || other.soundUrl == soundUrl)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,imageUrl,soundUrl,organizationId);

@override
String toString() {
  return 'Pictogram(id: $id, name: $name, imageUrl: $imageUrl, soundUrl: $soundUrl, organizationId: $organizationId)';
}


}

/// @nodoc
abstract mixin class $PictogramCopyWith<$Res>  {
  factory $PictogramCopyWith(Pictogram value, $Res Function(Pictogram) _then) = _$PictogramCopyWithImpl;
@useResult
$Res call({
 int id, String name,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'sound_url') String? soundUrl,@JsonKey(name: 'organization_id') int? organizationId
});




}
/// @nodoc
class _$PictogramCopyWithImpl<$Res>
    implements $PictogramCopyWith<$Res> {
  _$PictogramCopyWithImpl(this._self, this._then);

  final Pictogram _self;
  final $Res Function(Pictogram) _then;

/// Create a copy of Pictogram
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? imageUrl = freezed,Object? soundUrl = freezed,Object? organizationId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,soundUrl: freezed == soundUrl ? _self.soundUrl : soundUrl // ignore: cast_nullable_to_non_nullable
as String?,organizationId: freezed == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Pictogram].
extension PictogramPatterns on Pictogram {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Pictogram value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Pictogram() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Pictogram value)  $default,){
final _that = this;
switch (_that) {
case _Pictogram():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Pictogram value)?  $default,){
final _that = this;
switch (_that) {
case _Pictogram() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'sound_url')  String? soundUrl, @JsonKey(name: 'organization_id')  int? organizationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Pictogram() when $default != null:
return $default(_that.id,_that.name,_that.imageUrl,_that.soundUrl,_that.organizationId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'sound_url')  String? soundUrl, @JsonKey(name: 'organization_id')  int? organizationId)  $default,) {final _that = this;
switch (_that) {
case _Pictogram():
return $default(_that.id,_that.name,_that.imageUrl,_that.soundUrl,_that.organizationId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'sound_url')  String? soundUrl, @JsonKey(name: 'organization_id')  int? organizationId)?  $default,) {final _that = this;
switch (_that) {
case _Pictogram() when $default != null:
return $default(_that.id,_that.name,_that.imageUrl,_that.soundUrl,_that.organizationId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Pictogram implements Pictogram {
  const _Pictogram({required this.id, required this.name, @JsonKey(name: 'image_url') this.imageUrl, @JsonKey(name: 'sound_url') this.soundUrl, @JsonKey(name: 'organization_id') this.organizationId});
  factory _Pictogram.fromJson(Map<String, dynamic> json) => _$PictogramFromJson(json);

@override final  int id;
@override final  String name;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
@override@JsonKey(name: 'sound_url') final  String? soundUrl;
@override@JsonKey(name: 'organization_id') final  int? organizationId;

/// Create a copy of Pictogram
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PictogramCopyWith<_Pictogram> get copyWith => __$PictogramCopyWithImpl<_Pictogram>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PictogramToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Pictogram&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.soundUrl, soundUrl) || other.soundUrl == soundUrl)&&(identical(other.organizationId, organizationId) || other.organizationId == organizationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,imageUrl,soundUrl,organizationId);

@override
String toString() {
  return 'Pictogram(id: $id, name: $name, imageUrl: $imageUrl, soundUrl: $soundUrl, organizationId: $organizationId)';
}


}

/// @nodoc
abstract mixin class _$PictogramCopyWith<$Res> implements $PictogramCopyWith<$Res> {
  factory _$PictogramCopyWith(_Pictogram value, $Res Function(_Pictogram) _then) = __$PictogramCopyWithImpl;
@override @useResult
$Res call({
 int id, String name,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'sound_url') String? soundUrl,@JsonKey(name: 'organization_id') int? organizationId
});




}
/// @nodoc
class __$PictogramCopyWithImpl<$Res>
    implements _$PictogramCopyWith<$Res> {
  __$PictogramCopyWithImpl(this._self, this._then);

  final _Pictogram _self;
  final $Res Function(_Pictogram) _then;

/// Create a copy of Pictogram
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? imageUrl = freezed,Object? soundUrl = freezed,Object? organizationId = freezed,}) {
  return _then(_Pictogram(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,soundUrl: freezed == soundUrl ? _self.soundUrl : soundUrl // ignore: cast_nullable_to_non_nullable
as String?,organizationId: freezed == organizationId ? _self.organizationId : organizationId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
