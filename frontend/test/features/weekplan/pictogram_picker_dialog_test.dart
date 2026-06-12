import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/core/errors/pictogram_failure.dart';
import 'package:weekplanner/features/weekplan/domain/repositories/pictogram_repository.dart';
import 'package:weekplanner/features/weekplan/presentation/widgets/pictogram_picker_dialog.dart';
import 'package:weekplanner/shared/models/file_data.dart';
import 'package:weekplanner/shared/models/pictogram.dart';

class MockPictogramRepository extends Mock implements PictogramRepository {}

void main() {
  late MockPictogramRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(
      (name: '', size: 0, bytes: null, path: null) as FileData,
    );
  });

  setUp(() {
    mockRepository = MockPictogramRepository();
  });

  /// Pumps a host page with a button that opens the dialog, taps it,
  /// and returns a getter for the dialog's pop result.
  Future<Pictogram? Function()> openDialog(
    WidgetTester tester, {
    int? organizationId,
    Future<FileData?> Function()? pickImageFile,
  }) async {
    Pictogram? result;
    await tester.pumpWidget(
      MaterialApp(
        theme: girafTheme,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () async {
                  result = await showDialog<Pictogram>(
                    context: context,
                    builder: (_) => RepositoryProvider<PictogramRepository>.value(
                      value: mockRepository,
                      child: PictogramPickerDialog(
                        organizationId: organizationId,
                        pickImageFile: pickImageFile,
                      ),
                    ),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return () => result;
  }

  group('PictogramPickerDialog', () {
    testWidgets('renders three mode segments', (tester) async {
      await openDialog(tester);

      expect(find.text('Søg'), findsOneWidget);
      expect(find.text('Upload'), findsOneWidget);
      expect(find.text('Generer'), findsOneWidget);
    });

    testWidgets('defaults to search mode with search field', (tester) async {
      await openDialog(tester);

      expect(
        find.widgetWithText(TextField, 'Søg piktogram'),
        findsOneWidget,
      );
    });

    testWidgets('upload mode shows name field, file buttons and create button',
        (tester) async {
      await openDialog(tester);

      await tester.tap(find.text('Upload'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextField, 'Navn'), findsOneWidget);
      expect(find.text('Vælg billede'), findsOneWidget);
      expect(find.text('Vælg lydfil (valgfrit)'), findsOneWidget);
      expect(find.text('Generer lyd automatisk'), findsOneWidget);
      expect(find.text('Opret piktogram'), findsOneWidget);
    });

    testWidgets('generate mode shows name field, sound toggle and button',
        (tester) async {
      await openDialog(tester);

      await tester.tap(find.text('Generer'));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextField, 'Navn'), findsOneWidget);
      expect(find.text('Generer lyd'), findsOneWidget);
      expect(find.text('Generer piktogram'), findsOneWidget);
    });

    testWidgets(
        'generate with empty name shows error and does not call repository',
        (tester) async {
      await openDialog(tester);

      await tester.tap(find.text('Generer'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Generer piktogram'));
      await tester.pumpAndSettle();

      expect(find.text('Angiv et navn'), findsOneWidget);
      verifyNever(() => mockRepository.createPictogram(
            name: any(named: 'name'),
            imageUrl: any(named: 'imageUrl'),
            organizationId: any(named: 'organizationId'),
            generateImage: any(named: 'generateImage'),
            generateSound: any(named: 'generateSound'),
          ));
    });

    testWidgets('generate calls createPictogram and pops with the pictogram',
        (tester) async {
      const created = Pictogram(id: 7, name: 'Svømning');
      when(() => mockRepository.createPictogram(
            name: any(named: 'name'),
            imageUrl: any(named: 'imageUrl'),
            organizationId: any(named: 'organizationId'),
            generateImage: any(named: 'generateImage'),
            generateSound: any(named: 'generateSound'),
          )).thenAnswer((_) async => const Right(created));

      final result = await openDialog(tester, organizationId: 5);

      await tester.tap(find.text('Generer'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextField, 'Navn'),
        'Svømning',
      );
      await tester.tap(find.text('Generer piktogram'));
      await tester.pumpAndSettle();

      verify(() => mockRepository.createPictogram(
            name: 'Svømning',
            organizationId: 5,
            generateImage: true,
            generateSound: true,
          )).called(1);
      expect(result(), created);
    });

    testWidgets('shows error message when generation fails', (tester) async {
      when(() => mockRepository.createPictogram(
            name: any(named: 'name'),
            imageUrl: any(named: 'imageUrl'),
            organizationId: any(named: 'organizationId'),
            generateImage: any(named: 'generateImage'),
            generateSound: any(named: 'generateSound'),
          )).thenAnswer(
        (_) async => const Left(CreatePictogramFailure()),
      );

      final result = await openDialog(tester);

      await tester.tap(find.text('Generer'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextField, 'Navn'),
        'Svømning',
      );
      await tester.tap(find.text('Generer piktogram'));
      await tester.pumpAndSettle();

      expect(find.text('Kunne ikke oprette piktogram'), findsOneWidget);
      expect(result(), isNull);
    });

    testWidgets('upload without image shows error and does not call repository',
        (tester) async {
      await openDialog(tester);

      await tester.tap(find.text('Upload'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextField, 'Navn'),
        'Svømning',
      );
      await tester.tap(find.text('Opret piktogram'));
      await tester.pumpAndSettle();

      expect(find.text('Vælg et billede'), findsOneWidget);
      verifyNever(() => mockRepository.uploadPictogram(
            name: any(named: 'name'),
            imageFile: any(named: 'imageFile'),
            soundFile: any(named: 'soundFile'),
            organizationId: any(named: 'organizationId'),
            generateSound: any(named: 'generateSound'),
          ));
    });

    testWidgets('upload calls uploadPictogram and pops with the pictogram',
        (tester) async {
      const created = Pictogram(id: 9, name: 'Svømning');
      final imageFile = (
        name: 'svoemning.png',
        size: 3,
        bytes: Uint8List.fromList([1, 2, 3]),
        path: null,
      );
      when(() => mockRepository.uploadPictogram(
            name: any(named: 'name'),
            imageFile: any(named: 'imageFile'),
            soundFile: any(named: 'soundFile'),
            organizationId: any(named: 'organizationId'),
            generateSound: any(named: 'generateSound'),
          )).thenAnswer((_) async => const Right(created));

      final result = await openDialog(
        tester,
        organizationId: 5,
        pickImageFile: () async => imageFile,
      );

      await tester.tap(find.text('Upload'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Vælg billede'));
      await tester.pumpAndSettle();

      // The picked file name replaces the button label.
      expect(find.text('svoemning.png'), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextField, 'Navn'),
        'Svømning',
      );
      await tester.tap(find.text('Opret piktogram'));
      await tester.pumpAndSettle();

      verify(() => mockRepository.uploadPictogram(
            name: 'Svømning',
            imageFile: imageFile,
            soundFile: null,
            organizationId: 5,
            generateSound: true,
          )).called(1);
      expect(result(), created);
    });
  });
}
