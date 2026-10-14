import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MedReminderApp());
}

const Color brand = Color(0xFF18866A);
const Color softMint = Color(0xFFDDF4E9);

class MedReminderApp extends StatefulWidget {
  const MedReminderApp({super.key});

  @override
  State<MedReminderApp> createState() => _MedReminderAppState();
}

class _MedReminderAppState extends State<MedReminderApp> {
  bool _dark = false;

  void _setDark(bool value) => setState(() => _dark = value);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedReminder',
      debugShowCheckedModeBanner: false,
      themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: brand, brightness: Brightness.light),
        scaffoldBackgroundColor: const Color(0xFFF5F8F6),
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE0E8E3))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: brand, width: 1.5)),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: Color(0xFFE7EEE9))),
          margin: EdgeInsets.zero,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme:
            ColorScheme.fromSeed(seedColor: brand, brightness: Brightness.dark),
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
        cardTheme: CardThemeData(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          margin: EdgeInsets.zero,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      home: AuthGate(onThemeChanged: _setDark, isDark: _dark),
    );
  }
}

// ----------------------------- Models --------------------------------------

class LocalUser {
  final String id;
  final String name;
  final String email;
  final String password;

  const LocalUser(
      {required this.id,
      required this.name,
      required this.email,
      required this.password});

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'email': email, 'password': password};
  factory LocalUser.fromJson(Map<String, dynamic> json) => LocalUser(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        password: json['password'] as String,
      );
}

class Medication {
  final String id;
  final String ownerId;
  final String name;
  final String dosage;
  final String frequency;
  final List<String> times;
  final DateTime startDate;
  final DateTime? endDate;
  final String instructions;
  final bool isActive;
  final DateTime createdAt;

  const Medication({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.times,
    required this.startDate,
    required this.endDate,
    required this.instructions,
    required this.isActive,
    required this.createdAt,
  });

  Medication copyWith({
    String? name,
    String? dosage,
    String? frequency,
    List<String>? times,
    DateTime? startDate,
    DateTime? endDate,
    bool clearEndDate = false,
    String? instructions,
    bool? isActive,
  }) =>
      Medication(
        id: id,
        ownerId: ownerId,
        name: name ?? this.name,
        dosage: dosage ?? this.dosage,
        frequency: frequency ?? this.frequency,
        times: times ?? this.times,
        startDate: startDate ?? this.startDate,
        endDate: clearEndDate ? null : (endDate ?? this.endDate),
        instructions: instructions ?? this.instructions,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'ownerId': ownerId,
        'name': name,
        'dosage': dosage,
        'frequency': frequency,
        'times': times,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'instructions': instructions,
        'isActive': isActive,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Medication.fromJson(Map<String, dynamic> json) => Medication(
        id: json['id'] as String,
        ownerId: json['ownerId'] as String,
        name: json['name'] as String,
        dosage: json['dosage'] as String,
        frequency: json['frequency'] as String,
        times: (json['times'] as List<dynamic>).cast<String>(),
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: json['endDate'] == null
            ? null
            : DateTime.parse(json['endDate'] as String),
        instructions: (json['instructions'] as String?) ?? '',
        isActive: (json['isActive'] as bool?) ?? true,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class DoseLog {
  final String id;
  final String ownerId;
  final String medicationId;
  final String medicationName;
  final String dosage;
  final DateTime scheduledAt;
  final String status;
  final DateTime? actionAt;

  const DoseLog({
    required this.id,
    required this.ownerId,
    required this.medicationId,
    required this.medicationName,
    required this.dosage,
    required this.scheduledAt,
    required this.status,
    required this.actionAt,
  });

  DoseLog copyWith(
          {String? status, DateTime? actionAt, bool clearActionAt = false}) =>
      DoseLog(
        id: id,
        ownerId: ownerId,
        medicationId: medicationId,
        medicationName: medicationName,
        dosage: dosage,
        scheduledAt: scheduledAt,
        status: status ?? this.status,
        actionAt: clearActionAt ? null : (actionAt ?? this.actionAt),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'ownerId': ownerId,
        'medicationId': medicationId,
        'medicationName': medicationName,
        'dosage': dosage,
        'scheduledAt': scheduledAt.toIso8601String(),
        'status': status,
        'actionAt': actionAt?.toIso8601String(),
      };

  factory DoseLog.fromJson(Map<String, dynamic> json) => DoseLog(
        id: json['id'] as String,
        ownerId: json['ownerId'] as String,
        medicationId: json['medicationId'] as String,
        medicationName: json['medicationName'] as String,
        dosage: json['dosage'] as String,
        scheduledAt: DateTime.parse(json['scheduledAt'] as String),
        status: json['status'] as String,
        actionAt: json['actionAt'] == null
            ? null
            : DateTime.parse(json['actionAt'] as String),
      );
}

String newId() =>
    '${DateTime.now().microsecondsSinceEpoch}_${DateTime.now().millisecond}';
DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
String dateKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
String formatDate(DateTime d) => '${d.month}/${d.day}/${d.year}';
String formatTime(DateTime d) {
  final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
  return '$hour:${d.minute.toString().padLeft(2, '0')} ${d.hour >= 12 ? 'PM' : 'AM'}';
}

String prettyTime(String raw) {
  final parts = raw.split(':');
  if (parts.length != 2) return raw;
  final hour = int.tryParse(parts[0]) ?? 0;
  final minute = int.tryParse(parts[1]) ?? 0;
  return formatTime(DateTime(2020, 1, 1, hour, minute));
}

String doseId(String owner, String medication, DateTime scheduled) =>
    '${owner}_${medication}_${scheduled.year}${scheduled.month.toString().padLeft(2, '0')}${scheduled.day.toString().padLeft(2, '0')}_${scheduled.hour.toString().padLeft(2, '0')}${scheduled.minute.toString().padLeft(2, '0')}';

// ----------------------------- Local storage -------------------------------

class LocalRepository {
  static const _usersKey = 'medreminder_users_v1';
  static const _sessionKey = 'medreminder_session_v1';
  static const _medsKey = 'medreminder_meds_v1';
  static const _logsKey = 'medreminder_logs_v1';
  static const _themeKey = 'medreminder_dark_v1';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<List<LocalUser>> users() async {
    final p = await _prefs;
    final raw = p.getString(_usersKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((e) => LocalUser.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<LocalUser?> register(
      String name, String email, String password) async {
    final all = await users();
    if (all.any((u) => u.email.toLowerCase() == email.trim().toLowerCase())) {
      return null;
    }
    final user = LocalUser(
        id: newId(),
        name: name.trim(),
        email: email.trim().toLowerCase(),
        password: password);
    all.add(user);
    final p = await _prefs;
    await p.setString(
        _usersKey, jsonEncode(all.map((u) => u.toJson()).toList()));
    await setSession(user.id);
    return user;
  }

  Future<LocalUser?> login(String email, String password) async {
    final all = await users();
    for (final user in all) {
      if (user.email.toLowerCase() == email.trim().toLowerCase() &&
          user.password == password) {
        await setSession(user.id);
        return user;
      }
    }
    return null;
  }

  Future<void> setSession(String? userId) async {
    final p = await _prefs;
    if (userId == null) {
      await p.remove(_sessionKey);
    } else {
      await p.setString(_sessionKey, userId);
    }
  }

  Future<LocalUser?> currentUser() async {
    final p = await _prefs;
    final id = p.getString(_sessionKey);
    if (id == null) return null;
    for (final u in await users()) {
      if (u.id == id) return u;
    }
    return null;
  }

  Future<void> updateUser(LocalUser updated) async {
    final all = await users();
    final index = all.indexWhere((u) => u.id == updated.id);
    if (index < 0) return;
    all[index] = updated;
    final p = await _prefs;
    await p.setString(
        _usersKey, jsonEncode(all.map((u) => u.toJson()).toList()));
  }

  Future<List<Medication>> medications(String ownerId) async {
    final p = await _prefs;
    final raw = p.getString(_medsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((e) => Medication.fromJson(Map<String, dynamic>.from(e as Map)))
          .where((m) => m.ownerId == ownerId)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveMedication(Medication med) async {
    final p = await _prefs;
    final raw = p.getString(_medsKey);
    List<Medication> all = [];
    if (raw != null) {
      try {
        all = (jsonDecode(raw) as List<dynamic>)
            .map(
                (e) => Medication.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      } catch (_) {}
    }
    final index = all.indexWhere((m) => m.id == med.id);
    if (index >= 0) {
      all[index] = med;
    } else {
      all.add(med);
    }
    await p.setString(
        _medsKey, jsonEncode(all.map((m) => m.toJson()).toList()));
  }

  Future<void> deleteMedication(String id) async {
    final p = await _prefs;
    final raw = p.getString(_medsKey);
    if (raw == null) return;
    try {
      final all = (jsonDecode(raw) as List<dynamic>)
          .map((e) => Medication.fromJson(Map<String, dynamic>.from(e as Map)))
          .where((m) => m.id != id)
          .toList();
      await p.setString(
          _medsKey, jsonEncode(all.map((m) => m.toJson()).toList()));
    } catch (_) {}
  }

  Future<List<DoseLog>> logs(String ownerId) async {
    final p = await _prefs;
    final raw = p.getString(_logsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((e) => DoseLog.fromJson(Map<String, dynamic>.from(e as Map)))
          .where((l) => l.ownerId == ownerId)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveLog(DoseLog log) async {
    final p = await _prefs;
    final raw = p.getString(_logsKey);
    List<DoseLog> all = [];
    if (raw != null) {
      try {
        all = (jsonDecode(raw) as List<dynamic>)
            .map((e) => DoseLog.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      } catch (_) {}
    }
    final index = all.indexWhere((l) => l.id == log.id);
    if (index >= 0) {
      all[index] = log;
    } else {
      all.add(log);
    }
    await p.setString(
        _logsKey, jsonEncode(all.map((l) => l.toJson()).toList()));
  }

  Future<void> clearUserData(String ownerId) async {
    final p = await _prefs;
    final medsRaw = p.getString(_medsKey);
    final logsRaw = p.getString(_logsKey);
    if (medsRaw != null) {
      try {
        final meds = (jsonDecode(medsRaw) as List<dynamic>)
            .map(
                (e) => Medication.fromJson(Map<String, dynamic>.from(e as Map)))
            .where((m) => m.ownerId != ownerId)
            .toList();
        await p.setString(
            _medsKey, jsonEncode(meds.map((m) => m.toJson()).toList()));
      } catch (_) {}
    }
    if (logsRaw != null) {
      try {
        final logs = (jsonDecode(logsRaw) as List<dynamic>)
            .map((e) => DoseLog.fromJson(Map<String, dynamic>.from(e as Map)))
            .where((l) => l.ownerId != ownerId)
            .toList();
        await p.setString(
            _logsKey, jsonEncode(logs.map((l) => l.toJson()).toList()));
      } catch (_) {}
    }
  }

  Future<bool> isDark() async => (await _prefs).getBool(_themeKey) ?? false;
  Future<void> setDark(bool value) async =>
      (await _prefs).setBool(_themeKey, value);
}

// ----------------------------- Auth gate ----------------------------------

class AuthGate extends StatefulWidget {
  final ValueChanged<bool> onThemeChanged;
  final bool isDark;
  const AuthGate(
      {super.key, required this.onThemeChanged, required this.isDark});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final LocalRepository repo = LocalRepository();
  LocalUser? user;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final savedTheme = await repo.isDark();
    widget.onThemeChanged(savedTheme);
    final current = await repo.currentUser();
    if (!mounted) return;
    setState(() {
      user = current;
      loading = false;
    });
  }

  void _signedIn(LocalUser value) => setState(() => user = value);

  Future<void> _logout() async {
    await repo.setSession(null);
    if (mounted) setState(() => user = null);
  }

  @override
  Widget build(BuildContext context) {
     if (loading) {
       return const Scaffold(body: Center(child: CircularProgressIndicator()));
     }
    if (user == null) {
      return LoginScreen(
          repo: repo,
          onSignedIn: _signedIn,
          onThemeChanged: widget.onThemeChanged);
    }
    return MainShell(
        user: user!,
        repo: repo,
        onLogout: _logout,
        onThemeChanged: widget.onThemeChanged,
        isDark: widget.isDark);
  }
}

class LoginScreen extends StatefulWidget {
  final LocalRepository repo;
  final ValueChanged<LocalUser> onSignedIn;
  final ValueChanged<bool> onThemeChanged;
  const LoginScreen(
      {super.key,
      required this.repo,
      required this.onSignedIn,
      required this.onThemeChanged});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  bool _hidePassword = true;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final user = await widget.repo.login(_email.text, _password.text);
    if (!mounted) return;
    setState(() => _busy = false);
    if (user == null) {
      setState(() => _error =
          'Email or password is incorrect. Register if this is your first visit.');
    } else {
      widget.onSignedIn(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Form(
              key: _form,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: softMint,
                          borderRadius: BorderRadius.circular(24)),
                      child: const Icon(Icons.medication_rounded,
                          size: 42, color: brand),
                    ),
                    const SizedBox(height: 24),
                    Text('MedReminder',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text('Your personal medication companion',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: cs.onSurfaceVariant)),
                    const SizedBox(height: 28),
                    Text('Welcome back',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: 'Email address',
                          prefixIcon: Icon(Icons.email_outlined)),
                       validator: (v) {
                         if (v == null || v.trim().isEmpty) {
                           return 'Email is required';
                         }
                         if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                             .hasMatch(v.trim())) {
                           return 'Enter a valid email';
                         }
                         return null;
                       },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _password,
                      obscureText: _hidePassword,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                              icon: Icon(_hidePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                              onPressed: () => setState(
                                  () => _hidePassword = !_hidePassword))),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Password is required'
                          : null,
                      onFieldSubmitted: (_) => _login(),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(_error!, style: TextStyle(color: cs.error)),
                    ],
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _busy ? null : _login,
                      style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: _busy
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Log in'),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => RegisterScreen(
                                  repo: widget.repo,
                                  onSignedIn: widget.onSignedIn))),
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15)),
                      child: const Text('Create account'),
                    ),
                    const SizedBox(height: 18),
                    Text('Demo app • Data stays on this device',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: cs.onSurfaceVariant)),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  final LocalRepository repo;
  final ValueChanged<LocalUser> onSignedIn;
  const RegisterScreen(
      {super.key, required this.repo, required this.onSignedIn});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;
  bool _hide = true;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final user =
        await widget.repo.register(_name.text, _email.text, _password.text);
    if (!mounted) return;
    setState(() => _busy = false);
    if (user == null) {
      setState(() => _error = 'An account with this email already exists.');
      return;
    }
    widget.onSignedIn(user);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Create account')),
        body: Center(
            child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _form,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.person_add_alt_1_rounded,
                          size: 48, color: brand),
                      const SizedBox(height: 12),
                      Text('Create your account',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 22),
                      TextFormField(
                          controller: _name,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                              labelText: 'Full name',
                              prefixIcon: Icon(Icons.person_outline)),
                          validator: (v) => v == null || v.trim().length < 2
                              ? 'Enter at least 2 characters'
                              : null),
                      const SizedBox(height: 14),
                      TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              labelText: 'Email address',
                              prefixIcon: Icon(Icons.email_outlined)),
                          validator: (v) => v == null ||
                                  !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                      .hasMatch(v.trim())
                              ? 'Enter a valid email'
                              : null),
                      const SizedBox(height: 14),
                      TextFormField(
                          controller: _password,
                          obscureText: _hide,
                          decoration: InputDecoration(
                              labelText: 'Password (min. 6 characters)',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                  icon: Icon(_hide
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined),
                                  onPressed: () =>
                                      setState(() => _hide = !_hide))),
                          validator: (v) => v == null || v.length < 6
                              ? 'Use at least 6 characters'
                              : null),
                      const SizedBox(height: 14),
                      TextFormField(
                          controller: _confirm,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Confirm password',
                              prefixIcon: Icon(Icons.lock_reset_outlined)),
                          validator: (v) => v != _password.text
                              ? 'Passwords do not match'
                              : null),
                      if (_error != null) ...[
                        const SizedBox(height: 10),
                        Text(_error!,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error))
                      ],
                      const SizedBox(height: 22),
                      FilledButton(
                          onPressed: _busy ? null : _register,
                          style: FilledButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16)),
                          child: _busy
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2))
                              : const Text('Register')),
                    ]),
              )),
        )),
      );
}

// ----------------------------- Main shell ----------------------------------

class MainShell extends StatefulWidget {
  final LocalUser user;
  final LocalRepository repo;
  final Future<void> Function() onLogout;
  final ValueChanged<bool> onThemeChanged;
  final bool isDark;
  const MainShell(
      {super.key,
      required this.user,
      required this.repo,
      required this.onLogout,
      required this.onThemeChanged,
      required this.isDark});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  bool _loading = true;
  List<Medication> _medications = [];
  List<DoseLog> _logs = [];
  late LocalUser _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _refresh();
  }

  Future<void> _refresh() async {
    final meds = await widget.repo.medications(_user.id);
    final logs = await widget.repo.logs(_user.id);
    if (!mounted) return;
    setState(() {
      _medications = meds;
      _logs = logs;
      _loading = false;
    });
    await _refreshMissed();
  }

  Future<void> _refreshMissed() async {
    final now = DateTime.now();
    final todays = _scheduledFor(dateOnly(now));
    for (final dose in todays) {
      if (dose.status == 'Pending' && dose.scheduledAt.isBefore(now)) {
        final updated = dose.copyWith(status: 'Missed');
        await widget.repo.saveLog(updated);
      }
    }
    final logs = await widget.repo.logs(_user.id);
    if (mounted) setState(() => _logs = logs);
  }

  List<DoseLog> _scheduledFor(DateTime day) {
    final result = <DoseLog>[];
    final existing = {for (final l in _logs) l.id: l};
    for (final med in _medications.where((m) => m.isActive)) {
      final d = dateOnly(day);
      if (d.isBefore(dateOnly(med.startDate))) continue;
      if (med.endDate != null && d.isAfter(dateOnly(med.endDate!))) continue;
      for (final rawTime in med.times) {
        final parts = rawTime.split(':');
        if (parts.length != 2) continue;
         final hour = int.tryParse(parts[0]);
         final minute = int.tryParse(parts[1]);
         if (hour == null ||
             minute == null ||
             hour < 0 ||
             hour > 23 ||
             minute < 0 ||
             minute > 59) {
           continue;
         }
        final at = DateTime(d.year, d.month, d.day, hour, minute);
        final id = doseId(_user.id, med.id, at);
        result.add(existing[id] ??
            DoseLog(
              id: id,
              ownerId: _user.id,
              medicationId: med.id,
              medicationName: med.name,
              dosage: med.dosage,
              scheduledAt: at,
              status: 'Pending',
              actionAt: null,
            ));
      }
    }
    result.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return result;
  }

  Future<void> _changeDose(DoseLog dose, String status) async {
    if (dose.status != 'Pending' && status != 'Pending') {
      final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Change dose status?'),
                content: const Text(
                    'This dose already has a recorded status. Do you want to correct it?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Correct status'))
                ],
              ));
      if (ok != true) return;
    }
    final updated = dose.copyWith(
        status: status,
        actionAt: status == 'Pending' ? null : DateTime.now(),
        clearActionAt: status == 'Pending');
    await widget.repo.saveLog(updated);
    await _refresh();
  }

  Future<void> _saveMedication(Medication med) async {
    await widget.repo.saveMedication(med);
    await _refresh();
  }

  Future<void> _deleteMedication(Medication med) async {
    final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Delete medication?'),
              content: Text(
                  'Delete ${med.name}? Its saved dose history will remain visible in History.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancel')),
                FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Delete'))
              ],
            ));
    if (ok == true) {
      await widget.repo.deleteMedication(med.id);
      await _refresh();
    }
  }

  Future<void> _openMedicationForm([Medication? medication]) async {
    final result =
        await Navigator.of(context).push<Medication>(MaterialPageRoute(
      builder: (_) =>
          MedicationFormScreen(ownerId: _user.id, existing: medication),
    ));
    if (result != null) await _saveMedication(result);
  }

  Future<void> _editProfile() async {
    final controller = TextEditingController(text: _user.name);
    final newName = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Edit display name'),
              content: TextField(
                  controller: controller,
                  autofocus: true,
                  maxLength: 60,
                  decoration: const InputDecoration(labelText: 'Display name')),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel')),
                FilledButton(
                    onPressed: () => Navigator.pop(ctx, controller.text.trim()),
                    child: const Text('Save'))
              ],
            ));
    controller.dispose();
    if (newName == null) return;
    if (newName.trim().length < 2) {
      if (mounted) _message('Name must contain at least 2 characters.');
      return;
    }
    _user = LocalUser(
        id: _user.id,
        name: newName.trim(),
        email: _user.email,
        password: _user.password);
    await widget.repo.updateUser(_user);
    if (mounted) setState(() {});
  }

  void _message(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  @override
  Widget build(BuildContext context) {
     if (_loading) {
       return const Scaffold(body: Center(child: CircularProgressIndicator()));
     }
    final titles = [
      'Home',
      'My Medications',
      "Today's Schedule",
      'History & Reports',
      'Profile & Settings'
    ];
    final pages = <Widget>[
      DashboardScreen(
          user: _user,
          medications: _medications,
          logs: _logs,
          today: _scheduledFor(dateOnly(DateTime.now())),
          onNavigate: (i) => setState(() => _index = i),
          onAdd: () => _openMedicationForm()),
      MedicationsScreen(
          medications: _medications,
          onAdd: () => _openMedicationForm(),
          onEdit: _openMedicationForm,
          onDelete: _deleteMedication,
          onToggleActive: (m) =>
              _saveMedication(m.copyWith(isActive: !m.isActive))),
      ScheduleScreen(
          doses: _scheduledFor(dateOnly(DateTime.now())),
          onChange: _changeDose,
          onRefresh: _refresh),
      HistoryScreen(logs: _logs, medications: _medications),
      ProfileScreen(
          user: _user,
          isDark: widget.isDark,
          onEdit: _editProfile,
          onTheme: (v) async {
            await widget.repo.setDark(v);
            widget.onThemeChanged(v);
          },
          onLogout: () async {
            final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: const Text('Log out?'),
                      content: const Text(
                          'Your saved local data will remain on this device.'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Cancel')),
                        FilledButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Log out'))
                      ],
                    ));
            if (ok == true) await widget.onLogout();
          },
          onClearData: () async {
            final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: const Text('Clear your data?'),
                      content: const Text(
                          'This permanently removes your medications and dose history for this account. Your account remains.'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Cancel')),
                        FilledButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Clear data'))
                      ],
                    ));
            if (ok == true) {
              await widget.repo.clearUserData(_user.id);
              await _refresh();
              if (mounted) _message('Your medication data was cleared.');
            }
          }),
    ];

    final wide = MediaQuery.sizeOf(context).width >= 760;
    final destinations = const [
      NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded),
          label: 'Home'),
      NavigationDestination(
          icon: Icon(Icons.medication_outlined),
          selectedIcon: Icon(Icons.medication_rounded),
          label: 'Meds'),
      NavigationDestination(
          icon: Icon(Icons.calendar_month_outlined),
          selectedIcon: Icon(Icons.calendar_month_rounded),
          label: 'Schedule'),
      NavigationDestination(
          icon: Icon(Icons.history_rounded), label: 'History'),
      NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person_rounded),
          label: 'Profile'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: softMint, borderRadius: BorderRadius.circular(12)),
              child:
                  const Icon(Icons.medication_rounded, color: brand, size: 22)),
          const SizedBox(width: 10),
          Text(titles[_index],
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
        actions: [
          IconButton(
              tooltip: 'Refresh schedule',
              onPressed: _refresh,
              icon: const Icon(Icons.refresh)),
          Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                backgroundColor: softMint,
                foregroundColor: brand,
                child: Text(
                    _user.name.isNotEmpty ? _user.name[0].toUpperCase() : 'U',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              )),
        ],
      ),
      body: wide
          ? Row(children: [
              NavigationRail(
                selectedIndex: _index,
                onDestinationSelected: (i) => setState(() => _index = i),
                labelType: NavigationRailLabelType.all,
                destinations: const [
                  NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: Text('Home')),
                  NavigationRailDestination(
                      icon: Icon(Icons.medication_outlined),
                      selectedIcon: Icon(Icons.medication_rounded),
                      label: Text('Medications')),
                  NavigationRailDestination(
                      icon: Icon(Icons.calendar_month_outlined),
                      selectedIcon: Icon(Icons.calendar_month_rounded),
                      label: Text('Schedule')),
                  NavigationRailDestination(
                      icon: Icon(Icons.history_rounded),
                      label: Text('History')),
                  NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person_rounded),
                      label: Text('Profile')),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(child: IndexedStack(index: _index, children: pages)),
            ])
          : IndexedStack(index: _index, children: pages),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              destinations: destinations),
    );
  }
}

// ----------------------------- Dashboard -----------------------------------

class DashboardScreen extends StatelessWidget {
  final LocalUser user;
  final List<Medication> medications;
  final List<DoseLog> logs;
  final List<DoseLog> today;
  final ValueChanged<int> onNavigate;
  final VoidCallback onAdd;

  const DashboardScreen(
      {super.key,
      required this.user,
      required this.medications,
      required this.logs,
      required this.today,
      required this.onNavigate,
      required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final active = medications.where((m) => m.isActive).length;
    final taken = today.where((d) => d.status == 'Taken').length;
    final pending = today.where((d) => d.status == 'Pending').length;
    final missed = today.where((d) => d.status == 'Missed').length;
    final upcoming = today
        .where((d) =>
            d.status == 'Pending' && !d.scheduledAt.isBefore(DateTime.now()))
        .toList();
    final DoseLog? next = upcoming.isEmpty ? null : upcoming.first;
    final cs = Theme.of(context).colorScheme;
    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView(padding: const EdgeInsets.all(20), children: [
        Text('Hello, ${user.name.split(' ').first} 👋',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text('Here is your medication overview for today.',
            style: TextStyle(color: cs.onSurfaceVariant)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF18866A), Color(0xFF2CA889)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  const Text('Next scheduled dose',
                      style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text(
                      next?.medicationName ??
                          (today.isEmpty
                              ? 'No doses scheduled'
                              : 'No upcoming pending doses'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                      next == null
                          ? 'You can add a medication anytime.'
                          : '${formatTime(next.scheduledAt)} • ${next.dosage}',
                      style: const TextStyle(color: Colors.white)),
                ])),
            const SizedBox(width: 12),
            const Icon(Icons.alarm_rounded, color: Colors.white, size: 48),
          ]),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(builder: (context, constraints) {
          final count = constraints.maxWidth > 650 ? 4 : 2;
          final width = (constraints.maxWidth - 12 * (count - 1)) / count;
          return Wrap(spacing: 12, runSpacing: 12, children: [
            SizedBox(
                width: width,
                child: StatCard(
                    title: 'Active meds',
                    value: '$active',
                    icon: Icons.medication_outlined,
                    color: brand)),
            SizedBox(
                width: width,
                child: StatCard(
                    title: 'Taken today',
                    value: '$taken',
                    icon: Icons.check_circle_outline,
                    color: Colors.green)),
            SizedBox(
                width: width,
                child: StatCard(
                    title: 'Pending',
                    value: '$pending',
                    icon: Icons.schedule,
                    color: Colors.orange)),
            SizedBox(
                width: width,
                child: StatCard(
                    title: 'Missed',
                    value: '$missed',
                    icon: Icons.error_outline,
                    color: Colors.redAccent)),
          ]);
        }),
        const SizedBox(height: 22),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Today's schedule",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          TextButton(
              onPressed: () => onNavigate(2), child: const Text('View all')),
        ]),
        if (today.isEmpty)
          const EmptyState(
              icon: Icons.calendar_today_outlined,
              title: 'Nothing scheduled today',
              message: 'Add a medication and its schedule to get started.')
        else
          ...today.take(4).map((dose) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: DoseSummaryTile(dose: dose))),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
              child: FilledButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text('Add medication'))),
          const SizedBox(width: 12),
          Expanded(
              child: OutlinedButton.icon(
                  onPressed: () => onNavigate(1),
                  icon: const Icon(Icons.list_alt),
                  label: const Text('All medications'))),
        ]),
        const SizedBox(height: 20),
        Text('Quick note',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(
            'MedReminder records the schedule you enter. Follow your healthcare professional’s instructions for all medication decisions.',
            style: TextStyle(color: cs.onSurfaceVariant)),
      ]),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const StatCard(
      {super.key,
      required this.title,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) => Card(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ]),
      ));
}

// ----------------------------- Medication list/form ------------------------

class MedicationsScreen extends StatefulWidget {
  final List<Medication> medications;
  final VoidCallback onAdd;
  final ValueChanged<Medication> onEdit;
  final ValueChanged<Medication> onDelete;
  final ValueChanged<Medication> onToggleActive;
  const MedicationsScreen(
      {super.key,
      required this.medications,
      required this.onAdd,
      required this.onEdit,
      required this.onDelete,
      required this.onToggleActive});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  final _search = TextEditingController();
  bool _showArchived = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.medications
        .where((m) =>
            m.isActive != _showArchived &&
            (m.name.toLowerCase().contains(_search.text.toLowerCase()) ||
                m.dosage.toLowerCase().contains(_search.text.toLowerCase())))
        .toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return ListView(padding: const EdgeInsets.all(20), children: [
      Row(children: [
        Expanded(
            child: Text('Manage your medication records.',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant))),
        FilledButton.icon(
            onPressed: widget.onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add')),
      ]),
      const SizedBox(height: 16),
      TextField(
          controller: _search,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search), hintText: 'Search medications')),
      const SizedBox(height: 12),
      SegmentedButton<bool>(
        segments: const [
          ButtonSegment(
              value: false,
              label: Text('Active'),
              icon: Icon(Icons.check_circle_outline)),
          ButtonSegment(
              value: true,
              label: Text('Archived'),
              icon: Icon(Icons.archive_outlined))
        ],
        selected: {_showArchived},
        onSelectionChanged: (v) => setState(() => _showArchived = v.first),
      ),
      const SizedBox(height: 16),
      if (filtered.isEmpty)
        EmptyState(
            icon: Icons.medication_outlined,
            title: _showArchived
                ? 'No archived medications'
                : 'No medications yet',
            message: _showArchived
                ? 'Archived items will appear here.'
                : 'Add your first medication to build your schedule.',
            actionLabel: _showArchived ? null : 'Add medication',
            onAction: widget.onAdd)
      else
        ...filtered.map((med) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MedicationCard(
              medication: med,
              onEdit: () => widget.onEdit(med),
              onDelete: () => widget.onDelete(med),
              onToggle: () => widget.onToggleActive(med),
            ))),
    ]);
  }
}

class MedicationCard extends StatelessWidget {
  final Medication medication;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  const MedicationCard(
      {super.key,
      required this.medication,
      required this.onEdit,
      required this.onDelete,
      required this.onToggle});

  @override
  Widget build(BuildContext context) => Card(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: softMint, borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.medication_rounded,
                    color: brand, size: 26)),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(medication.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 3),
                  Text(medication.dosage,
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 5),
                  Text(
                      '${medication.frequency} • ${medication.times.map(prettyTime).join(', ')}',
                      style: Theme.of(context).textTheme.bodySmall),
                ])),
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'edit') onEdit();
                if (v == 'archive') onToggle();
                if (v == 'delete') onDelete();
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                        leading: Icon(Icons.edit_outlined),
                        title: Text('Edit'),
                        contentPadding: EdgeInsets.zero)),
                PopupMenuItem(
                    value: 'archive',
                    child: ListTile(
                        leading: Icon(medication.isActive
                            ? Icons.archive_outlined
                            : Icons.unarchive_outlined),
                        title: Text(
                            medication.isActive ? 'Archive' : 'Reactivate'),
                        contentPadding: EdgeInsets.zero)),
                const PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                        leading: Icon(Icons.delete_outline, color: Colors.red),
                        title: Text('Delete'),
                        contentPadding: EdgeInsets.zero)),
              ],
            ),
          ]),
          const SizedBox(height: 12),
          Wrap(spacing: 6, runSpacing: 6, children: [
            StatusBadge(label: medication.isActive ? 'Active' : 'Archived'),
            Chip(
                avatar: const Icon(Icons.calendar_today_outlined, size: 15),
                label: Text('From ${formatDate(medication.startDate)}')),
            if (medication.endDate != null)
              Chip(label: Text('Until ${formatDate(medication.endDate!)}')),
          ]),
          if (medication.instructions.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('Instructions: ${medication.instructions}',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ]),
      ));
}

class MedicationFormScreen extends StatefulWidget {
  final String ownerId;
  final Medication? existing;
  const MedicationFormScreen({super.key, required this.ownerId, this.existing});

  @override
  State<MedicationFormScreen> createState() => _MedicationFormScreenState();
}

class _MedicationFormScreenState extends State<MedicationFormScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _dosage = TextEditingController();
  final _instructions = TextEditingController();
  final Set<String> _times = {};
  String _frequency = 'Once daily';
  DateTime _start = dateOnly(DateTime.now());
  DateTime? _end;
  bool _active = true;

  static const _frequencyOptions = [
    'Once daily',
    'Twice daily',
    'Three times daily',
    'Custom schedule'
  ];

  @override
  void initState() {
    super.initState();
    final m = widget.existing;
    if (m != null) {
      _name.text = m.name;
      _dosage.text = m.dosage;
      _instructions.text = m.instructions;
      _frequency = m.frequency;
      _times.addAll(m.times);
      _start = m.startDate;
      _end = m.endDate;
      _active = m.isActive;
    } else {
      _times.add('08:00');
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _dosage.dispose();
    _instructions.dispose();
    super.dispose();
  }

  Future<DateTime?> _pickDate(DateTime initial,
          {DateTime? first, DateTime? last}) =>
      showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: first ?? DateTime(2000),
          lastDate: last ?? DateTime(2100));

  void _selectFrequency(String? value) {
    if (value == null) return;
    setState(() {
      _frequency = value;
      if (value == 'Once daily') {
        _times
          ..clear()
          ..add('08:00');
      }
      if (value == 'Twice daily') {
        _times
          ..clear()
          ..addAll(['08:00', '20:00']);
      }
      if (value == 'Three times daily') {
        _times
          ..clear()
          ..addAll(['08:00', '13:00', '20:00']);
      }
      if (value == 'Custom schedule' && _times.isEmpty) _times.add('08:00');
    });
  }

  Future<void> _customTime() async {
    final picked = await showTimePicker(
        context: context, initialTime: const TimeOfDay(hour: 9, minute: 0));
    if (picked == null) return;
    final value =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    if (_times.contains(value)) return;
    setState(() {
      _times.add(value);
      _times.toList().sort();
      _frequency = 'Custom schedule';
    });
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    if (_times.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Select at least one scheduled time.')));
      return;
    }
    if (_end != null && dateOnly(_end!).isBefore(dateOnly(_start))) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('End date cannot be before start date.')));
      return;
    }
    final old = widget.existing;
    final med = Medication(
      id: old?.id ?? newId(),
      ownerId: widget.ownerId,
      name: _name.text.trim(),
      dosage: _dosage.text.trim(),
      frequency: _frequency,
      times: _times.toList()..sort(),
      startDate: _start,
      endDate: _end,
      instructions: _instructions.text.trim(),
      isActive: _active,
      createdAt: old?.createdAt ?? DateTime.now(),
    );
    Navigator.of(context).pop(med);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: Text(widget.existing == null
                ? 'Add medication'
                : 'Edit medication')),
        body: Center(
            child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Form(
              key: _form,
              child: ListView(padding: const EdgeInsets.all(20), children: [
                Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        color: softMint,
                        borderRadius: BorderRadius.circular(18)),
                    child: const Row(children: [
                      Icon(Icons.info_outline, color: brand),
                      SizedBox(width: 10),
                      Expanded(
                          child: Text(
                              'Enter the medication information exactly as provided by your healthcare professional.'))
                    ])),
                const SizedBox(height: 18),
                TextFormField(
                    controller: _name,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                        labelText: 'Medication name *',
                        prefixIcon: Icon(Icons.medication_outlined)),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Medication name is required'
                        : v.trim().length > 80
                            ? 'Use 80 characters or fewer'
                            : null),
                const SizedBox(height: 14),
                TextFormField(
                    controller: _dosage,
                    decoration: const InputDecoration(
                        labelText: 'Dosage / amount *',
                        hintText: 'e.g. 1 tablet or 5 mL',
                        prefixIcon: Icon(Icons.straighten)),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Dosage information is required'
                        : v.trim().length > 50
                            ? 'Use 50 characters or fewer'
                            : null),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  initialValue: _frequency,
                  decoration: const InputDecoration(
                      labelText: 'Frequency *', prefixIcon: Icon(Icons.repeat)),
                  items: _frequencyOptions
                      .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                      .toList(),
                  onChanged: _selectFrequency,
                ),
                const SizedBox(height: 14),
                Text('Scheduled times *',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  ...((_times.toList()..sort()).map((t) => InputChip(
                        label: Text(prettyTime(t)),
                        onDeleted: _times.length > 1
                            ? () => setState(() {
                                  _times.remove(t);
                                  _frequency = 'Custom schedule';
                                })
                            : null,
                      ))),
                  ActionChip(
                      avatar: const Icon(Icons.add_alarm, size: 18),
                      label: const Text('Custom time'),
                      onPressed: _customTime),
                ]),
                const SizedBox(height: 16),
                Card(
                    child: Column(children: [
                   ListTile(
                       leading: const Icon(Icons.calendar_today_outlined),
                       title: const Text('Start date'),
                       subtitle: Text(formatDate(_start)),
                       trailing: const Icon(Icons.edit_calendar_outlined),
                       onTap: () async {
                         final d = await _pickDate(_start);
                         if (d != null) {
                            setState(() {
                              _start = dateOnly(d);
                              if (_end != null && _end!.isBefore(_start)) {
                                _end = null;
                              }
                            });
                          }
                        }),
                  const Divider(height: 1),
                  ListTile(
                      leading: const Icon(Icons.event_outlined),
                      title: const Text('End date (optional)'),
                      subtitle: Text(
                          _end == null ? 'No end date' : formatDate(_end!)),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        if (_end != null)
                          IconButton(
                              tooltip: 'Remove end date',
                              onPressed: () => setState(() => _end = null),
                              icon: const Icon(Icons.close)),
                        const Icon(Icons.edit_calendar_outlined),
                      ]),
                      onTap: () async {
                        final d =
                            await _pickDate(_end ?? _start, first: _start);
                        if (d != null) setState(() => _end = dateOnly(d));
                      }),
                ])),
                const SizedBox(height: 14),
                TextFormField(
                    controller: _instructions,
                    minLines: 2,
                    maxLines: 4,
                    maxLength: 250,
                    decoration: const InputDecoration(
                        labelText: 'Instructions (optional)',
                        hintText:
                            'Personal note only; follow professional instructions',
                        prefixIcon: Icon(Icons.notes))),
                if (widget.existing != null)
                  SwitchListTile(
                    value: _active,
                    onChanged: (v) => setState(() => _active = v),
                    title: const Text('Medication active'),
                    subtitle: const Text(
                        'Inactive medications are hidden from today’s schedule.'),
                  ),
                const SizedBox(height: 18),
                FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Save medication'),
                    style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16))),
              ])),
        )),
      );
}

// ----------------------------- Schedule ------------------------------------

class ScheduleScreen extends StatelessWidget {
  final List<DoseLog> doses;
  final Future<void> Function(DoseLog, String) onChange;
  final Future<void> Function() onRefresh;
  const ScheduleScreen(
      {super.key,
      required this.doses,
      required this.onChange,
      required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<DoseLog>>{};
    for (final d in doses) {
      final label = d.scheduledAt.hour < 12
          ? 'Morning'
          : d.scheduledAt.hour < 17
              ? 'Afternoon'
              : 'Evening';
      grouped.putIfAbsent(label, () => []).add(d);
    }
    return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(padding: const EdgeInsets.all(20), children: [
          Text(formatDate(DateTime.now()),
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text('Your scheduled doses for today',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 18),
          if (doses.isEmpty)
            const EmptyState(
                icon: Icons.event_available_outlined,
                title: 'No doses scheduled',
                message: 'Add an active medication to see its schedule here.')
          else
            ...grouped.entries.map((entry) =>
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 8),
                      child: Text(entry.key,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold))),
                  ...entry.value.map((dose) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: DoseActionCard(dose: dose, onChange: onChange))),
                ])),
          const SizedBox(height: 12),
          const Text(
              'Status is refreshed while the app is open. This version does not send background notifications.'),
        ]));
  }
}

class DoseActionCard extends StatelessWidget {
  final DoseLog dose;
  final Future<void> Function(DoseLog, String) onChange;
  const DoseActionCard({super.key, required this.dose, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final pending = dose.status == 'Pending';
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: softMint,
                        borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.medication_rounded, color: brand)),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(dose.medicationName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 3),
                      Text('${formatTime(dose.scheduledAt)} • ${dose.dosage}',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant)),
                    ])),
                StatusBadge(label: dose.status),
              ]),
              if (pending) ...[
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(
                      child: FilledButton.icon(
                          onPressed: () => onChange(dose, 'Taken'),
                          icon: const Icon(Icons.check),
                          label: const Text('Taken'))),
                  const SizedBox(width: 8),
                  Expanded(
                      child: OutlinedButton.icon(
                          onPressed: () => onChange(dose, 'Skipped'),
                          icon: const Icon(Icons.skip_next),
                          label: const Text('Skip'))),
                ]),
              ] else ...[
                const SizedBox(height: 8),
                Row(children: [
                  Icon(Icons.history,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(width: 5),
                  Expanded(
                      child: Text(
                          dose.actionAt == null
                              ? 'No action timestamp'
                              : 'Recorded ${formatTime(dose.actionAt!)}',
                          style: Theme.of(context).textTheme.bodySmall)),
                  TextButton(
                      onPressed: () => onChange(dose, 'Pending'),
                      child: const Text('Correct status')),
                ]),
              ],
            ])));
  }
}

class DoseSummaryTile extends StatelessWidget {
  final DoseLog dose;
  const DoseSummaryTile({super.key, required this.dose});

  @override
  Widget build(BuildContext context) => Card(
          child: ListTile(
        leading: const CircleAvatar(
            backgroundColor: softMint,
            child: Icon(Icons.medication_outlined, color: brand)),
        title: Text(dose.medicationName,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${formatTime(dose.scheduledAt)} • ${dose.dosage}'),
        trailing: StatusBadge(label: dose.status),
      ));
}

// ----------------------------- History -------------------------------------

class HistoryScreen extends StatefulWidget {
  final List<DoseLog> logs;
  final List<Medication> medications;
  const HistoryScreen(
      {super.key, required this.logs, required this.medications});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _status = 'All';
  DateTime _selectedDate = dateOnly(DateTime.now());
  bool _filterToday = true;

  @override
  Widget build(BuildContext context) {
    final all = widget.logs.toList()
      ..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
    final filtered = all.where((l) {
      final statusOk = _status == 'All' || l.status == _status;
      final dateOk =
          !_filterToday || dateKey(l.scheduledAt) == dateKey(_selectedDate);
      return statusOk && dateOk;
    }).toList();
    final todayLogs = all
        .where((l) => dateKey(l.scheduledAt) == dateKey(DateTime.now()))
        .toList();
    final taken = todayLogs.where((l) => l.status == 'Taken').length;
    final resolved = todayLogs
        .where((l) =>
            l.status == 'Taken' ||
            l.status == 'Skipped' ||
            l.status == 'Missed')
        .length;
    final percent = resolved == 0 ? 0.0 : taken / resolved;
    return ListView(padding: const EdgeInsets.all(20), children: [
      Text('History & Reports',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      Text('Review your recorded dose activity.',
          style:
              TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
      const SizedBox(height: 18),
      LayoutBuilder(builder: (context, constraints) {
        final w = (constraints.maxWidth - 12) / 2;
        return Wrap(spacing: 12, runSpacing: 12, children: [
          SizedBox(
              width: w,
              child: StatCard(
                  title: 'Dose logs today',
                  value: '${todayLogs.length}',
                  icon: Icons.history,
                  color: brand)),
          SizedBox(
              width: w,
              child: StatCard(
                  title: 'Taken today',
                  value: '$taken',
                  icon: Icons.check_circle_outline,
                  color: Colors.green)),
        ]);
      }),
      const SizedBox(height: 16),
      Card(
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Today’s recorded completion',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('${(percent * 100).round()}%',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, color: brand)),
                        ]),
                    const SizedBox(height: 12),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                            value: percent, minHeight: 10)),
                    const SizedBox(height: 8),
                    Text(
                        'Calculated from recorded dose statuses; it is not a measure of treatment effectiveness.',
                        style: Theme.of(context).textTheme.bodySmall),
                  ]))),
      const SizedBox(height: 18),
      Text('Weekly overview',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      WeeklyOverview(logs: widget.logs),
      const SizedBox(height: 20),
      Text('Dose history',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        value: _filterToday,
        onChanged: (v) => setState(() => _filterToday = v),
        title: const Text('Filter by selected date'),
        subtitle: Text(formatDate(_selectedDate)),
      ),
      if (_filterToday)
        OutlinedButton.icon(
          onPressed: () async {
            final d = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100));
            if (d != null) setState(() => _selectedDate = dateOnly(d));
          },
          icon: const Icon(Icons.calendar_month),
          label: const Text('Choose date'),
        ),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(
        initialValue: _status,
        decoration: const InputDecoration(labelText: 'Filter by status'),
        items: ['All', 'Taken', 'Pending', 'Skipped', 'Missed']
            .map((v) => DropdownMenuItem(value: v, child: Text(v)))
            .toList(),
        onChanged: (v) {
          if (v != null) setState(() => _status = v);
        },
      ),
      const SizedBox(height: 12),
      if (filtered.isEmpty)
        const EmptyState(
            icon: Icons.manage_search,
            title: 'No matching records',
            message: 'Try another date or status filter.')
      else
        ...filtered.map((log) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
                child: ListTile(
              leading: const CircleAvatar(
                  backgroundColor: softMint,
                  child: Icon(Icons.medication_outlined, color: brand)),
              title: Text(log.medicationName,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(
                  '${formatDate(log.scheduledAt)} • ${formatTime(log.scheduledAt)}\n${log.dosage}${log.actionAt == null ? '' : ' • Updated ${formatTime(log.actionAt!)}'}'),
              isThreeLine: true,
              trailing: StatusBadge(label: log.status),
            )))),
    ]);
  }
}

class WeeklyOverview extends StatelessWidget {
  final List<DoseLog> logs;
  const WeeklyOverview({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    final today = dateOnly(DateTime.now());
    final days = List.generate(7, (i) => today.subtract(Duration(days: 6 - i)));
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: days.map((day) {
                final dayLogs = logs
                    .where((l) => dateKey(l.scheduledAt) == dateKey(day))
                    .toList();
                final taken = dayLogs.where((l) => l.status == 'Taken').length;
                final denominator = dayLogs.length;
                final value = denominator == 0 ? 0.0 : taken / denominator;
                final height = 76.0 * value;
                const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                return Expanded(
                    child: Column(children: [
                  Text('$taken', style: Theme.of(context).textTheme.labelSmall),
                  const SizedBox(height: 6),
                  Container(
                      height: 80,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: height == 0 ? 4 : height,
                        width: 18,
                        decoration: BoxDecoration(
                            color:
                                value >= 0.75 ? brand : const Color(0xFF9BD8C2),
                            borderRadius: BorderRadius.circular(8)),
                      )),
                  const SizedBox(height: 8),
                  Text(labels[day.weekday - 1],
                      style: Theme.of(context).textTheme.labelSmall),
                ]));
              }).toList(),
            )));
  }
}

// ----------------------------- Profile/settings ----------------------------

class ProfileScreen extends StatelessWidget {
  final LocalUser user;
  final bool isDark;
  final VoidCallback onEdit;
  final ValueChanged<bool> onTheme;
  final Future<void> Function() onLogout;
  final Future<void> Function() onClearData;

  const ProfileScreen(
      {super.key,
      required this.user,
      required this.isDark,
      required this.onEdit,
      required this.onTheme,
      required this.onLogout,
      required this.onClearData});

  @override
  Widget build(BuildContext context) =>
      ListView(padding: const EdgeInsets.all(20), children: [
        Text('Profile & Settings',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 18),
        Card(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(children: [
                  CircleAvatar(
                      radius: 32,
                      backgroundColor: softMint,
                      foregroundColor: brand,
                      child: Text(
                          user.name.isEmpty ? 'U' : user.name[0].toUpperCase(),
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold))),
                  const SizedBox(width: 14),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(user.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(user.email,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant)),
                        const SizedBox(height: 8),
                        const StatusBadge(label: 'Local demo account'),
                      ])),
                  IconButton(
                      tooltip: 'Edit display name',
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined)),
                ]))),
        const SizedBox(height: 16),
        Card(
            child: Column(children: [
          SwitchListTile(
            secondary: Icon(
                isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
            title: const Text('Dark theme'),
            subtitle: const Text('Adjust the app appearance'),
            value: isDark,
            onChanged: onTheme,
          ),
          const Divider(height: 1),
          const ListTile(
              leading: Icon(Icons.notifications_active_outlined),
              title: Text('Reminder mode'),
              subtitle: Text('In-app schedule only — no background alerts')),
          const Divider(height: 1),
          const ListTile(
              leading: Icon(Icons.storage_outlined),
              title: Text('Data storage'),
              subtitle: Text('Stored locally with SharedPreferences')),
          const Divider(height: 1),
          const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About MedReminder'),
              subtitle: Text('Flutter + Dart • Student mini-capstone')),
        ])),
        const SizedBox(height: 16),
        OutlinedButton.icon(
            onPressed: onClearData,
            icon: const Icon(Icons.delete_sweep_outlined),
            label: const Text('Clear medication data')),
        const SizedBox(height: 10),
        FilledButton.tonalIcon(
            onPressed: onLogout,
            icon: const Icon(Icons.logout),
            label: const Text('Log out')),
        const SizedBox(height: 20),
        Text('Safety notice',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(
            'MedReminder is for personal organization and record keeping. It does not diagnose conditions, prescribe medication, or tell you how to respond to a missed dose. Ask a qualified healthcare professional for medical guidance.',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ]);
}

// ----------------------------- Shared widgets ------------------------------

class StatusBadge extends StatelessWidget {
  final String label;
  const StatusBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (label) {
      case 'Taken':
        bg = const Color(0xFFDDF4E9);
        fg = const Color(0xFF176B4D);
        break;
      case 'Missed':
        bg = const Color(0xFFFFE3E0);
        fg = const Color(0xFFB42318);
        break;
      case 'Skipped':
        bg = const Color(0xFFFFEED5);
        fg = const Color(0xFF8A4B08);
        break;
      case 'Pending':
        bg = const Color(0xFFFFF2CC);
        fg = const Color(0xFF855D00);
        break;
      case 'Archived':
        bg = const Color(0xFFE8E8E8);
        fg = const Color(0xFF555555);
        break;
      default:
        bg = const Color(0xFFDDF4E9);
        fg = const Color(0xFF176B4D);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(30)),
      child: Text(label,
          style:
              TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  const EmptyState(
      {super.key,
      required this.icon,
      required this.title,
      required this.message,
      this.actionLabel,
      this.onAction});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 12),
        child: Column(children: [
          Container(
              padding: const EdgeInsets.all(18),
              decoration:
                  const BoxDecoration(color: softMint, shape: BoxShape.circle),
              child: Icon(icon, size: 34, color: brand)),
          const SizedBox(height: 14),
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 14),
            FilledButton.tonal(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ]),
      );
}
