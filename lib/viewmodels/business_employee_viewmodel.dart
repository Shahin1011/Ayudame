import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/business_employee_model.dart';
import '../services/business_employee_service.dart';
import 'package:url_launcher/url_launcher.dart';

class BusinessEmployeeViewModel extends GetxController {
  final BusinessEmployeeService _service = BusinessEmployeeService();

  var isLoading = false.obs;
  var employeeList = <BusinessEmployeeModel>[].obs;
  var currentEmployee = Rxn<BusinessEmployeeModel>();

  var isInitialLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (!isInitialLoaded.value) {
      fetchAllEmployees();
    }
  }

  /// Fetch all employees
  Future<void> fetchAllEmployees({bool forceRefresh = true}) async {
    if (isLoading.value) return;
    if (isInitialLoaded.value && !forceRefresh) return;

    isLoading.value = true;
    try {
      final employees = await _service.getAllEmployees();
      employeeList.assignAll(employees);
      isInitialLoaded.value = true;
    } catch (e) {
      debugPrint("Error fetching employees: $e");
      // Optionally show snackbar if it's a critical fetch
      if (forceRefresh && isInitialLoaded.value) {
        Get.snackbar(
          "Notice",
          "Could not refresh employee list",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch single employee detail
  Future<void> fetchEmployeeDetail(String id) async {
    isLoading.value = true;
    try {
      final employee = await _service.getEmployeeDetail(id);
      currentEmployee.value = employee;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load employee details",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Create new employee
  Future<bool> createEmployee({
    required BusinessEmployeeModel employee,
    String? idCardFront,
    String? idCardBack,
  }) async {
    isLoading.value = true;
    try {
      await _service.createEmployee(
        employee: employee,
        idCardFront: idCardFront,
        idCardBack: idCardBack,
      );
      await fetchAllEmployees(forceRefresh: true); // Refresh list
      Get.back(); // Close screen
      Get.snackbar(
        "Success",
        "Employee created successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString().replaceAll("Exception: ", ""),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update employee
  Future<bool> updateEmployee({
    required String id,
    required BusinessEmployeeModel employee,
    String? idCardFront,
    String? idCardBack,
  }) async {
    isLoading.value = true;
    try {
      await _service.updateEmployee(
        id: id,
        employee: employee,
        idCardFront: idCardFront,
        idCardBack: idCardBack,
      );
      await fetchAllEmployees(forceRefresh: true); // Refresh list
      if (currentEmployee.value?.id == id) {
        // Optimistically update current view or let fetch do it
        // currentEmployee.value = employee;
      }
      Get.back(); // Close screen
      Get.snackbar(
        "Success",
        "Employee updated successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString().replaceAll("Exception: ", ""),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete employee
  Future<void> deleteEmployee(String id) async {
    // Show confirmation dialog?
    isLoading.value = true;
    try {
      await _service.deleteEmployee(id);
      employeeList.removeWhere((e) => e.id == id);
      Get.back(); // If in detail screen
      Get.snackbar(
        "Success",
        "Employee removed successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to delete employee",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isLoading.value = false;
    }
  }

  var employeeStats = Rxn<Map<String, dynamic>>();
  var isStatsLoading = false.obs;

  /// Fetch Employee Stats
  Future<void> fetchEmployeeStats(String id) async {
    isStatsLoading.value = true;
    try {
      final data = await _service.getEmployeeStats(id);
      employeeStats.value = data;
    } catch (e) {
      debugPrint("❌ Error fetching employee stats: $e");
    } finally {
      isStatsLoading.value = false;
    }
  }

  var searchResults = <BusinessEmployeeModel>[].obs;
  var isSearching = false.obs;

  // Track if search mode is active (query is not empty)
  // distinct from isSearching (loading state)
  var isSearchActive = false.obs;

  Timer? _debounce;

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  /// Search Employees with Debounce
  void searchEmployees(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.trim().isEmpty) {
      isSearchActive.value = false;
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    isSearchActive.value = true;
    isSearching.value =
        true; // Show loading immediately while waiting to debounce?
    // Or wait to show loading? Usually better to show loading only when request starts.
    // Let's set loading inside timer.

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        isSearching.value = true;
        final results = await _service.searchEmployees(query);
        searchResults.assignAll(results);
      } catch (e) {
        debugPrint("❌ Error searching employees: $e");
        searchResults.clear();
      } finally {
        isSearching.value = false;
      }
    });
  }

  /// Make Phone Call
  Future<void> makePhoneCall(String id) async {
    try {
      final phone = await _service.getEmployeePhone(id);
      if (phone != null && phone.isNotEmpty) {
        final Uri launchUri = Uri(scheme: 'tel', path: phone);
        // Add queries in AndroidManifest.xml for 'tel' scheme support
        if (await canLaunchUrl(launchUri)) {
          await launchUrl(launchUri);
        } else {
          // Fallback: Try launching anyway
          try {
            await launchUrl(launchUri);
          } catch (e) {
            Get.snackbar("Error", "Could not launch dialer: $e");
          }
        }
      } else {
        Get.snackbar("Info", "Phone number not available");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed: $e");
    }
  }

  /// Toggle Employee Status
  Future<bool> toggleEmployeeStatus(String id) async {
    try {
      final success = await _service.toggleEmployeeStatus(id);
      if (success) {
        await fetchAllEmployees(forceRefresh: true);
        // Also fetch detail to update current view if needed
        // await fetchEmployeeDetail(id);
        Get.snackbar(
          "Success",
          "Employee status updated successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar("Error", "Failed to update status");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed: $e");
      return false;
    }
  }
}
