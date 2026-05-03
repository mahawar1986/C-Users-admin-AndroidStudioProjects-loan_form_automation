import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  final String id;
  final String loanCaseId;
  final String role;
  final DateTime submittedAt;

  final PersonalDetails personalDetails;
  final ContactDetails contactDetails;
  final IdentityDetails identityDetails;
  final OccupationDetails occupationDetails;

  Person({
    required this.id,
    required this.loanCaseId,
    required this.role,
    required this.submittedAt,
    required this.personalDetails,
    required this.contactDetails,
    required this.identityDetails,
    required this.occupationDetails,
  });

  factory Person.fromMap(Map<String, dynamic> map, String id) {
    return Person(
      id: id,
      loanCaseId: map['loan_case_id'] ?? '',
      role: map['role'] ?? '',
      submittedAt: (map['submitted_at'] as Timestamp).toDate(),
      personalDetails: PersonalDetails.fromMap(map['personal_details'] ?? {}),
      contactDetails: ContactDetails.fromMap(map['contact_details'] ?? {}),
      identityDetails: IdentityDetails.fromMap(map['identity_details'] ?? {}),
      occupationDetails: OccupationDetails.fromMap(
        map['occupation_details'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'loan_case_id': loanCaseId,
      'role': role,
      'submitted_at': Timestamp.fromDate(submittedAt),
      'personal_details': personalDetails.toMap(),
      'contact_details': contactDetails.toMap(),
      'identity_details': identityDetails.toMap(),
      'occupation_details': occupationDetails.toMap(),
    };
  }
}

class PersonalDetails {
  final String name;
  final String gender;
  final DateTime dateOfBirth;
  final int age;
  final String maritalStatus;
  final String fatherName;
  final String motherName;

  PersonalDetails({
    required this.name,
    required this.gender,
    required this.dateOfBirth,
    required this.age,
    required this.maritalStatus,
    required this.fatherName,
    required this.motherName,
  });

  factory PersonalDetails.fromMap(Map<String, dynamic> map) {
    return PersonalDetails(
      name: map['name'] ?? '',
      gender: map['gender'] ?? '',
      dateOfBirth: map['date_of_birth'] != null
          ? (map['date_of_birth'] as Timestamp).toDate()
          : DateTime.now(),
      age: map['age'] ?? 0,
      maritalStatus: map['marital_status'] ?? '',
      fatherName: map['father_name'] ?? '',
      motherName: map['mother_name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'date_of_birth': Timestamp.fromDate(dateOfBirth),
      'age': age,
      'marital_status': maritalStatus,
      'father_name': fatherName,
      'mother_name': motherName,
    };
  }
}

class ContactDetails {
  final String mobile;
  final String email;
  final String presentAddress;
  final String permanentAddress;

  ContactDetails({
    required this.mobile,
    required this.email,
    required this.presentAddress,
    required this.permanentAddress,
  });

  factory ContactDetails.fromMap(Map<String, dynamic> map) {
    return ContactDetails(
      mobile: map['mobile'] ?? '',
      email: map['email'] ?? '',
      presentAddress: map['present_address'] ?? '',
      permanentAddress: map['permanent_address'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mobile': mobile,
      'email': email,
      'present_address': presentAddress,
      'permanent_address': permanentAddress,
    };
  }
}

class IdentityDetails {
  final String pan;
  final String aadhar;
  final String passport;
  final String drivingLicense;

  IdentityDetails({
    required this.pan,
    required this.aadhar,
    required this.passport,
    required this.drivingLicense,
  });

  factory IdentityDetails.fromMap(Map<String, dynamic> map) {
    return IdentityDetails(
      pan: map['pan'] ?? '',
      aadhar: map['aadhar'] ?? '',
      passport: map['passport'] ?? '',
      drivingLicense: map['driving_license'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pan': pan,
      'aadhar': aadhar,
      'passport': passport,
      'driving_license': drivingLicense,
    };
  }
}

class OccupationDetails {
  final String type;
  final String employerName;
  final String designation;
  final String totalExperience;
  final double grossIncome;
  final double netIncome;

  OccupationDetails({
    required this.type,
    required this.employerName,
    required this.designation,
    required this.totalExperience,
    required this.grossIncome,
    required this.netIncome,
  });

  factory OccupationDetails.fromMap(Map<String, dynamic> map) {
    return OccupationDetails(
      type: map['type'] ?? '',
      employerName: map['employer_name'] ?? '',
      designation: map['designation'] ?? '',
      totalExperience: map['total_experience'] ?? '',
      grossIncome: (map['gross_income'] ?? 0).toDouble(),
      netIncome: (map['net_income'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'employer_name': employerName,
      'designation': designation,
      'total_experience': totalExperience,
      'gross_income': grossIncome,
      'net_income': netIncome,
    };
  }
}
