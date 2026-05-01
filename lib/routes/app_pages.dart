import 'package:blood_bank_app/binding/intial_binding.dart';
import 'package:blood_bank_app/routes/app_routes.dart';
import 'package:blood_bank_app/view/auth/rolechoose_screen.dart';
import 'package:blood_bank_app/view/bloodbank/create_profile_bloodbank.dart';
import 'package:blood_bank_app/view/bloodbank/home_page_bloodBank.dart';
import 'package:blood_bank_app/view/bloodbank/login_screen_bank.dart';
import 'package:blood_bank_app/view/bloodbank/signin_screen_bank.dart';
import 'package:blood_bank_app/view/bloodbank/manage_requests_screen.dart';
import 'package:blood_bank_app/view/donor/create_profile_donor.dart';
import 'package:blood_bank_app/view/donor/donation_request_screen.dart';
import 'package:blood_bank_app/view/donor/edit_personal_info_donor.dart';
import 'package:blood_bank_app/view/donor/history_screen_donor.dart';
import 'package:blood_bank_app/view/donor/home_page_donor.dart';
import 'package:blood_bank_app/view/donor/login_screen_donor.dart';
import 'package:blood_bank_app/view/donor/map_screen_donor.dart';
import 'package:blood_bank_app/view/donor/signin_screen_donor.dart';
import 'package:blood_bank_app/view/hospital/create_profile_hospital.dart';
import 'package:blood_bank_app/view/hospital/home_page_hospital.dart';
import 'package:blood_bank_app/view/hospital/login_screen_hospital.dart';
import 'package:blood_bank_app/view/hospital/signin_screen_hospital.dart';
import 'package:blood_bank_app/view/patient/create_profile_patient.dart';
import 'package:blood_bank_app/view/patient/create_request_screen.dart';
import 'package:blood_bank_app/view/patient/home_page_patient.dart';
import 'package:blood_bank_app/view/patient/login_screen_patient.dart';
import 'package:blood_bank_app/view/patient/signin_screen_patient.dart';
import 'package:blood_bank_app/view/splash_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splashPage, page: () => SplashScreen()),
    GetPage(name: AppRoutes.roleSelectionPage, page: () => RoleSelectionScreen()),

    // LOGIN
    GetPage(name: AppRoutes.loginDonor, page: () => LoginScreenDonor()),
    GetPage(name: AppRoutes.loginPatient, page: () => LoginScreenPatient()),
    GetPage(name: AppRoutes.loginHospital, page: () => LoginScreenHospital()),
    GetPage(name: AppRoutes.loginBloodBank, page: () => LoginScreenBank()),

    // SIGNUP
    GetPage(name: AppRoutes.signupDonor, page: () => SignUpScreenDonor()),
    GetPage(name: AppRoutes.signupPatient, page: () => SignUpScreenPatient()),
    GetPage(name: AppRoutes.signupHospital, page: () => SignUpScreenHospital()),
    GetPage(name: AppRoutes.signupBloodBank, page: () => SignUpScreenBank()),

    // DASHBOARD
    GetPage(name: AppRoutes.donorDashboard, page: () => HomeScreenDonor()),
    GetPage(name: AppRoutes.patientDashboard, page: () => HomeScreenPatient(),binding: InitialBinding()),
    GetPage(name: AppRoutes.hospitalDashboard, page: () => HomeScreenHospital(),binding: InitialBinding()),
    GetPage(name: AppRoutes.bloodBankDashboard, page: () => HomeScreenBloodBank(),binding: InitialBinding()),

    // CREATE PROFILE
    GetPage(
      name: AppRoutes.createProfileDonor,
      page: () => CreateProfileDonor(),
    ),
    GetPage(
      name: AppRoutes.createProfilePatient,
      page: () => CreateProfilePatientScreen(),
    ),
    GetPage(
      name: AppRoutes.createProfileBloodBank,
      page: () => CreateProfileBloodBank(),
    ),
    GetPage(
      name: AppRoutes.createProfileHospital,
      page: () => CreateProfileHospital(),
    ),

    GetPage(name: AppRoutes.donationHistoryDonor, page: () => HistoryScreenDonor()),
    GetPage(name: AppRoutes.MapScreenDonor, page: () => MapsScreen()),
    GetPage(name: AppRoutes.createRequestScreenDonor, page: ()=>CreateDonationRequestScreen()),
    GetPage(name: AppRoutes.createRequestScreenPatient, page: ()=>CreateRequestScreen()),

    GetPage(name: AppRoutes.settingScreen, page: () => HomeScreenDonor()),
    GetPage(name: AppRoutes.editPersonalDetailDonor, page: () => EditPersonalInfoDonor()),
    GetPage(name: AppRoutes.bloodBankManageRequests, page: () => ManageRequestsScreen()),
  ];
}
