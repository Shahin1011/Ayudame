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
    required String fullname,
    File? profilePicture,
    String? phoneNumber,
    required String token,
  }) async {
    final url = Uri.parse("${AppConstants.BASE_URL}/api/auth/me");

    var request = http.MultipartRequest("PUT", url);
    request.headers["Authorization"] = "Bearer $token";
    request.headers["Accept"] = "*/*";

    request.fields["fullname"] = fullname;

    if (profilePicture != null && profilePicture.existsSync()) {
      final ext = profilePicture.path.split('.').last.toLowerCase();
      final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';

      request.files.add(
        await http.MultipartFile.fromPath(
          "profileImage",
          profilePicture.path,
          contentType: MediaType('image', mimeType.split('/').last),
        ),
      );
    }

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