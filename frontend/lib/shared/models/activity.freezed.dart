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

 int get activityId;@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime get date;@JsonKey(fromJson: _nullableTimeFromJson, toJson: _nullableTimeToJson) TimeValue? get startTime;@JsonKey(fromJson: _nullableTimeFromJson, toJson: _nullableTimeToJson) TimeValue? get endTime; String? get title; int get sortOrder; bool get isCompleted; int? get pictogramId; int? get selectedOptionIndex; List<ActivityOption> get options;
/// Create a copy of Activity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityCopyWith<Activity> get copyWith => _$ActivityCopyWithImpl<Activity>(this as Activity, _$identity);

  /// Serializes this Activity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Activity&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.date, date) || other.date == date)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.title, title) || other.title == title)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.pictogramId, pictogramId) || other.pictogramId == pictogramId)&&(identical(other.selectedOptionIndex, selectedOptionIndex) || other.selectedOptionIndex == selectedOptionIndex)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityId,date,startTime,endTime,title,sortOrder,isCompleted,pictogramId,selectedOptionIndex,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'Activity(activityId: $activityId, date: $date, startTime: $startTime, endTime: $endTime, title: $title, sortOrder: $sortOrder, isCompleted: $isCompleted, pictogramId: $pictogramId, selectedOptionIndex: $selectedOptionIndex, options: $options)';
}


}

/// @nodoc
abstract mixin class $ActivityCopyWith<$Res>  {
  factory $ActivityCopyWith(Activity value, $Res Function(Activity) _then) = _$ActivityCopyWithImpl;
@useResult
$Res call({
 int activityId,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime date,@JsonKey(fromJson: _nullableTimeFromJson, toJson: _nullableTimeToJson) TimeValue? startTime,@JsonKey(fromJson: _nullableTimeFromJson, toJson: _nullableTimeToJson) TimeValue? endTime, String? title, int sortOrder, bool isCompleted, int? pictogramId, int? selectedOptionIndex, List<ActivityOption> options
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
@pragma('vm:prefer-inline') @override $Res call({Object? activityId = null,Object? date = null,Object? startTime = freezed,Object? endTime = freezed,Object? title = freezed,Object? sortOrder = null,Object? isCompleted = null,Object? pictogramId = freezed,Object? selectedOptionIndex = freezed,Object? options = null,}) {
  return _then(_self.copyWith(
activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as TimeValue?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as TimeValue?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,pictogramId: freezed == pictogramId ? _self.pictogramId : pictogramId // ignore: cast_nullable_to_non_nullable
as int?,selectedOptionIndex: freezed == selectedOptionIndex ? _self.selectedOptionIndex : selectedOptionIndex // ignore: cast_nullable_to_non_nullable
as int?,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<ActivityOption>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int activityId, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime date, @JsonKey(fromJson: _nullableTimeFromJson, toJson: _nullableTimeToJson)  TimeValue? startTime, @JsonKey(fromJson: _nullableTimeFromJson, toJson: _nullableTimeToJson)  TimeValue? endTime,  String? title,  int sortOrder,  bool isCompleted,  int? pictogramId,  int? selectedOptionIndex,  List<ActivityOption> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Activity() when $default != null:
return $default(_that.activityId,_that.date,_that.startTime,_that.endTime,_that.title,_that.sortOrder,_that.isCompleted,_that.pictogramId,_that.selectedOptionIndex,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int activityId, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime date, @JsonKey(fromJson: _nullableTimeFromJson, toJson: _nullableTimeToJson)  TimeValue? startTime, @JsonKey(fromJson: _nullableTimeFromJson, toJson: _nullableTimeToJson)  TimeValue? endTime,  String? title,  int sortOrder,  bool isCompleted,  int? pictogramId,  int? selectedOptionIndex,  List<ActivityOption> options)  $default,) {final _that = this;
switch (_that) {
case _Activity():
return $default(_that.activityId,_that.date,_that.startTime,_that.endTime,_that.title,_that.sortOrder,_that.isCompleted,_that.pictogramId,_that.selectedOptionIndex,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int activityId, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)  DateTime date, @JsonKey(fromJson: _nullableTimeFromJson, toJson: _nullableTimeToJson)  TimeValue? startTime, @JsonKey(fromJson: _nullableTimeFromJson, toJson: _nullableTimeToJson)  TimeValue? endTime,  String? title,  int sortOrder,  bool isCompleted,  int? pictogramId,  int? selectedOptionIndex,  List<ActivityOption> options)?  $default,) {final _that = this;
switch (_that) {
case _Activity() when $default != null:
return $default(_that.activityId,_that.date,_that.startTime,_that.endTime,_that.title,_that.sortOrder,_that.isCompleted,_that.pictogramId,_that.selectedOptionIndex,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Activity implements Activity {
  const _Activity({required this.activityId, @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) required this.date, @JsonKey(fromJson: _nullableTimeFromJson, toJson: _nullableTimeToJson) this.startTime, @JsonKey(fromJson: _nullableTimeFromJson, toJson: _nullableTimeToJson) this.endTime, this.title, this.sortOrder = 0, this.isCompleted = false, this.pictogramId, this.selectedOptionIndex, final  List<ActivityOption> options = const []}): _options = options;
  factory _Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);

@override final  int activityId;
@override@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) final  DateTime date;
@override@JsonKey(fromJson: _nullableTimeFromJson, toJson: _nullableTimeToJson) final  TimeValue? startTime;
@override@JsonKey(fromJson: _nullableTimeFromJson, toJson: _nullableTimeToJson) final  TimeValue? endTime;
@override final  String? title;
@override@JsonKey() final  int sortOrder;
@override@JsonKey() final  bool isCompleted;
@override final  int? pictogramId;
@override final  int? selectedOptionIndex;
 final  List<ActivityOption> _options;
@override@JsonKey() List<ActivityOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Activity&&(identical(other.activityId, activityId) || other.activityId == activityId)&&(identical(other.date, date) || other.date == date)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.title, title) || other.title == title)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.pictogramId, pictogramId) || other.pictogramId == pictogramId)&&(identical(other.selectedOptionIndex, selectedOptionIndex) || other.selectedOptionIndex == selectedOptionIndex)&&const DeepCollectionEquality().equals(other._options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activityId,date,startTime,endTime,title,sortOrder,isCompleted,pictogramId,selectedOptionIndex,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'Activity(activityId: $activityId, date: $date, startTime: $startTime, endTime: $endTime, title: $title, sortOrder: $sortOrder, isCompleted: $isCompleted, pictogramId: $pictogramId, selectedOptionIndex: $selectedOptionIndex, options: $options)';
}


}

/// @nodoc
abstract mixin class _$ActivityCopyWith<$Res> implements $ActivityCopyWith<$Res> {
  factory _$ActivityCopyWith(_Activity value, $Res Function(_Activity) _then) = __$ActivityCopyWithImpl;
@override @useResult
$Res call({
 int activityId,@JsonKey(fromJson: _dateFromJson, toJson: _dateToJson) DateTime date,@JsonKey(fromJson: _nullableTimeFromJson, toJson: _nullableTimeToJson) TimeValue? startTime,@JsonKey(fromJson: _nullableTimeFromJson, toJson: _nullableTimeToJson) TimeValue? endTime, String? title, int sortOrder, bool isCompleted, int? pictogramId, int? selectedOptionIndex, List<ActivityOption> options
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
@override @pragma('vm:prefer-inline') $Res call({Object? activityId = null,Object? date = null,Object? startTime = freezed,Object? endTime = freezed,Object? title = freezed,Object? sortOrder = null,Object? isCompleted = null,Object? pictogramId = freezed,Object? selectedOptionIndex = freezed,Object? options = null,}) {
  return _then(_Activity(
activityId: null == activityId ? _self.activityId : activityId // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as TimeValue?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as TimeValue?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,pictogramId: freezed == pictogramId ? _self.pictogramId : pictogramId // ignore: cast_nullable_to_non_nullable
as int?,selectedOptionIndex: freezed == selectedOptionIndex ? _self.selectedOptionIndex : selectedOptionIndex // ignore: cast_nullable_to_non_nullable
as int?,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<ActivityOption>,
  ));
}


}


/// @nodoc
mixin _$ActivityOption {

 int get id; String? get title; int? get pictogramId; int get sortOrder;
/// Create a copy of ActivityOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityOptionCopyWith<ActivityOption> get copyWith => _$ActivityOptionCopyWithImpl<ActivityOption>(this as ActivityOption, _$identity);

  /// Serializes this ActivityOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityOption&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.pictogramId, pictogramId) || other.pictogramId == pictogramId)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,pictogramId,sortOrder);

@override
String toString() {
  return 'ActivityOption(id: $id, title: $title, pictogramId: $pictogramId, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $ActivityOptionCopyWith<$Res>  {
  factory $ActivityOptionCopyWith(ActivityOption value, $Res Function(ActivityOption) _then) = _$ActivityOptionCopyWithImpl;
@useResult
$Res call({
 int id, String? title, int? pictogramId, int sortOrder
});




}
/// @nodoc
class _$ActivityOptionCopyWithImpl<$Res>
    implements $ActivityOptionCopyWith<$Res> {
  _$ActivityOptionCopyWithImpl(this._self, this._then);

  final ActivityOption _self;
  final $Res Function(ActivityOption) _then;

/// Create a copy of ActivityOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = freezed,Object? pictogramId = freezed,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,pictogramId: freezed == pictogramId ? _self.pictogramId : pictogramId // ignore: cast_nullable_to_non_nullable
as int?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityOption].
extension ActivityOptionPatterns on ActivityOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityOption value)  $default,){
final _that = this;
switch (_that) {
case _ActivityOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityOption value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? title,  int? pictogramId,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityOption() when $default != null:
return $default(_that.id,_that.title,_that.pictogramId,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? title,  int? pictogramId,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _ActivityOption():
return $default(_that.id,_that.title,_that.pictogramId,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? title,  int? pictogramId,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _ActivityOption() when $default != null:
return $default(_that.id,_that.title,_that.pictogramId,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityOption implements ActivityOption {
  const _ActivityOption({required this.id, this.title, this.pictogramId, this.sortOrder = 0});
  factory _ActivityOption.fromJson(Map<String, dynamic> json) => _$ActivityOptionFromJson(json);

@override final  int id;
@override final  String? title;
@override final  int? pictogramId;
@override@JsonKey() final  int sortOrder;

/// Create a copy of ActivityOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityOptionCopyWith<_ActivityOption> get copyWith => __$ActivityOptionCopyWithImpl<_ActivityOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityOption&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.pictogramId, pictogramId) || other.pictogramId == pictogramId)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,pictogramId,sortOrder);

@override
String toString() {
  return 'ActivityOption(id: $id, title: $title, pictogramId: $pictogramId, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$ActivityOptionCopyWith<$Res> implements $ActivityOptionCopyWith<$Res> {
  factory _$ActivityOptionCopyWith(_ActivityOption value, $Res Function(_ActivityOption) _then) = __$ActivityOptionCopyWithImpl;
@override @useResult
$Res call({
 int id, String? title, int? pictogramId, int sortOrder
});




}
/// @nodoc
class __$ActivityOptionCopyWithImpl<$Res>
    implements _$ActivityOptionCopyWith<$Res> {
  __$ActivityOptionCopyWithImpl(this._self, this._then);

  final _ActivityOption _self;
  final $Res Function(_ActivityOption) _then;

/// Create a copy of ActivityOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = freezed,Object? pictogramId = freezed,Object? sortOrder = null,}) {
  return _then(_ActivityOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,pictogramId: freezed == pictogramId ? _self.pictogramId : pictogramId // ignore: cast_nullable_to_non_nullable
as int?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
