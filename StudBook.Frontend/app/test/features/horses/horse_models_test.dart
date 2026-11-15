import 'package:flutter_test/flutter_test.dart';
import 'package:studbook_app/features/horses/data/models/horse_models.dart';
import 'package:studbook_app/features/horses/domain/entities/horse.dart';

void main() {
  test('parses a horse card with a partial pedigree', () {
    final horse = HorseModels.detailsFromJson({
      'id': 7,
      'name': 'CJ Red Mesa',
      'category': 'OwnStallion',
      'sex': 'Stallion',
      'breed': 'Quarter Horse',
      'color': 'Sorrel',
      'dateOfBirth': '2014-04-02',
      'registrationNumber': 'QH-4471820',
      'ownerClientId': null,
      'ownerName': null,
      'notes': '',
      'isActive': true,
      'pedigree': {
        'sire': {
          'id': 3,
          'name': 'Mesa Cat Doc',
          'sex': 'Stallion',
          'breed': null,
          'dateOfBirth': null,
          'registrationNumber': null,
        },
        'dam': null,
      },
    });

    expect(horse.category, HorseCategory.ownStallion);
    expect(horse.dateOfBirth, DateTime(2014, 4, 2));
    expect(horse.pedigree.sire?.name, 'Mesa Cat Doc');
    expect(horse.pedigree.dam, isNull);
  });

  test('drops the owner for own stallions when serialising a draft', () {
    final json = HorseModels.draftToJson(
      HorseDraft(
        name: ' CJ Brazos Gold ',
        category: HorseCategory.ownStallion,
        sex: HorseSex.stallion,
        breed: 'Quarter Horse',
        color: 'Palomino',
        ownerClientId: 4,
        dateOfBirth: DateTime(2016, 5, 1),
      ),
    );

    expect(json['name'], 'CJ Brazos Gold');
    expect(json['category'], 'OwnStallion');
    expect(json['ownerClientId'], isNull);
    expect(json['registrationNumber'], isNull);
    expect(json['dateOfBirth'], '2016-05-01');
  });
}
