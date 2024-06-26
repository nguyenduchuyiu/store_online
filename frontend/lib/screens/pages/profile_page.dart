// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:ali33/bloc/cart_bloc.dart';
import 'package:ali33/constants/route_animation.dart';
import 'package:ali33/models/user_model.dart';
import 'package:ali33/screens/cart.dart';
import 'package:ali33/screens/comming_soon.dart';
import 'package:ali33/screens/delivery_address.dart';
import 'package:ali33/screens/login.dart';
import 'package:ali33/screens/orders.dart';
import 'package:ali33/screens/pages/home_page.dart';
import 'package:ali33/screens/profile.dart';
import 'package:ali33/services/api_service.dart';
import 'package:ali33/services/authenticate_service.dart';
import 'package:ali33/services/theme_provider_service.dart';
import 'package:ali33/widgets/basic.dart';
import 'package:ali33/widgets/build_photo.dart';
import 'package:ali33/widgets/error_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ali33/screens/home.dart';


// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<UserModel?>? user ;
  late AppThemeNotifier appThemeNotifier;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    appThemeNotifier = Provider.of<AppThemeNotifier>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    user = UserService.authenticateUser(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        flexibleSpace: 
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                // shrinkWrap: true, 
                height: 80,
                width: size.width-16*2,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
Color(0xff404258), // Start color
Color(0xff474E68),
Color(0xff50577A),
Color(0xff6B728E) // End color
                    ]
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const HomeScreen(selectedPage: 0)), // Giả sử HomePage là trang đầu tiên trong HomeScreen
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Image.asset("images/logo.png", height: 50,),
                  ),
                  const SizedBox(width: 10,),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 18,),
                      Text("Your Personal",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(fontWeight: FontWeight.w700,fontSize: 17)),
                      Text("Hollywood at Home",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(fontWeight: FontWeight.w500,fontSize: 15)),
                    ],
                  ),
                  ]

          // titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
        ),),),
      body:FutureBuilder(
        future: user,
        builder: (context, AsyncSnapshot<UserModel?> snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return loadingAnimation();
          } else if (snapshots.hasError) {
            return buildErrorWidget(context, () => UserService.authenticateUser(context));
          }
          if (snapshots.data == null) {
            return buildErrorWidget(
                context, () => UserService.authenticateUser(context), "User not Found! Try again");
          }
          print(snapshots.data);

          return SingleChildScrollView(
            child: Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
Color(0xff404258), // Start color
Color(0xff474E68),
Color(0xff50577A),
Color(0xff6B728E) // End color
                    ]
                  ),
                ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  snapshots.data!.profilePic != ""
                      ? buildCircularProfilePhoto(snapshots.data!.profilePic,
                          appThemeNotifier.darkTheme, size.height * 0.2)
                      : buildPlaceholderPhoto(
                          appThemeNotifier.darkTheme, size.height * 0.2),
                  SizedBox(height: size.height * 0.01),
                  Container(
                    height: 140,
                    width: 360,
                    child: GestureDetector(
                    onTap: () async {
                      bool res = await Navigator.push(
                        context,
                        SlideLeftRoute(
                            widget: ProfileScreen(
                          isFirstTime: false,
                          userModel: snapshots.data!,
                        )),
                      );
                      if (res) {
                        await UserService.authenticateUser(context);
                        setState(() {});
                      }
                    },
                    child: Card(
                      color: Theme.of(context).primaryColor,
                      elevation: 2,
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 Text(snapshots.data!.shopName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                Text(
                                  "Edit",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge !
                                      .copyWith(color: Colors.white),
                                )
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.phone, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  snapshots.data!.phoneNo,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(snapshots.data!.emailId,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(
                                          color: Colors.white,
                                        )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  Container(

                    width: 400,
                    height: 300,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      children: [
                        Expanded( 
                        child : ListView.separated(

                          itemCount: 4, // Số lượng item, cần điều chỉnh cho phù hợp
                          itemBuilder: (context, index) {
                            switch(index) {
                              case 0: return buildItem("Cart Items", () => Navigator.push(context, SlideLeftRoute(widget: BlocProvider<CartBloc>(create: (context) => CartBloc(), child: const CartScreen(),),)));
                              case 1: return buildItem("Orders", () => Navigator.push(context, SlideLeftRoute(widget: const OrdersScreen())));
                              case 2: return buildItem("My Address", () => Navigator.push(context, SlideLeftRoute(widget:const ComingSoonScreen())));
                              case 3: return buildItem("Theme Mode", () => Navigator.push(context, SlideLeftRoute(widget:const ComingSoonScreen())));
                              default: return Container();
                            }
                          },
                          separatorBuilder: (context, index) => const SizedBox(height: 20),  // Khoảng cách giữa các item
                        ),),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () async {
                            bool res = await ApiService().logout();
                            if (res) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  SlideRightRoute(
                                      widget: const LoginScreen(isEditing: true)),
                                  (route) => false);
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 150,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "Logout",
                                  style:
                                      Theme.of(context).textTheme.displayLarge!.copyWith(
                                            color: Colors.white,
                                          ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(
                                  Icons.logout_outlined,
                                  color: Colors.white,
                                )
                              ],
                            )    ,
                          )
                        )],
                    ),
                  ),
                  SizedBox(height: size.height/8,)
                ],
              ),
            ),
          );
        }
        ));
  }

  Widget buildItem(String title, Function() onPress) {
    return InkWell(
      onTap: onPress,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const Icon(Icons.keyboard_arrow_right, size: 30)
            ],
          ),
          const SizedBox(height: 2),
          const Divider(thickness: 2),
        ],
      ),
    );
  }
}