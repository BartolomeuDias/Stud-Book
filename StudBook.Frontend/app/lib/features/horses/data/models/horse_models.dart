import '../../../../core/utils/date_format.dart';
import '../../domain/entities/horse.dart';

abstract final class HorseCodec {
  static const _categories = {
    'OwnStallion': HorseCategory.ownStallion,
    'ManagedStallion': HorseCategory.managedStallion,
    'ClientHorse': HorseCategory.clientHorse,
    'Ancestor': HorseCategory.ancestor,
  };

  static const _sexes = {
    'Stallion': HorseSex.stallion,
    'Mare': HorseSex.mare,
    'Gelding': HorseSex.gelding,
  };

  static HorseCategory category(String value) =>
      _categories[value] ?? (throw FormatException('Unknown category: $value'));

  static HorseSex sex(String value) =>
      _sexes[value] ?? (throw FormatException('Unknown sex: $value'));

  static String encodeCategory(HorseCategory value) =>
      _categories.entries.firstWhere((entry) => entry.value == value).key;

  static String encodeSex(HorseSex value) =>
      _sexes.entries.firstWhere((entry) => entry.value == value).key;
}

abstract final class _Keys {
  static const id = 'id';
  static const name = 'name';
  static const category = 'category';
  static const sex = 'sex';
  static const breed = 'breed';
  static const color = 'color';
  static const dateOfBirth = 'dateOfBirth';
  static const registrationNumber = 'registrationNumber';
  static const ownerName = 'ownerName';
  static const ownerClientId = 'ownerClientId';
  static const notes = 'notes';
  static const isActive = 'isActive';
  static const pedigree = 'pedigree';
  static const sire = 'sire';
  static const dam = 'dam';
  static const sireId = 'sireId';
  static const damId = 'damId';
  static const paternalGrandsire = 'paternalGrandsire';
  static const paternalGranddam = 'paternalGranddam';
  static const maternalGrandsire = 'maternalGrandsire';
  static const maternalGranddam = 'maternalGranddam';
}

abstract final class HorseModels {
  static HorseSummary summaryFromJson(Map<String, dynamic> json) => HorseSummary(
    id: json[_Keys.id] as int,
    name: json[_Keys.name] as String,
    category: HorseCodec.category(json[_Keys.category] as String),
    sex: HorseCodec.sex(json[_Keys.sex] as String),
    breed: json[_Keys.breed] as String? ?? '',
    color: json[_Keys.color] as String? ?? '',
    dateOfBirth: AppDateFormat.parseApi(json[_Keys.dateOfBirth] as String?),
    registrationNumber: json[_Keys.registrationNumber] as String?,
    ownerName: json[_Keys.ownerName] as String?,
  );

  static HorseDetails detailsFromJson(Map<String, dynamic> json) => HorseDetails(
    id: json[_Keys.id] as int,
    name: json[_Keys.name] as String,
    category: HorseCodec.category(json[_Keys.category] as String),
    sex: HorseCodec.sex(json[_Keys.sex] as String),
    breed: json[_Keys.breed] as String? ?? '',
    color: json[_Keys.color] as String? ?? '',
    notes: json[_Keys.notes] as String? ?? '',
    isActive: json[_Keys.isActive] as bool? ?? true,
    dateOfBirth: AppDateFormat.parseApi(json[_Keys.dateOfBirth] as String?),
    registrationNumber: json[_Keys.registrationNumber] as String?,
    ownerClientId: json[_Keys.ownerClientId] as int?,
    ownerName: json[_Keys.ownerName] as String?,
    pedigree: _pedigree(json[_Keys.pedigree] as Map<String, dynamic>?),
  );

  static Map<String, dynamic> draftToJson(HorseDraft draft) {
    final registration = draft.registrationNumber.trim();
    return {
      _Keys.name: draft.name.trim(),
      _Keys.category: HorseCodec.encodeCategory(draft.category),
      _Keys.sex: HorseCodec.encodeSex(draft.sex),
      _Keys.breed: draft.breed.trim(),
      _Keys.color: draft.color.trim(),
      _Keys.dateOfBirth: AppDateFormat.toApi(draft.dateOfBirth),
      _Keys.registrationNumber: registration.isEmpty ? null : registration,
      _Keys.ownerClientId: draft.category.requiresOwner ? draft.ownerClientId : null,
      _Keys.sireId: draft.sireId,
      _Keys.damId: draft.damId,
      _Keys.notes: draft.notes.trim(),
    };
  }

  static Pedigree _pedigree(Map<String, dynamic>? json) {
    if (json == null) return const Pedigree();
    PedigreeNode? node(String key) {
      final value = json[key] as Map<String, dynamic>?;
      if (value == null) return null;
      return PedigreeNode(
        id: value[_Keys.id] as int,
        name: value[_Keys.name] as String,
        sex: HorseCodec.sex(value[_Keys.sex] as String),
        breed: value[_Keys.breed] as String?,
        dateOfBirth: AppDateFormat.parseApi(value[_Keys.dateOfBirth] as String?),
        registrationNumber: value[_Keys.registrationNumber] as String?,
      );
    }

    return Pedigree(
      sire: node(_Keys.sire),
      dam: node(_Keys.dam),
      paternalGrandsire: node(_Keys.paternalGrandsire),
      paternalGranddam: node(_Keys.paternalGranddam),
      maternalGrandsire: node(_Keys.maternalGrandsire),
      maternalGranddam: node(_Keys.maternalGranddam),
    );
  }
}
