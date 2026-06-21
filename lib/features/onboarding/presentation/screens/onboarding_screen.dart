import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.onCompleted});

  final VoidCallback? onCompleted;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;
  String? _selectedGrade;
  final Set<String> _selectedSubjects = <String>{};

  static const List<String> _grades = <String>['중1', '중2', '중3', '고1', '고2', '고3'];
  static const List<String> _subjects = <String>['국어', '영어', '수학', '사회', '과학'];

  void _next() {
    setState(() {
      if (_step < 3) {
        _step += 1;
      }
    });
  }

  void _skipGrade() {
    _selectedGrade = null;
    _next();
  }

  void _toggleSubject(String subject) {
    setState(() {
      if (_selectedSubjects.contains(subject)) {
        _selectedSubjects.remove(subject);
      } else {
        _selectedSubjects.add(subject);
      }
    });
  }

  void _complete() {
    widget.onCompleted?.call();
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (_step + 1) / 4;

    return Scaffold(
      appBar: AppBar(title: const Text('온보딩')),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFFF8FAFC), Color(0xFFE0F2FE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Text(
                    '${_step + 1}/4',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  minHeight: 10,
                  value: progress,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0284C7)),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildStepContent(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildBottomActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Text('환영합니다', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text('카메라, 저장소, 알림 권한이 필요해요'),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('학년을 선택해주세요', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _grades
                  .map(
                    (String grade) => ChoiceChip(
                      label: Text(grade),
                      selected: _selectedGrade == grade,
                      onSelected: (_) => setState(() => _selectedGrade = grade),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('주 과목을 선택해주세요', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _subjects
                  .map(
                    (String subject) => FilterChip(
                      label: Text(subject),
                      selected: _selectedSubjects.contains(subject),
                      onSelected: (_) => _toggleSubject(subject),
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Text('복습 알림 시간을 설정해주세요', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.alarm),
              title: Text('08:00'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.alarm),
              title: Text('17:00'),
            ),
          ],
        );
    }
  }

  Widget _buildBottomActions() {
    if (_step == 0) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _next,
          child: const Text('다음'),
        ),
      );
    }

    if (_step == 1) {
      return Row(
        children: <Widget>[
          TextButton(
            onPressed: _skipGrade,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF0369A1),
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
            ),
            child: const Text('건너뛰기'),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: _next,
            child: const Text('다음'),
          ),
        ],
      );
    }

    if (_step == 2) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _selectedSubjects.isEmpty ? null : _next,
          child: const Text('다음'),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _complete,
        child: const Text('완료'),
      ),
    );
  }
}
