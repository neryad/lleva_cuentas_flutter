// To parse this JSON data, do
//
//     final transactions = transactionsFromJson(jsonString);

import 'dart:convert';

Transactions transactionsFromJson(String str) =>
    Transactions.fromJson(json.decode(str));

String transactionsToJson(Transactions data) => json.encode(data.toJson());

class Transactions {
  Transactions({
    this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.comment,
    required this.accountId,
  });

  int? id;
  String type;
  double amount;
  String date;
  String comment;
  int accountId;
  isSaving() => type == 'Ahorro';
  factory Transactions.fromJson(Map<String, dynamic> json) => Transactions(
        id: json["id"],
        type: json["type"],
        amount: json["amount"].toDouble(),
        date: json["date"],
        comment: json["comment"],
        accountId: json["accountId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "amount": amount,
        "date": date,
        "comment": comment,
        "accountId": accountId,
      };
}
