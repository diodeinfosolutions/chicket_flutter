import 'package:flutter/widgets.dart';

class EnLocale extends StatelessWidget {
  const EnLocale({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: const Locale('en'),
      child: Builder(builder: (_) => child),
    );
  }
}
