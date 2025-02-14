class TransactionModel {
  final String title;
  final double value;
  final int date;

  TransactionModel({
    required this.title,
    required this.value,
    required this.date,
  });

  // Converte para Map para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'value': value,
      'date': date,
    };
  }

  // Cria TransactionModel a partir de um Map do Firestore
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      title: map['title'],
      value: (map['value'] as num).toDouble(),
      date: map['date'],
    );
  }
}

