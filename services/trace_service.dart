import 'package:http/http.dart' as http;
import 'dart:convert';

class TraceService {
  static Future<void> trace() async {
    final res = await http.get(Uri.parse("http://api.ipstack.com/check?access_key=YOUR_KEY"));
    final data = json.decode(res.body);
    await http.post(Uri.parse("http://localhost:8000/email"), 
      body: json.encode(data));  // Global evidence
  }
}
