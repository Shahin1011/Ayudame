import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/business_employee_model.dart';
import '../services/business_employee_service.dart';

class BusinessEmployeeViewModel extends GetxController {
  final BusinessEmployeeService _service = BusinessEmployeeService();

  var isLoading = false.obs;
  var employeeList = <BusinessEmployeeModel>[].obs;
  var currentEmployee = Rxn<BusinessEmployeeModel>();

  @override
  void onInit() {
    super.onInit();
    fetchAllEmployees();
  }

  /// Fetch all employees
  Future<void> fetchAllEmployees() async {
    isLoading.value = true;
    try {
      final employees = await _service.getAllEmployees();
      employeeList.assignAll(employees);
    } catch (e) {
      debugPrint("Error fetching employees: $e");
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
      await fetchAllEmployees(); // Refresh list
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
      await fetchAllEmployees(); // Refresh list
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

  /// Fetch Employee Stats
  Future<void> fetchEmployeeStats(String id) async {
    // Don't set full page loading for stats
    try {
      final data = await _service.getEmployeeStats(id);
      employeeStats.value = data;
    } catch (e) {
      debugPrint("❌ Error fetching employee stats: $e");
    }
  }
}
