import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/person.dart';
import '../../../data/repositories/loan_case_repository.dart';
import '../../../data/repositories/person_repository.dart';
import 'success_screen.dart';

class FormScreen extends StatefulWidget {
  final String token;
  final String role;

  const FormScreen({
    super.key,
    required this.token,
    required this.role,
  });

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loanCaseRepository = LoanCaseRepository();
  final _personRepository = PersonRepository();

  bool _isLoading = false;

  // Controllers
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _panController = TextEditingController();
  final _aadharController = TextEditingController();
  final _addressController = TextEditingController();

  String? _loanCaseId;

  @override
  void initState() {
    super.initState();
    _loadLoanCase();
  }

  Future<void> _loadLoanCase() async {
    final loanCase = await _loanCaseRepository.getLoanCaseByToken(widget.token);
    setState(() => _loanCaseId = loanCase?.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_getRoleTitle()} Details'),
      ),
      body: _loanCaseId == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    const _SectionHeader(title: 'Personal Information'),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name *',
                        prefixIcon: Icon(Icons.person),
                        hintText: 'Enter your full name',
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (v) =>
                          v?.isEmpty == true ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _mobileController,
                      decoration: const InputDecoration(
                        labelText: 'Mobile Number *',
                        prefixIcon: Icon(Icons.phone),
                        hintText: '10-digit mobile number',
                      ),
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      validator: (v) {
                        if (v?.isEmpty == true) {
                          return 'Mobile number is required';
                        }
                        if (v!.length != 10) {
                          return 'Enter valid 10-digit number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email),
                        hintText: 'your@email.com',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),
                    const _SectionHeader(title: 'Identity Details'),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _panController,
                      decoration: const InputDecoration(
                        labelText: 'PAN Number *',
                        prefixIcon: Icon(Icons.credit_card),
                        hintText: 'ABCDE1234F',
                      ),
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 10,
                      validator: (v) {
                        if (v?.isEmpty == true) {
                          return 'PAN is required';
                        }
                        if (v!.length != 10) {
                          return 'Enter valid PAN';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _aadharController,
                      decoration: const InputDecoration(
                        labelText: 'Aadhar Number *',
                        prefixIcon: Icon(Icons.badge),
                        hintText: '12-digit Aadhar number',
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 12,
                      validator: (v) {
                        if (v?.isEmpty == true) {
                          return 'Aadhar is required';
                        }
                        if (v!.length != 12) {
                          return 'Enter valid 12-digit Aadhar';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    const _SectionHeader(title: 'Address'),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Present Address *',
                        prefixIcon: Icon(Icons.home),
                        hintText: 'Enter your complete address',
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                      textCapitalization: TextCapitalization.words,
                      validator: (v) =>
                          v?.isEmpty == true ? 'Address is required' : null,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Submit Application',
                                style: TextStyle(fontSize: 18),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '* Required fields',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textHint,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final person = Person(
        id: '',
        loanCaseId: _loanCaseId!,
        role: widget.role,
        submittedAt: DateTime.now(),
        personalDetails: PersonalDetails(
          name: _nameController.text.trim(),
          gender: 'M',
          dateOfBirth: DateTime.now().subtract(const Duration(days: 365 * 30)),
          age: 30,
          maritalStatus: 'Single',
          fatherName: '',
          motherName: '',
        ),
        contactDetails: ContactDetails(
          mobile: _mobileController.text.trim(),
          email: _emailController.text.trim(),
          presentAddress: _addressController.text.trim(),
          permanentAddress: _addressController.text.trim(),
        ),
        identityDetails: IdentityDetails(
          pan: _panController.text.trim().toUpperCase(),
          aadhar: _aadharController.text.trim(),
          passport: '',
          drivingLicense: '',
        ),
        occupationDetails: OccupationDetails(
          type: 'salaried',
          employerName: '',
          designation: '',
          totalExperience: '',
          grossIncome: 0,
          netIncome: 0,
        ),
      );

      await _personRepository.submitPerson(person);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SuccessScreen()),
        );
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
        setState(() => _isLoading = false);
      }
    }
  }

  String _getRoleTitle() {
    switch (widget.role) {
      case 'applicant':
        return 'Applicant';
      case 'co_applicant':
        return 'Co-Applicant';
      case 'guarantor':
        return 'Guarantor';
      default:
        return 'Form';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _panController.dispose();
    _aadharController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.primary,
      ),
    );
  }
}
