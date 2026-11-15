import 'package:equatable/equatable.dart';

enum HorseCategory { ownStallion, managedStallion, clientHorse, ancestor }

enum HorseSex { stallion, mare, gelding }

extension HorseCategoryRules on HorseCategory {
  static const registry = [
    HorseCategory.ownStallion,
    HorseCategory.managedStallion,
    HorseCategory.clientHorse,
  ];

  bool get requiresOwner =>
      this == HorseCategory.managedStallion || this == HorseCategory.clientHorse;
}

class HorseSummary extends Equatable {
  const HorseSummary({
    required this.id,
    required this.name,
    required this.category,
    required this.sex,
    required this.breed,
    required this.color,
    this.dateOfBirth,
    this.registrationNumber,
    this.ownerName,
  });

  final int id;
  final String name;
  final HorseCategory category;
  final HorseSex sex;
  final String breed;
  final String color;
  final DateTime? dateOfBirth;
  final String? registrationNumber;
  final String? ownerName;

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    sex,
    breed,
    color,
    dateOfBirth,
    registrationNumber,
    ownerName,
  ];
}

class PedigreeNode extends Equatable {
  const PedigreeNode({
    required this.id,
    required this.name,
    required this.sex,
    this.breed,
    this.dateOfBirth,
    this.registrationNumber,
  });

  final int id;
  final String name;
  final HorseSex sex;
  final String? breed;
  final DateTime? dateOfBirth;
  final String? registrationNumber;

  @override
  List<Object?> get props => [id, name, sex, breed, dateOfBirth, registrationNumber];
}

class Pedigree extends Equatable {
  const Pedigree({
    this.sire,
    this.dam,
    this.paternalGrandsire,
    this.paternalGranddam,
    this.maternalGrandsire,
    this.maternalGranddam,
  });

  final PedigreeNode? sire;
  final PedigreeNode? dam;
  final PedigreeNode? paternalGrandsire;
  final PedigreeNode? paternalGranddam;
  final PedigreeNode? maternalGrandsire;
  final PedigreeNode? maternalGranddam;

  @override
  List<Object?> get props => [
    sire,
    dam,
    paternalGrandsire,
    paternalGranddam,
    maternalGrandsire,
    maternalGranddam,
  ];
}

class HorseDetails extends Equatable {
  const HorseDetails({
    required this.id,
    required this.name,
    required this.category,
    required this.sex,
    required this.breed,
    required this.color,
    required this.notes,
    required this.isActive,
    required this.pedigree,
    this.dateOfBirth,
    this.registrationNumber,
    this.ownerClientId,
    this.ownerName,
  });

  final int id;
  final String name;
  final HorseCategory category;
  final HorseSex sex;
  final String breed;
  final String color;
  final String notes;
  final bool isActive;
  final Pedigree pedigree;
  final DateTime? dateOfBirth;
  final String? registrationNumber;
  final int? ownerClientId;
  final String? ownerName;

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    sex,
    breed,
    color,
    notes,
    isActive,
    pedigree,
    dateOfBirth,
    registrationNumber,
    ownerClientId,
    ownerName,
  ];
}

class HorseDraft extends Equatable {
  const HorseDraft({
    this.name = '',
    this.category = HorseCategory.clientHorse,
    this.sex = HorseSex.mare,
    this.breed = '',
    this.color = '',
    this.notes = '',
    this.dateOfBirth,
    this.registrationNumber = '',
    this.ownerClientId,
    this.sireId,
    this.damId,
  });

  factory HorseDraft.fromDetails(HorseDetails horse) => HorseDraft(
    name: horse.name,
    category: horse.category,
    sex: horse.sex,
    breed: horse.breed,
    color: horse.color,
    notes: horse.notes,
    dateOfBirth: horse.dateOfBirth,
    registrationNumber: horse.registrationNumber ?? '',
    ownerClientId: horse.ownerClientId,
    sireId: horse.pedigree.sire?.id,
    damId: horse.pedigree.dam?.id,
  );

  final String name;
  final HorseCategory category;
  final HorseSex sex;
  final String breed;
  final String color;
  final String notes;
  final DateTime? dateOfBirth;
  final String registrationNumber;
  final int? ownerClientId;
  final int? sireId;
  final int? damId;

  HorseDraft copyWith({
    String? name,
    HorseCategory? category,
    HorseSex? sex,
    String? breed,
    String? color,
    String? notes,
    DateTime? Function()? dateOfBirth,
    String? registrationNumber,
    int? Function()? ownerClientId,
    int? Function()? sireId,
    int? Function()? damId,
  }) => HorseDraft(
    name: name ?? this.name,
    category: category ?? this.category,
    sex: sex ?? this.sex,
    breed: breed ?? this.breed,
    color: color ?? this.color,
    notes: notes ?? this.notes,
    dateOfBirth: dateOfBirth == null ? this.dateOfBirth : dateOfBirth(),
    registrationNumber: registrationNumber ?? this.registrationNumber,
    ownerClientId: ownerClientId == null ? this.ownerClientId : ownerClientId(),
    sireId: sireId == null ? this.sireId : sireId(),
    damId: damId == null ? this.damId : damId(),
  );

  @override
  List<Object?> get props => [
    name,
    category,
    sex,
    breed,
    color,
    notes,
    dateOfBirth,
    registrationNumber,
    ownerClientId,
    sireId,
    damId,
  ];
}
