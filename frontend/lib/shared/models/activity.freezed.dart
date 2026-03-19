// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Activity {

@JsonKey(name: 'activity_id') int get activityId; String get date;@JsonKey(name: 'start_time') String get startTime;@JsonKey(name: 'end_time') String get endTime;@JsonKey(name: 'is_completed') bool get isCompleted;@JsonKey(name: 'pictogram_id') int? get pictogramId;@JsonKey(name: 'citizen_id') int? get citizenId;@JsonKey(name: 'grade_id') int? get gradeId; String? get title;
/// Create a copy of Activity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityCopyWith<Activity> get copyWith => _$ActivityCopyWithImpl<Activity>(this as Activity, _$identity);

  /// Serializes this Activity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Activity&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.date, date) || other.date == date)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.pictogramId, pictogramId) || other.pictogramId == pictogramId)&&(identical(other.citizenId, citizenId) || other.citizenId == citizenId)&&(identical(other.gradeId, gradeId) || other.gradeId == gradeId)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityId,date,startTime,endTime,isCompleted,pictogramId,citizenId,gradeId,title);

@override
String toString() {
  return 'Activity(activityId: $activityId, date: $date, startTime: $startTime, endTime: $endTime, isCompleted: $isCompleted, pictogramId: $pictogramId, citizenId: $citizenId, gradeId: $gradeId, title: $title)';
}


}

/// @nodoc
abstract mixin class $ActivityCopyWith<$Res>  {
  factory $ActivityCopyWith(Activity value, $Res Function(Activity) _then) = _$ActivityCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'activity_id') int activityId, String date,@JsonKey(name: 'start_time') String startTime,@JsonKey(name: 'end_time') String endTime,@JsonKey(name: 'is_completed') bool isCompleted,@JsonKey(name: 'pictogram_id') int? pictogramId,@JsonKey(name: 'citizen_id') int? citizenId,@JsonKey(name: 'grade_id') int? gradeId, String? title
});




}
/// @nodoc
class _$ActivityCopyWithImpl<$Res>
    implements $ActivityCopyWith<$Res> {
  _$ActivityCopyWithImpl(this._self, this._then);

  final Activity _self;
  final $Res Function(Activity) _then;

/// Create a copy of Activity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activityId = null,Object? date = null,Object? startTime = null,Object? endTime = null,Object? isCompleted = null,Object? pictogramId = freezed,Object? citizenId = freezed,Object? gradeId = freezed,Object? title = freezed,}) {
  return _then(_self.copyWith(
activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,pictogramId: freezed == pictogramId ? _self.pictogramId : pictogramId // ignore: cast_nullable_to_non_nullable
as int?,citizenId: freezed == citizenId ? _self.citizenId : citizenId // ignore: cast_nullable_to_non_nullable
as int?,gradeId: freezed == gradeId ? _self.gradeId : gradeId // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Activity].
extension ActivityPatterns on Activity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Activity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Activity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Activity value)  $default,){
final _that = this;
switch (_that) {
case _Activity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Activity value)?  $default,){
final _that = this;
switch (_that) {
case _Activity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'activity_id')  int activityId,  String date, @JsonKey(name: 'start_time')  String startTime, @JsonKey(name: 'end_time')  String endTime, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'pictogram_id')  int? pictogramId, @JsonKey(name: 'citizen_id')  int? citizenId, @JsonKey(name: 'grade_id')  int? gradeId,  String? title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Activity() when $default != null:
return $default(_that.activityId,_that.date,_that.startTime,_that.endTime,_that.isCompleted,_that.pictogramId,_that.citizenId,_that.gradeId,_that.title);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'activity_id')  int activityId,  String date, @JsonKey(name: 'start_time')  String startTime, @JsonKey(name: 'end_time')  String endTime, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'pictogram_id')  int? pictogramId, @JsonKey(name: 'citizen_id')  int? citizenId, @JsonKey(name: 'grade_id')  int? gradeId,  String? title)  $default,) {final _that = this;
switch (_that) {
case _Activity():
return $default(_that.activityId,_that.date,_that.startTime,_that.endTime,_that.isCompleted,_that.pictogramId,_that.citizenId,_that.gradeId,_that.title);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'activity_id')  int activityId,  String date, @JsonKey(name: 'start_time')  String startTime, @JsonKey(name: 'end_time')  String endTime, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'pictogram_id')  int? pictogramId, @JsonKey(name: 'citizen_id')  int? citizenId, @JsonKey(name: 'grade_id')  int? gradeId,  String? title)?  $default,) {final _that = this;
switch (_that) {
case _Activity() when $default != null:
return $default(_that.activityId,_that.date,_that.startTime,_that.endTime,_that.isCompleted,_that.pictogramId,_that.citizenId,_that.gradeId,_that.title);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Activity implements Activity {
  const _Activity({@JsonKey(name: 'activity_id') required this.activityId, required this.date, @JsonKey(name: 'start_time') required this.startTime, @JsonKey(name: 'end_time') required this.endTime, @JsonKey(name: 'is_completed') this.isCompleted = false, @JsonKey(name: 'pictogram_id') this.pictogramId, @JsonKey(name: 'citizen_id') this.citizenId, @JsonKey(name: 'grade_id') this.gradeId, this.title});
  factory _Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);

@override@JsonKey(name: 'activity_id') final  int activityId;
@override final  String date;
@override@JsonKey(name: 'start_time') final  String startTime;
@override@JsonKey(name: 'end_time') final  String endTime;
@override@JsonKey(name: 'is_completed') final  bool isCompleted;
@override@JsonKey(name: 'pictogram_id') final  int? pictogramId;
@override@JsonKey(name: 'citizen_id') final  int? citizenId;
@override@JsonKey(name: 'grade_id') final  int? gradeId;
@override final  String? title;

/// Create a copy of Activity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityCopyWith<_Activity> get copyWith => __$ActivityCopyWithImpl<_Activity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Activity&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.date, date) || other.date == date)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.pictogramId, pictogramId) || other.pictogramId == pictogramId)&&(identical(other.citizenId, citizenId) || other.citizenId == citizenId)&&(identical(other.gradeId, gradeId) || other.gradeId == gradeId)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityId,date,startTime,endTime,isCompleted,pictogramId,citizenId,gradeId,title);

@override
String toString() {
  return 'Activity(activityId: $activityId, date: $date, startTime: $startTime, endTime: $endTime, isCompleted: $isCompleted, pictogramId: $pictogramId, citizenId: $citizenId, gradeId: $gradeId, title: $title)';
}


}

/// @nodoc
abstract mixin class _$ActivityCopyWith<$Res> implements $ActivityCopyWith<$Res> {
  factory _$ActivityCopyWith(_Activity value, $Res Function(_Activity) _then) = __$ActivityCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'activity_id') int activityId, String date,@JsonKey(name: 'start_time') String startTime,@JsonKey(name: 'end_time') String endTime,@JsonKey(name: 'is_completed') bool isCompleted,@JsonKey(name: 'pictogram_id') int? pictogramId,@JsonKey(name: 'citizen_id') int? citizenId,@JsonKey(name: 'grade_id') int? gradeId, String? title
});




}
/// @nodoc
class __$ActivityCopyWithImpl<$Res>
    implements _$ActivityCopyWith<$Res> {
  __$ActivityCopyWithImpl(this._self, this._then);

  final _Activity _self;
  final $Res Function(_Activity) _then;

/// Create a copy of Activity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activityId = null,Object? date = null,Object? startTime = null,Object? endTime = null,Object? isCompleted = null,Object? pictogramId = freezed,Object? citizenId = freezed,Object? gradeId = freezed,Object? title = freezed,}) {
  return _then(_Activity(
activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,pictogramId: freezed == pictogramId ? _self.pictogramId : pictogramId // ignore: cast_nullable_to_non_nullable
as int?,citizenId: freezed == citizenId ? _self.citizenId : citizenId // ignore: cast_nullable_to_non_nullable
as int?,gradeId: freezed == gradeId ? _self.gradeId : gradeId // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
