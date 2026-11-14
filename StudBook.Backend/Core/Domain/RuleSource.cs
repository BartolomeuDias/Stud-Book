namespace StudBook.Domain;
 
/// <summary>Происхождение правила (устав, А-9): рабочий набор команды или согласовано заказчиком и ветеринаром.</summary>
public enum RuleSource
{
    TeamDraft,
    CustomerConfirmed
}