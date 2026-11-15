import '../../../core/theme/extensions/status_colors.dart';
import '../../../core/utils/date_format.dart';
import '../domain/entities/horse.dart';

abstract final class HorseStrings {
  static const registry = 'Registry';
  static const registryTitle = 'Horse registry';
  static const registryOverline = 'Circle-J Ranch · Stud book';
  static const registrySubtitle = 'Own and managed stallions, and every client horse on our books.';
  static const addHorse = 'Add horse';
  static const all = 'All';
  static const searchHint = 'Name, reg. no. or owner';
  static const searchLabel = 'Search registry';
  static const columnHorse = 'Horse';
  static const columnCategory = 'Category';
  static const columnBreed = 'Breed · Colour';
  static const columnOwner = 'Owner';
  static const columnFoaled = 'Foaled';
  static const open = 'Open';
  static const edit = 'Edit';
  static const sortedBy = 'Sorted by category, then name';
  static const emptyTitle = 'No horses here yet';
  static const emptyMessage = 'Add a horse to start this part of the registry.';
  static const noMatchesTitle = 'Nothing matches the search';
  static const noMatchesMessage = 'Try a different name, registration number or owner.';
  static const none = '—';
  static const ranchOwner = 'Circle-J Ranch';

  static const sex = 'Sex';
  static const breed = 'Breed';
  static const color = 'Colour';
  static const foaled = 'Foaled';
  static const registration = 'Registration no.';
  static const owner = 'Owner';
  static const status = 'Status';
  static const notes = 'Notes';
  static const noNotes = 'No notes yet.';
  static const active = 'In registry';
  static const inactive = 'Removed from registry';
  static const details = 'Record';
  static const pedigree = 'Pedigree, two generations';
  static const pedigreeHint = 'Open any ancestor to see their own record.';
  static const horseColumn = 'Horse';
  static const parentsColumn = 'Parents';
  static const grandparentsColumn = 'Grandparents';
  static const sire = 'Sire';
  static const dam = 'Dam';
  static const paternalGrandsire = 'Sire’s sire';
  static const paternalGranddam = 'Sire’s dam';
  static const maternalGrandsire = 'Dam’s sire';
  static const maternalGranddam = 'Dam’s dam';
  static const unknown = 'Unknown';
  static const remove = 'Remove from registry';
  static const removeTitle = 'Remove this horse from the registry?';
  static const removeMessage =
      'The record stays in the database for pedigrees, but the horse will no longer be listed in the registry.';
  static const cancel = 'Cancel';
  static const removed = 'Removed from the registry';
  static const notFound = 'This horse is not in the stud book.';

  static const addTitle = 'Add horse';
  static const addSubtitle = 'New entry in the stud book with its origin.';
  static const editTitle = 'Edit horse';
  static const save = 'Save horse';
  static const saveChanges = 'Save changes';
  static const saved = 'Horse saved';
  static const saveFailed = 'Could not save the horse';
  static const sectionIdentity = 'Identity';
  static const sectionOwnership = 'Ownership';
  static const sectionPedigree = 'Origin';
  static const sectionNotes = 'Notes';
  static const name = 'Horse name';
  static const nameHint = 'e.g. Sierra Bluebonnet';
  static const nameHelper = 'As registered with the breed association';
  static const categoryField = 'Category';
  static const breedHint = 'Quarter Horse';
  static const colorHint = 'Bay';
  static const registrationHint = 'QH-5203348';
  static const registrationHelper = 'Optional, must be unique';
  static const foaledHint = 'Pick a date';
  static const clearDate = 'Clear date';
  static const ownerHint = 'Select an owner';
  static const ownerHelperOwn = 'Own stallions always belong to the ranch';
  static const ownerHelperClient = 'Client or stable that owns the horse';
  static const notSpecified = 'Not specified';
  static const sireHelper = 'Stallions from the registry';
  static const damHelper = 'Mares from the registry';
  static const notesHint = 'Anything the team should know about this horse';
  static const required = 'Required';
  static const optionsFailed = 'Owners and parents could not be loaded';

  static String horsesCount(int shown, int total) =>
      shown == total ? '$total horses' : '$shown of $total horses';

  static String category(HorseCategory value) => switch (value) {
    HorseCategory.ownStallion => 'Own stallion',
    HorseCategory.managedStallion => 'Managed stallion',
    HorseCategory.clientHorse => 'Client horse',
    HorseCategory.ancestor => 'Ancestor',
  };

  static String categoryPlural(HorseCategory value) => switch (value) {
    HorseCategory.ownStallion => 'Own stallions',
    HorseCategory.managedStallion => 'Managed stallions',
    HorseCategory.clientHorse => 'Client horses',
    HorseCategory.ancestor => 'Ancestors',
  };

  static String sexLabel(HorseSex value) => switch (value) {
    HorseSex.stallion => 'Stallion',
    HorseSex.mare => 'Mare',
    HorseSex.gelding => 'Gelding',
  };

  static AppTone categoryTone(HorseCategory value) => switch (value) {
    HorseCategory.ownStallion => AppTone.primary,
    HorseCategory.managedStallion => AppTone.info,
    HorseCategory.clientHorse => AppTone.secondary,
    HorseCategory.ancestor => AppTone.neutral,
  };

  static String meta({String? registration, required HorseSex sex, DateTime? born}) =>
      [?registration, sexLabel(sex), if (born != null) AppDateFormat.year(born)].join(' · ');

  static String orNone(String? value) => value == null || value.isEmpty ? none : value;
}
