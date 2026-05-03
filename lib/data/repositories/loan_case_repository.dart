import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/loan_case.dart';

class LoanCaseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  Future<String> createLoanCase(String loanType) async {
    final linkToken = _uuid.v4().substring(0, 8);
    final now = DateTime.now();
    final caseNumber =
        'LC${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${linkToken.substring(0, 4).toUpperCase()}';

    final loanCase = LoanCase(
      id: '',
      caseNumber: caseNumber,
      loanType: loanType,
      status: 'active',
      linkToken: linkToken,
      createdAt: now,
      updatedAt: now,
    );

    final docRef =
        await _firestore.collection('loan_cases').add(loanCase.toMap());
    return docRef.id;
  }

  Future<LoanCase?> getLoanCase(String id) async {
    final doc = await _firestore.collection('loan_cases').doc(id).get();
    if (doc.exists) {
      return LoanCase.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<LoanCase?> getLoanCaseByToken(String token) async {
    final query = await _firestore
        .collection('loan_cases')
        .where('link_token', isEqualTo: token)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      return LoanCase.fromMap(query.docs.first.data(), query.docs.first.id);
    }
    return null;
  }

  Stream<List<LoanCase>> getAllLoanCases() {
    return _firestore
        .collection('loan_cases')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => LoanCase.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  String generateLink(String token) {
    // TODO: Replace with your deployed URL
    return 'https://loan-form-app.web.app/form/$token';
  }
}
