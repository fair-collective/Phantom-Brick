import 'package:http/http.dart' as http;
import 'dart:convert';

class GSMAIntegration {
  static Future<void> reportStolen(imei: String, country: String) async {
    final res = await http.post(Uri.parse("https://ctir.gsma.com/api/report"), 
      headers: {"Authorization": "Bearer YOUR_GSMA_TOKEN", "Content-Type": "application/json"},
      body: json.encode({
        "imei": imei,
        "status": "stolen",
        "country": country,  // "ZA" for South Africa
        "description": "Reported via Phantom Brick app"
      })
    );
    if (res.statusCode == 200) {
      print("IMEI $imei blacklisted globally via GSMA CTIR.");
    }
  }
}
