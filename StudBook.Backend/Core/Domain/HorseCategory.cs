namespace StudBook.Domain;
 
public enum HorseCategory
{
    /// <summary>Собственный жеребец-производитель ранчо.</summary>
    OwnStallion,
 
    /// <summary>Жеребец клиента, находящийся на управлении ранчо.</summary>
    ManagedStallion,
 
    /// <summary>Лошадь клиента: кобыла, жеребёнок и т.п.</summary>
    ClientHorse,
 
    /// <summary>Справочная запись о предке (не на ранчо), нужна только для родословной и проверки родства.</summary>
    Ancestor
}