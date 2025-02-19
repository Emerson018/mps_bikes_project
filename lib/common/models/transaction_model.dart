// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TransactionModel {
  final double value;
  final int date;

  final String? category;
  final bool? status;
  String? id;
  final String description;

  TransactionModel({
    required this.value,
    required this.date,

    this.category,
    this.status,
    this.id,
    required this.description,
  });

  // Converte para Map para salvar no Firestore
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'value': value,
      'date': date,
      'category': category,
      'status': status,
      'id': id,
      'description': description,
    };
  }

  // TRANSACTION MODEL onde os valores são obrigatórios
  /*factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      title: map['title'] as String,
      value: map['value'] as double,
      date: map['date'] as int,
      category: map['category'] as String,
      status: map['status'] as bool,
      id: map['id'] != null ? map['id'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
    );
  }*/

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
  return TransactionModel(
    value: (map['value'] as num).toDouble(),
    date: map['date'] as int,
    category: map['category'] != null ? map['category'] as String : 'Categoria Padrão',
    status: map['status'] != null ? map['status'] as bool : false,
    id: map['id'] as String?, // Pode permanecer nulo
    description: map['description'] != null ? map['description'] as String : 'Sem título',
  );
}


  TransactionModel copyWith({
    double? value,
    int? date,
    String? category,
    bool? status,
    String? id,
    String? description,
  }) {
    return TransactionModel(
      value: value ?? this.value,
      date: date ?? this.date,
      
      category: category ?? this.category,
      status: status ?? this.status,
      id: id ?? this.id,
      description: description ?? this.description,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionModel.fromJson(String source) => TransactionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TransactionModel( value: $value, date: $date, category: $category, status: $status, id: $id, description: $description)';
  }

  @override
  bool operator ==(covariant TransactionModel other) {
    if (identical(this, other)) return true;
  
    return 

      other.value == value &&
      other.date == date &&
      other.category == category &&
      other.status == status &&
      other.id == id &&
      other.description == description;
  }

  @override
  int get hashCode {
    return 
      value.hashCode ^
      date.hashCode ^
      category.hashCode ^
      status.hashCode ^
      id.hashCode ^
      description.hashCode;
  }
}

