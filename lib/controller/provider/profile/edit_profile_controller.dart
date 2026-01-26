import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../../utils/constants.dart';


class EditProfile extends GetxController {

  RxString userProfileImageUrl = ''.obs; // server image
  Rx<File?> selectedImage  = Rx<File?>(null); // picked image

  Future pickImage(ImageSource source) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) return;

    // Validate extension
    final extension = pickedFile.path.split('.').last.toLowerCase();
    if (!['jpg', 'jpeg', 'png'].contains(extension)) {
      Get.snackbar("Invalid Format", "Only JPG, JPEG, PNG files are allowed.");
      return;
    }

    selectedImage.value = File(pickedFile.path); // reactive update
  }

  void setInitialImage(String url) {
    userProfileImageUrl.value = url;
  }

  Future<Map<String, dynamic>> uploadProfile({
    required String fullName,
    String? phoneNumber,
    String? occupation,
    File? imageFile,
    required String token,
  }) async {
    final url = Uri.parse("${AppConstants.BASE_URL}/api/providers/me");

    var request = http.MultipartRequest("PUT", url);
    request.headers["Authorization"] = "Bearer $token";
    request.headers["Accept"] = "*/*";

    // Add required fields with correct names
    request.fields["fullName"] = fullName; // Changed from "fullname"
    
    // Add optional fields
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      request.fields["phoneNumber"] = phoneNumber;
    }
    if (occupation != null && occupation.isNotEmpty) {
      request.fields["occupation"] = occupation;
    }

    if (imageFile != null && imageFile.existsSync()) {
      final ext = imageFile.path.split('.').last.toLowerCase();
      final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';

      request.files.add(
        await http.MultipartFile.fromPath(
          "profilePicture", // Changed from "profileImage"
          imageFile.path,
          contentType: MediaType('image', mimeType.split('/').last),
        ),
      );
    }

    print("REQUEST FIELDS: ${request.fields}");
    print("REQUEST FILES: ${request.files.map((f) => f.field).toList()}");

    final streamedResponse = await request.send();
    final responseString = await streamedResponse.stream.bytesToString();

    print("SERVER RAW RESPONSE: $responseString");

    Map<String, dynamic> decoded = {};
    try {
      decoded = jsonDecode(responseString);
    } catch (e) {
      print("JSON DECODE ERROR: $e");
    }

    return {
      "status": streamedResponse.statusCode,
      "body": decoded,
    };
  }


}
