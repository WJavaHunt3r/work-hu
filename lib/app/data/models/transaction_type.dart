
enum TransactionType {
  HOURS("Fizetős"),
  CREDIT("Kredit"),
  POINT("Nem Fizetős"),
  BMM_PERFECT_WEEK("BMM"),
  VAER_ET_FORBILDE("BMM"),
  DUKA_MUNKA("Duka munka 1000Ft"),
  DUKA_MUNKA_2000("Duka munka 2000Ft");

  final String name;

  const TransactionType(this.name);
}
