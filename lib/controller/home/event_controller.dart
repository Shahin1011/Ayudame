import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../models/user/home/event_model.dart';
import '../../utils/constants.dart';
import '../../utils/token_service.dart';


class EventController extends GetxController {
  var isLoading = false.obs;
  var eventList = <EventModel>[].obs;
  var errorMessage = ''.obs;

  final String eventsUrl = "${AppConstants.BASE_URL}/api/home/popular-events";


  @override
  void onInit() {
    fetchEvents();
    super.onInit();
  }

  Future<void> fetchEvents() async {
    try {
      isLoading(true);
      errorMessage('');

      final token = await TokenService().getToken();
      if (token == null || token.isEmpty) {
        errorMessage.value = "No authentication token";
        return;
      }
      final response = await http.get(Uri.parse(eventsUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("Events API Status: ${response.statusCode}");
      print("Events API Body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List events = body['data']['events'];

        eventList.value = events.map((e) => EventModel.fromJson(e)).toList();
      }else{
        errorMessage.value = "Failed to load Events";
      }
    } catch(e) {
      errorMessage.value = e.toString();
    }
    finally {
      isLoading(false);
    }
  }
}
