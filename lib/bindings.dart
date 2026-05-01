// lib/binding/initial_binding.dart
import 'package:blood_bank_app/controller/donor_controller.dart';
import 'package:blood_bank_app/controller/patient_controller.dart';
import 'package:get/get.dart';
import 'package:blood_bank_app/controller/user_controller.dart';
import 'package:blood_bank_app/controller/blood_bank_controller.dart';


class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // User Controller (handles login, roles)
    Get.lazyPut<UserController>(() => UserController());
    // Blood Bank Controller (manages bank inventory & requests)
    // Get.lazyPut<BloodBankController>(() => BloodBankController(bloodBank));

    // Hospital Controller (manages hospital dashboard & requests)
    Get.lazyPut<DonorController>(() => DonorController());
    Get.lazyPut<PatientController>(() => PatientController());
  }
}
