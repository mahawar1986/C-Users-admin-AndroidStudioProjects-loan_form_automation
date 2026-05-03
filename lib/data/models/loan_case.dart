import 'package:cloud_firestore/cloud_firestore.dart';

class LoanCase {
  final String id;
  final String caseNumber;
  final String loanType;
  final String status;
  final String linkToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  LoanCase({
    required this.id,
    required this.caseNumber,
    required this.loanType,
    required this.status,
    required this.linkToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LoanCase.fromMap(Map<String, dynamic> map, String id) {
    return LoanCase(
      id: id,
      caseNumber: map['case_number'] ?? '',
      loanType: map['loan_type'] ?? '',
      status: map['status'] ?? 'active',
      linkToken: map['link_token'] ?? '',
      createdAt: (map['created_at'] as Timestamp).toDate(),
      updatedAt: (map['updated_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'case_number': caseNumber,
      'loan_type': loanType,
      'status': status,
      'link_token': linkToken,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }
}
