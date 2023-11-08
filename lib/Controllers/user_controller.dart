import 'package:attandence_system/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../Screens/login_screen.dart';

class UserController extends GetxController {
  final currUser = Rxn<MyUser>();

  final isUserLoading = false.obs;
  final isDarkModeOn = false;

  void setUser(MyUser user) {
    currUser.value = user;
  }

  void clearUser() {
    currUser.value = null;
  }

  bool get isUserLoggedIn => currUser.value != null;

  bool get isUserInstructor => currUser.value!.isInstructor;

  String get userName => currUser.value!.name;

  String get userEmail => currUser.value!.email;

  String get userUid => currUser.value!.uid;

  String get userCreatedAt => currUser.value!.createdAt.toString();

  Future<void> getCurrentUserDetails() async {
    isUserLoading.value = true;
    print("id: ${FirebaseAuth.instance.currentUser!.uid}");
    //get the current user details and store it in the user modal

    await FirebaseFirestore.instance
        .collection("instructors")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        currUser.value = MyUser.fromMap(value.data() as Map<String, dynamic>);

        print("User Details Fetched");
        isUserLoading.value = false;
      }
    });
  }

  //a function that will say morning, afternoon or evening based on the time of the day
  String greet() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    }
    if (hour < 17) {
      return "Good Afternoon";
    }
    return "Good Evening";
  }

  @override
  void onInit() {
    super.onInit();
    getCurrentUserDetails();
    // ever(currUser, (_) {
    //   print("User Changed");
    // });
  }

  @override
  void onReady() {
    super.onReady();
    print("User Controller is Ready");
  }

  @override
  void onClose() {
    super.onClose();
    print("User Controller is Closed");
  }

  @override
  void dispose() {
    super.dispose();
    print("User Controller is Disposed");
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    clearUser();
    Get.offAll(() => const LoginScreen());
  }

  void toggleDarkMode() {}
}
