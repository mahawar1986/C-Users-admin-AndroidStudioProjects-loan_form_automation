import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/loan_case.dart';
import '../../../data/models/person.dart';
import '../../../data/services/pdf_service.dart';

class GeneratePdfScreen extends StatefulWidget {
  final LoanCase loanCase;
  final List<Person> persons;

  const GeneratePdfScreen({
    super.key,
    required this.loanCase,
    required this.persons,
  });

  @override
  State<GeneratePdfScreen> createState() => _GeneratePdfScreenState();
}

class _GeneratePdfScreenState extends State<GeneratePdfScreen> {
  final _pdfService = PdfService();
  bool _isGenerating = false;
  final Map<String, bool> _selectedPersons = {};

  @override
  void initState() {
    super.initState();
    for (var person in widget.persons) {
      _selectedPersons[person.id] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate PDFs'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Select persons to generate PDFs',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_selectedPersons.values.where((v) => v).length} of ${widget.persons.length} selected',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                ...widget.persons.map((person) => _buildPersonCheckbox(person)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _isGenerating ? null : _generatePdfs,
                  icon: _isGenerating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.picture_as_pdf),
                  label: Text(
                    _isGenerating ? 'Generating PDFs...' : 'Generate PDFs',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonCheckbox(Person person) {
    final roleColor = _getRoleColor(person.role);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: CheckboxListTile(
        value: _selectedPersons[person.id],
        onChanged: (value) {
          setState(() {
            _selectedPersons[person.id] = value ?? false;
          });
        },
        title: Text(
          person.personalDetails.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${_getRoleTitle(person.role)} • ${person.identityDetails.pan}',
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        secondary: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: roleColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getRoleIcon(person.role),
            color: roleColor,
            size: 24,
          ),
        ),
        activeColor: AppTheme.primary,
      ),
    );
  }

  Future<void> _generatePdfs() async {
    final selectedPersons =
        widget.persons.where((p) => _selectedPersons[p.id] == true).toList();

    if (selectedPersons.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one person'),
          backgroundColor: AppTheme.warning,
        ),
      );
      return;
    }

    setState(() => _isGenerating = true);

    try {
      await _pdfService.generatePdfsForPersons(
        widget.loanCase,
        selectedPersons,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${selectedPersons.length} PDF(s) generated successfully'),
            backgroundColor: AppTheme.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  String _getRoleTitle(String role) {
    switch (role) {
      case 'applicant':
        return 'Applicant';
      case 'co_applicant':
        return 'Co-Applicant';
      case 'guarantor':
        return 'Guarantor';
      default:
        return role;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'applicant':
        return Icons.person;
      case 'co_applicant':
        return Icons.people;
      case 'guarantor':
        return Icons.shield;
      default:
        return Icons.person;
    }
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'applicant':
        return AppTheme.primary;
      case 'co_applicant':
        return AppTheme.accent;
      case 'guarantor':
        return Colors.orange.shade300;
      default:
        return AppTheme.textSecondary;
    }
  }
}
