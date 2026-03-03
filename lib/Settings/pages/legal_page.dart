import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class LegalPage extends StatelessWidget {
  const LegalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Políticas y Términos',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: FutureBuilder<String>(
        future: rootBundle.loadString('POLITICAS_Y_TERMINOS.md'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar el documento legal.',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }

          final data = snapshot.data ?? '';

          return Markdown(
            data: data,
            padding: const EdgeInsets.all(20),
            selectable: true,
            styleSheet:
                MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              h1: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 2.0,
              ),
              h2: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.8,
              ),
              h3: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.6,
              ),
              p: const TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
              listBullet: const TextStyle(
                fontSize: 15,
              ),
            ),
          );
        },
      ),
    );
  }
}
