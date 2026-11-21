import 'package:flutter/material.dart';

import '../models/installed_app.dart';
import '../services/app_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AppService _service = AppService();
  List<InstalledApp> _apps = const [];
  bool _loading = true;
  String? _error;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final apps = await _service.getInstalledApps();
      if (!mounted) return;
      setState(() {
        _apps = apps;
        _loading = false;
      });
    } on PlatformException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message ?? e.code;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _apps.where((app) {
      final query = _search.trim().toLowerCase();
      return query.isEmpty ||
          app.name.toLowerCase().contains(query) ||
          app.packageName.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Smart Organizer',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh apps',
            onPressed: _loading ? null : _loadApps,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SummaryCard(appCount: _apps.length),
              const SizedBox(height: 22),
              TextField(
                onChanged: (value) => setState(() => _search = value),
                decoration: InputDecoration(
                  hintText: 'ابحث عن تطبيق...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: const Color(0xFF1B2030),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'التطبيقات المثبتة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${filtered.length}',
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(child: _buildContent(filtered)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(List<InstalledApp> filtered) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 42),
            const SizedBox(height: 12),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _loadApps,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (filtered.isEmpty) {
      return const Center(child: Text('لم يتم العثور على تطبيقات'));
    }

    return GridView.builder(
      itemCount: filtered.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.88,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final app = filtered[index];
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF1B2030),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: app.iconProvider == null
                      ? const Icon(Icons.apps_rounded, size: 42)
                      : Image(
                          image: app.iconProvider!,
                          width: 48,
                          height: 48,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.apps_rounded, size: 42),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                app.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.appCount});

  final int appCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6256D9), Color(0xFF29275C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'مساحتك الرقمية',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '$appCount تطبيق تم اكتشافه',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
