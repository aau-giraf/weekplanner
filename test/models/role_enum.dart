import 'package:test_api/test_api.dart';
import 'package:weekplanner/models/role_enum.dart';

void main(){
  test('Should contain a specific list of values', (){
    expect(Role.none.index, 0);
    expect(Role.Citizen.index, 1);
    expect(Role.Department.index, 2);
    expect(Role.Guardian.index, 3);
    expect(Role.SuperUser.index, 4);
  });
}