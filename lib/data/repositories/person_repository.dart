import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/person.dart';

class PersonRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitPerson(Person person) async {
    await _firestore.collection('persons').add(person.toMap());
  }

  Future<List<Person>> getPersonsForCase(String loanCaseId) async {
    final query = await _firestore
        .collection('persons')
        .where('loan_case_id', isEqualTo: loanCaseId)
        .get();

    return query.docs.map((doc) => Person.fromMap(doc.data(), doc.id)).toList();
  }

  Future<List<Person>> getPersonsByRole(String loanCaseId, String role) async {
    final query = await _firestore
        .collection('persons')
        .where('loan_case_id', isEqualTo: loanCaseId)
        .where('role', isEqualTo: role)
        .get();

    return query.docs.map((doc) => Person.fromMap(doc.data(), doc.id)).toList();
  }
}
