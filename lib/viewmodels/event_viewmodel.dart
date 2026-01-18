import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middle_ware/models/event_model.dart';
import 'package:middle_ware/services/event_manager_service.dart';

class EventViewModel extends GetxController {
  final EventManagerService _eventService = EventManagerService();

  // Observables
  var isLoading = false.obs;
  var events = <EventModel>[].obs;
  var selectedEvent = Rxn<EventModel>();
  var stats = <String, dynamic>{}.obs;

  // Pagination
  var currentPage = 1.obs;
  var hasNextPage = true.obs;
  var currentStatus = 'draft'.obs; // Default filter

  @override
  void onInit() {
    super.onInit();
  }

  void _handleError(dynamic e) {
    String errorMsg = e.toString().replaceAll('Exception: ', '');
    print("❌ API Error: $errorMsg");

    if (errorMsg.toLowerCase().contains("token") &&
        (errorMsg.toLowerCase().contains("expired") ||
            errorMsg.toLowerCase().contains("expaired") ||
            errorMsg.toLowerCase().contains("unauthorized"))) {
      Get.snackbar(
        "Session Expired",
        "Please login again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      // Clear data and redirect
      Get.offAllNamed('../event-login'); // Or whatever the login route is
    } else {
      Get.snackbar(
        "Error",
        errorMsg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Create Status
  Future<void> createEvent({
    required Map<String, dynamic> fields,
    String? imagePath,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    try {
      isLoading.value = true;
      final response = await _eventService.createEvent(fields, imagePath);

      // onSuccess
      Get.snackbar(
        "Success",
        response['message'] ?? "Event created successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      onSuccess();
    } catch (e) {
      String errorMsg = e.toString().replaceAll('Exception: ', '');
      Get.snackbar(
        "Error",
        errorMsg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      onError(errorMsg);
    } finally {
      isLoading.value = false;
    }
  }

  /// Get Events List
  Future<void> fetchEvents({
    String status = 'draft',
    bool refresh = false,
  }) async {
    if (refresh) {
      currentPage.value = 1;
      events.clear();
      hasNextPage.value = true;
    }

    if (!hasNextPage.value) return;

    try {
      isLoading.value = true;
      final response = await _eventService.getEvents(
        page: currentPage.value,
        limit: 10,
        status: status,
      );

      final List<dynamic> eventList = response['data']['events'] ?? [];
      // final meta =
      //     response['data']['meta']; // Assuming standard pagination meta

      if (eventList.isEmpty) {
        hasNextPage.value = false;
      } else {
        final newEvents = eventList.map((e) => EventModel.fromJson(e)).toList();
        events.addAll(newEvents);
        currentPage.value++;
      }
      currentStatus.value = status;
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Get Event Details
  Future<void> fetchEventDetails(String eventId) async {
    try {
      isLoading.value = true;
      final response = await _eventService.getEventById(eventId);
      final eventData = response['data'];
      if (eventData != null) {
        selectedEvent.value = EventModel.fromJson(eventData);
      }
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Update Event
  Future<void> updateEvent(
    String eventId,
    Map<String, dynamic> fields,
    String? imagePath, {
    VoidCallback? onSuccess,
  }) async {
    try {
      isLoading.value = true;
      await _eventService.updateEvent(eventId, fields, imagePath);
      Get.snackbar(
        "Success",
        "Event updated successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      if (onSuccess != null) {
        onSuccess();
      } else {
        await fetchEventDetails(
          eventId,
        ); // Refresh details if not navigating away
      }
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Publish Event
  Future<void> publishEvent(String eventId) async {
    try {
      isLoading.value = true;
      await _eventService.publishEvent(eventId);
      Get.snackbar(
        "Success",
        "Event published successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // Update state in list and selected event
      if (selectedEvent.value?.id == eventId) {
        selectedEvent.value?.status = 'published';
        selectedEvent.refresh();
      }

      final index = events.indexWhere((e) => e.id == eventId);
      if (index != -1) {
        events[index].status = 'published';
        events.refresh();
      }

      fetchStats(); // Update dashboard counts
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Cancel Event
  Future<void> cancelEvent(String eventId, String reason) async {
    try {
      isLoading.value = true;
      await _eventService.cancelEvent(eventId, reason);
      Get.snackbar(
        "Success",
        "Event cancelled",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      if (selectedEvent.value?.id == eventId) {
        selectedEvent.value?.status = 'cancelled';
        selectedEvent.refresh();
      }

      // Remove from the current filtered list so it "deletes" from view
      events.removeWhere((e) => e.id == eventId);
      events.refresh();

      fetchStats(); // Update dashboard counts
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Get Stats
  Future<void> fetchStats() async {
    try {
      final response = await _eventService.getStats();
      if (response['data'] != null) {
        stats.value = response['data'];
      }
    } catch (e) {
      _handleError(e);
    }
  }
}
