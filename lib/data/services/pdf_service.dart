import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/loan_case.dart';
import '../models/person.dart';

class PdfService {
  Future<void> generatePdfsForPersons(
    LoanCase loanCase,
    List<Person> persons,
  ) async {
    for (var person in persons) {
      await generatePdfForPerson(loanCase, person);
    }
  }

  Future<void> generatePdfForPerson(LoanCase loanCase, Person person) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => _buildPdfContent(loanCase, person),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: '${person.personalDetails.name}_${person.role}.pdf',
    );
  }

  pw.Widget _buildPdfContent(LoanCase loanCase, Person person) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildHeader(loanCase),
        pw.SizedBox(height: 20),
        _buildSection('PERSONAL DETAILS', [
          _buildRow('Name', person.personalDetails.name),
          _buildRow('Gender', person.personalDetails.gender),
          _buildRow(
            'Date of Birth',
            _formatDate(person.personalDetails.dateOfBirth),
          ),
          _buildRow('Age', '${person.personalDetails.age} years'),
          _buildRow('Marital Status', person.personalDetails.maritalStatus),
          _buildRow('Father Name', person.personalDetails.fatherName),
          _buildRow('Mother Name', person.personalDetails.motherName),
        ]),
        pw.SizedBox(height: 20),
        _buildSection('CONTACT DETAILS', [
          _buildRow('Mobile', person.contactDetails.mobile),
          _buildRow('Email', person.contactDetails.email),
          _buildRow('Present Address', person.contactDetails.presentAddress),
        ]),
        pw.SizedBox(height: 20),
        _buildSection('IDENTITY DETAILS', [
          _buildRow('PAN Number', person.identityDetails.pan),
          _buildRow('Aadhar Number', person.identityDetails.aadhar),
        ]),
        pw.Spacer(),
        _buildFooter(person),
      ],
    );
  }

  pw.Widget _buildHeader(LoanCase loanCase) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        border: pw.Border.all(color: PdfColors.blue),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'LOAN APPLICATION FORM',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Case: ${loanCase.caseNumber}',
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.Text(
            'Type: ${loanCase.loanType}',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSection(String title, List<pw.Widget> children) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: const pw.BoxDecoration(color: PdfColors.blue100),
          child: pw.Text(
            title,
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(height: 10),
        ...children,
      ],
    );
  }

  pw.Widget _buildRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 150,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            child: pw.Text(value, style: const pw.TextStyle(fontSize: 10)),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(Person person) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey)),
      ),
      child: pw.Text(
        'Submitted: ${_formatDate(person.submittedAt)}',
        style: const pw.TextStyle(fontSize: 9),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
