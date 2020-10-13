import 'package:flutter/material.dart';
import 'package:weekplanner/style/custom_color.dart' as theme;
import 'package:weekplanner/style/font_size.dart';
import 'package:weekplanner/widgets/giraf_app_bar_widget.dart';

/// Screen where the user see their legal rights
class PrivacyInformationScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GirafAppBar(
          title: 'Privatlivsinformation',
        ),
        body: SingleChildScrollView(
            child: Column(
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.all(30.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: myBoxDecoration(),
                      child: RichText(text: const TextSpan(
                        style: TextStyle(color: theme.GirafColors.black,
                            fontFamily: 'Quicksand'),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Oplysninger om vores behandling '
                                  'af dine personoplysninger mv.''\n' '\n',
                              style: TextStyle(fontSize: GirafFont.small,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: '1. Vi er den dataansvarlige '
                                  '– hvordan kontakter du os?' '\n' '\n',
                              style: TextStyle(fontSize: GirafFont.large,
                              fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: 'Girafs Venner er dataansvarlig for '
                                  'behandlingen af de personoplysninger, '
                                  'som vi har modtaget om dig. '
                                  'Du finder vores kontaktoplysninger '
                                  'nedenfor.' '\n' '\n'
                                  '   \u2022 '
                                  'Navn: Girafs Venner'
                                  '\n' '\n'
                                  '   \u2022 '
                                  'Telefon: 40 89 21 56'
                                  '\n' '\n'
                                  '   \u2022 '
                                  'CVR-nr.: 40519025'
                                  '\n' '\n'
                                  '   \u2022 '
                                  'Mail: ulrik@cs.aau.dk' '\n' '\n',
                              style: TextStyle(fontSize: GirafFont.small)),
                          TextSpan(
                              text: '2. Formålene med og retsgrundlaget for '
                                  'behandlingen af dine '
                                  'personoplysninger' '\n' '\n',
                              style: TextStyle(fontSize: GirafFont.small,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: 'Vi behandler dine '
                                  'personoplysninger til følgende '
                                  'formål:' '\n' '\n'
                                  '   \u2022 ' 'Formålet '
                                  'med behandlingen '
                                  'af personlige oplysninger '
                                  'er udelukkende'
                                  ' at tilvejebringe et '
                                  'kommunikationsværktøj til '
                                  'autistiske børn, '
                                  'og medarbejdere til den udbudte '
                                  'institution. Behandlingen '
                                  'er således kun med '
                                  'formål at skabe en '
                                  'personaliseret interaktion, '
                                  'mellem systemet og '
                                  'det enkelte barn, '
                                  'ved at have en '
                                  'systembruger.' '\n' '\n'

                                  '   \u2022 ' 'Legitime '
                                  'interesser, '
                                  'der forfølges med '
                                  'behandlingen.' '\n'
                                  '\n'
                                  'Som nævnt ovenfor '
                                  'sker vores behandling '
                                  'af dine personoplysninger '
                                  'på baggrund af '
                                  'interesseafvejningsreglen '
                                  'i databeskyttelsesforordningens '
                                  'artikel 6, stk. 1, litra f. '
                                  'De legitime interesser, der '
                                  'begrunder behandlingen, er '
                                  'at hjælpe autistiske børn '
                                  'med at kommunikere og skabe '
                                  'struktur i hverdagen gennem '
                                  'et kommunikationsværktøj.' '\n'
                                  '\n',
                              style: TextStyle(fontSize: GirafFont.small)),
                          TextSpan(
                              text: '3. Kategorier af '
                                  'personoplysninger' '\n' '\n',
                              style: TextStyle(fontSize: GirafFont.large,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: 'Vi behandler følgende '
                                  'kategorier af personoplysninger '
                                  'om dig:' '\n'
                                  'Identifikationsoplysninger:' '\n'
                                  '\n'
                                  '   \u2022 ' 'Almindelige '
                                  'personoplysninger'
                                  '\n' '\n',
                              style: TextStyle(fontSize: GirafFont.small)),
                          TextSpan(
                              text: '4. Hvor dine '
                                  'personoplysninger stammer '
                                  'fra' '\n' '\n',
                              style: TextStyle(fontSize: GirafFont.large,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: 'Personoplysningerne stammer '
                                  'fra registreringen af brugeren '
                                  'i applikationen.' '\n' '\n',
                              style: TextStyle(fontSize: GirafFont.small)),
                          TextSpan(
                              text: '5. Opbevaring af '
                                  'dine personoplysninger' '\n'
                                  '\n',
                              style: TextStyle(fontSize: GirafFont.large,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: 'Personlige oplysninger '
                                  'slettes 1 år efter, at '
                                  'brugeren er erklæret inaktiv,'
                                  ' hvilket afhængigt af '
                                  'institutionen enten kan være et '
                                  'aktivt valg foretaget af '
                                  'institutionen eller som resultat '
                                  'af manglende anvendelse af '
                                  'systemet.' '\n' '\n',
                              style: TextStyle(fontSize: GirafFont.small)),
                          TextSpan(
                              text: '6. Retten til at '
                                  'trække samtykke tilbage'
                                  '\n' '\n',
                              style: TextStyle(fontSize: GirafFont.large,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: 'Du har til enhver tid ret '
                                  'til at trække dit samtykke tilbage. '
                                  'Dette kan du gøre ved at kontakte '
                                  'os på de kontaktoplysninger, der'
                                  ' fremgår ovenfor i punkt 1. Hvis'
                                  ' du vælger at trække dit samtykke'
                                  ' tilbage, påvirker det ikke '
                                  'lovligheden af vores behandling'
                                  ' af dine personoplysninger på'
                                  ' baggrund af dit tidligere '
                                  'meddelte samtykke og op til tidspunktet'
                                  ' for tilbagetrækningen. '
                                  'Hvis du tilbagetrækker'
                                  ' dit samtykke, har det '
                                  'derfor først virkning '
                                  'fra dette tidspunkt.' '\n' '\n',
                              style: TextStyle(fontSize: GirafFont.small)),
                          TextSpan(text: '7. Dine rettigheder' '\n' '\n',
                              style: TextStyle(fontSize: GirafFont.large,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: 'Du har efter '
                                  'databeskyttelsesforordningen en '
                                  'række rettigheder i '
                                  'forhold til vores behandling '
                                  'af oplysninger om dig. '
                                  'Hvis du vil gøre brug af '
                                  'dine rettigheder skal '
                                  'du kontakte os.' '\n' '\n'
                                  '   \u2022 ' 'Ret til '
                                  'at se oplysninger (indsigtsret)'
                                  '\n' '\n'
                                  '   \u2022 ' 'Du har '
                                  'ret til at få indsigt'
                                  ' i de oplysninger, '
                                  'som vi behandler om dig, '
                                  'samt en række yderligere '
                                  'oplysninger.' '\n' '\n'
                                  '   \u2022 ' 'Ret til '
                                  'berigtigelse (rettelse). '
                                  'Du har ret til at få urigtige '
                                  'oplysninger om dig selv '
                                  'rettet.' '\n' '\n',
                              style: TextStyle(fontSize: GirafFont.small)),
                          TextSpan(
                              text: '   \u2022 '
                                  'Ret til sletning. I særlige'
                                  ' tilfælde har du ret til at '
                                  'få slettet oplysninger om dig, '
                                  'inden tidspunktet for vores '
                                  'almindelige generelle '
                                  'sletning indtræffer.'
                                  '\n' '\n'
                                  '   \u2022 '
                                  'Ret til begrænsning af behandling. '
                                  'Du har visse tilfælde ret til at få '
                                  'behandlingen af dine personoplysninger '
                                  'begrænset. Hvis du har ret '
                                  'til at få begrænset behandlingen,'
                                  ' må vi fremover kun behandle '
                                  'oplysningerne – bortset fra opbevaring '
                                  '– med dit samtykke, eller med henblik '
                                  'på at retskrav kan fastlægges, '
                                  'gøres gældende eller forsvares, '
                                  'eller for at beskytte en person'
                                  ' eller vigtige '
                                  'samfundsinteresser.' '\n' '\n'
                                  '   \u2022 '
                                  'Ret til indsigelse. '
                                  'Du har i visse tilfælde '
                                  'ret til at gøre indsigelse '
                                  'mod vores eller lovlige '
                                  'behandling af dine '
                                  'personoplysninger. '
                                  'Du kan også gøre indsigelse '
                                  'mod behandling af dine '
                                  'oplysninger til direkte '
                                  'markedsføring.' '\n' '\n'
                                  '   \u2022 '
                                  'Ret til at transmittere '
                                  'oplysninger (dataportabilitet). '
                                  'Du har i visse tilfælde '
                                  'ret til at modtage dine '
                                  'personoplysninger i et '
                                  'struktureret, almindeligt '
                                  'anvendt og maskinlæsbart '
                                  'format samt at få overført '
                                  'disse personoplysninger '
                                  'fra én dataansvarlig '
                                  'til en anden uden '
                                  'hindring.' '\n' '\n'
                                  'Du kan læse mere om dine '
                                  'rettigheder i Datatilsynets'
                                  ' vejledning om de '
                                  'registreredes rettigheder, '
                                  'som du finder på '
                                  'www.datatilsynet.dk.' '\n' '\n',
                              style: TextStyle(fontSize: GirafFont.small)),
                          TextSpan(text: '8. Klage til Datatilsynet'
                              '\n' '\n',
                              style: TextStyle(fontSize: GirafFont.large,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: 'Du har ret til at '
                                  'indgive en klage til Datatilsynet, '
                                  'hvis du er utilfreds med '
                                  'den måde, vi behandler dine '
                                  'personoplysninger på. '
                                  'Du finder Datatilsynets '
                                  'kontaktoplysninger på '
                                  'www.datatilsynet.dk.' '\n' '\n',
                              style: TextStyle(fontSize: GirafFont.small)),


                        ],
                      ),
                      ))
                ])
        ));
  }

/// Box to make it look nicer
  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: theme.GirafColors.appBarOrange,
        //
        width: 5, //
      ),
      borderRadius: const BorderRadius.all(
          Radius.circular(15.0) //         <--- border radius here
      ),
    );
  }
}


