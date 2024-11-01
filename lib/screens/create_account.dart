import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_round/controllers/signup_controller.dart';
import 'package:mate_round/routes/routes.dart';
import 'package:mate_round/utils/colors.dart';
import 'package:mate_round/utils/dimensions.dart';
import 'package:mate_round/widgets/password_text_field.dart';
import 'package:mate_round/widgets/remember_me_check_box.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  bool _isLoading = false;

  var emailController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  bool remember = false;

  void _onRememberMeChanged(bool isChecked) {
    remember = isChecked;
  }

  var signUpController = Get.put(SignUpController());

  Future<void> signUpClick() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String phoneNumber = phoneNumberController.text.trim();
    String country = prefs.getString('country') ?? "Unknown";
    String mobileDeviceId = "Unknown";
    String mobileDevice = "Unknown";

    if (!GetUtils.isEmail(email)) {
      Get.snackbar("Error", "Invalid email address");
      return;
    }

    if (password.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters long");
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    signUpController.isLoading.value = true;
    setState(() {
      _isLoading = true;
    });

    try {
      var response = await signUpController.signUp(
          email, password, phoneNumber, country, mobileDeviceId, mobileDevice);

      if (!response['error']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setString('token', response['token']);
        await prefs.setInt('userId', int.parse(response['userId'].toString()));
        await prefs.setInt('isPro', 0);
        await prefs.setInt('proType', 0);
        await prefs.setBool('remember', remember);
        setState(() {
          _isLoading = false;
        });

        Get.offAllNamed(AppRoutes.completeProfile);
      } else {}
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      signUpController.isLoading.value = false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.backgroundWhite
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // top space
                  SizedBox(
                    height: Dimensions.height100*1.5,
                  ),

                  //Create an account Text
                  Container(
                    margin: EdgeInsets.only(
                      top: Dimensions.screenHeight / 62.133,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create an account',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: Dimensions.screenHeight / 37.28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        Text(
                          'Connect with new people today!',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: Dimensions.screenHeight / 58.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //email address
                  Container(
                    margin: EdgeInsets.only(top: Dimensions.height20),
                    child: TextField(
                      controller: emailController,
                      style: TextStyle(
                        fontSize: Dimensions.screenHeight / 62.133,
                        color: AppColors.text,
                      ),
                      cursorColor: AppColors.primaryColor,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: 'Input email address',
                        labelStyle: TextStyle(
                          fontSize: Dimensions.font14,
                          fontWeight: FontWeight.w300,
                          color: AppColors.primaryColor,
                        ),
                        hintText: 'Input Email Address',
                        hintStyle: TextStyle(
                          fontSize: Dimensions.font14,
                          fontWeight: FontWeight.w300,
                          color: AppColors.text.withOpacity(0.5),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: Dimensions.width5 / Dimensions.width10,
                            color: AppColors.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(Dimensions.radius10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: Dimensions.width5 / Dimensions.width10,
                            color: AppColors.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(Dimensions.radius10),
                        ),
                      ),
                    ),
                  ),
                  // Phone number
                  Container(
                    margin: EdgeInsets.only(top: Dimensions.height20),
                    child: TextField(
                      controller: phoneNumberController,
                      style: TextStyle(
                        fontSize: Dimensions.screenHeight / 62.133,
                        color: AppColors.text,
                      ),
                      cursorColor: AppColors.primaryColor,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: 'Enter Phone number',
                        labelStyle: TextStyle(
                          fontSize: Dimensions.font14,
                          fontWeight: FontWeight.w300,
                          color: AppColors.primaryColor,
                        ),
                        hintText: 'Enter Phone number',
                        hintStyle: TextStyle(
                          fontSize: Dimensions.font14,
                          fontWeight: FontWeight.w300,
                          color: AppColors.text.withOpacity(0.5),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: Dimensions.width5 / Dimensions.width10,
                            color: AppColors.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(Dimensions.radius10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: Dimensions.width5 / Dimensions.width10,
                            color: AppColors.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(Dimensions.radius10),
                        ),
                      ),
                    ),
                  ),
                  // Password
                  Container(
                    margin: EdgeInsets.only(top: Dimensions.height20),
                    child: TextField(
                      controller: passwordController,
                      style: TextStyle(
                        fontSize: Dimensions.screenHeight / 62.133,
                        color: AppColors.text,
                      ),
                      cursorColor: AppColors.primaryColor,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: 'Choose Password',
                        labelStyle: TextStyle(
                          fontSize: Dimensions.font14,
                          fontWeight: FontWeight.w300,
                          color: AppColors.primaryColor,
                        ),
                        hintText: 'Choose your Password',
                        hintStyle: TextStyle(
                          fontSize: Dimensions.font14,
                          fontWeight: FontWeight.w300,
                          color: AppColors.text.withOpacity(0.5),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: Dimensions.width5 / Dimensions.width10,
                            color: AppColors.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(Dimensions.radius10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: Dimensions.width5 / Dimensions.width10,
                            color: AppColors.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(Dimensions.radius10),
                        ),
                      ),
                    ),
                  ),
                  //Confirm Password
                  Container(
                    margin: EdgeInsets.only(top: Dimensions.height20),
                    child: TextField(
                      controller: confirmPasswordController,
                      style: TextStyle(
                        fontSize: Dimensions.screenHeight / 62.133,
                        color: AppColors.text,
                      ),
                      cursorColor: AppColors.primaryColor,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(
                          fontSize: Dimensions.font14,
                          fontWeight: FontWeight.w300,
                          color: AppColors.primaryColor,
                        ),
                        hintText: 'Enter Password Again',
                        hintStyle: TextStyle(
                          fontSize: Dimensions.font14,
                          fontWeight: FontWeight.w300,
                          color: AppColors.text.withOpacity(0.5),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: Dimensions.width5 / Dimensions.width10,
                            color: AppColors.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(Dimensions.radius10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: Dimensions.width5 / Dimensions.width10,
                            color: AppColors.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(Dimensions.radius10),
                        ),
                      ),
                    ),
                  ),

                  //Sign up button
                  GestureDetector(
                    onTap: signUpClick,
                    child: Container(
                      height: Dimensions.height54,
                      width: double.maxFinite,
                      margin: EdgeInsets.only(
                        top: Dimensions.height20,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.orangeBtn,
                        borderRadius: BorderRadius.circular(Dimensions.radius20),
                      ),
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Create Account today',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimensions.screenHeight / 51.778,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: Dimensions.screenHeight / 1.1,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Get.offNamed(AppRoutes.getLogin());
                },
                child: SizedBox(
                  width: Dimensions.screenWidth / 1.229,
                  height: Dimensions.screenHeight / 37.28,
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: Dimensions.screenHeight / 51.778,
                            ),
                          ),
                          TextSpan(
                            text: 'Log in',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: Dimensions.screenHeight / 51.778,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
