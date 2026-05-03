import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/loan_case.dart';
import '../../../data/models/person.dart';
import '../../../data/repositories/loan_case_repository.dart';
import '../../../data/repositories/person_repository.dart';
import 'generate_pdf_screen.dart';

class CaseDetailsScreen extends StatefulWidget {
  final LoanCase loanCase;

  const CaseDetailsScreen({super.key, required this.loanCase});

  @override
  State<CaseDetailsScreen> createState() => _CaseDetailsScreenState();
}

class _CaseDetailsScreenState extends State<CaseDetailsScreen> {
  final _personRepository = PersonRepository();
  final _loanCaseRepository = LoanCaseRepository();

  List<Person> _persons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPersons();
  }

  Future<void> _loadPersons() async {
    setState(() => _isLoading = true);
    try {
      final persons = await _personRepository.getPersonsForCase(
        widget.loanCase.id,
      );
      setState(() {
        _persons = persons;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Case Details')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPersons,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildCaseInfoCard(),
                  const SizedBox(height: 16),
                  _buildLinkCard(),
                  const SizedBox(height: 16),
                  _buildSubmissionsSection(),
                  const SizedBox(height: 24),
                  if (_persons.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GeneratePdfScreen(
                                loanCase: widget.loanCase,
                                persons: _persons,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text(
                          'Generate PDFs',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }

  Widget _buildCaseInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Case Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
            const Divider(height: 24),
            _buildInfoRow('Case Number', widget.loanCase.caseNumber),
            const SizedBox(height: 12),
            _buildInfoRow('Loan Type', widget.loanCase.loanType),
            const SizedBox(height: 12),
            _buildInfoRow('Status', widget.loanCase.status.toUpperCase()),
            const SizedBox(height: 12),
            _buildInfoRow('Created', _formatDate(widget.loanCase.createdAt)),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkCard() {
    final link = _loanCaseRepository.generateLink(widget.loanCase.linkToken);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Application Link',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
            const Divider(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primaryLight),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      link,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: AppTheme.primary),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: link));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Link copied to clipboard'),
                          backgroundColor: AppTheme.success,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  SharePlus.instance.share(ShareParams(text: link));
                },
                icon: const Icon(Icons.share),
                label: const Text('Share Link'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmissionsSection() {
    final applicants = _persons.where((p) => p.role == 'applicant').toList();
    final coApplicants =
        _persons.where((p) => p.role == 'co_applicant').toList();
    final guarantors = _persons.where((p) => p.role == 'guarantor').toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Submissions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_persons.length} Total',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accent,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            if (_persons.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64,
                        color: AppTheme.textHint,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No submissions yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Share the link to collect applications',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              if (applicants.isNotEmpty) ...[
                _buildRoleSection(
                  'Applicants',
                  applicants,
                  Icons.person,
                  AppTheme.primary,
                ),
                const SizedBox(height: 16),
              ],
              if (coApplicants.isNotEmpty) ...[
                _buildRoleSection(
                  'Co-Applicants',
                  coApplicants,
                  Icons.people,
                  AppTheme.accent,
                ),
                const SizedBox(height: 16),
              ],
              if (guarantors.isNotEmpty)
                _buildRoleSection(
                  'Guarantors',
                  guarantors,
                  Icons.shield,
                  Colors.orange.shade300,
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSection(
    String title,
    List<Person> persons,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Text(
              '$title (${persons.length})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...persons.map((person) => _buildPersonTile(person, color)),
      ],
    );
  }

  Widget _buildPersonTile(Person person, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accentColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            person.personalDetails.name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.phone, size: 14, color: AppTheme.textSecondary),
              const SizedBox(width: 6),
              Text(
                person.contactDetails.mobile,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.credit_card,
                size: 14,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                person.identityDetails.pan,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Submitted: ${_formatDate(person.submittedAt)}',
            style: const TextStyle(fontSize: 11, color: AppTheme.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
