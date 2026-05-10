import 'dart:convert';

import 'package:http/http.dart' as http;

class QuoteService {
  Future<Map<String, dynamic>> fetchQuote() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.quotable.io/random',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return {
          'content': data['content'] ??
              'Stay positive and keep working hard.',

          'author':
              data['author'] ?? 'Unknown',
        };
      } else {
        return {
          'content':
              'Success comes from consistency.',

          'author': 'Motivation',
        };
      }
    } catch (e) {
      return {
        'content':
            'Never stop learning and improving yourself.',

        'author': 'Task Manager',
      };
    }
  }
}