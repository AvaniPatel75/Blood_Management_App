import 'package:blood_bank_app/controller/hospital_controller.dart';
import 'package:blood_bank_app/controller/patient_controller.dart';
import 'package:get/get.dart';

import '../controller/blood_bank_controller.dart';
import '../controller/user_controller.dart';
import '../controller/donor_controller.dart';
import '../controller/blood_request_controller.dart';
import '../controller/donation_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserController(), permanent: true);
    Get.put(DonorController(), permanent: true);
    Get.put(BloodRequestController(), permanent: true);
    Get.put(DonationController(), permanent: true);
    Get.put(PatientController(),permanent: true);
    Get.put(HospitalController(),permanent: true);
    Get.put(BloodBankController(),permanent: true);
  }
}
