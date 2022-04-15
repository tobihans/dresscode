import 'package:dresscode/components/login_screen.dart';
import 'package:dresscode/components/register_screen.dart';
import 'package:dresscode/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:dresscode/utils/colors.dart';
import 'package:dresscode/screens/home.dart';
import 'package:dresscode/screens/shop.dart';
import 'package:dresscode/screens/item_details.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DressCode',
      initialRoute: Routes.login,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: CustomColors.material['primary'],
        appBarTheme: AppBarTheme(
          elevation: 0,
          foregroundColor: CustomColors.material['primaryText'],
          backgroundColor: Color(CustomColors.raw['primaryBg']!),
          titleTextStyle: TextStyle(
            color: Color(
              CustomColors.raw['primaryText']!,
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 0,
          backgroundColor: CustomColors.material['primary']!.withAlpha(220),
        ),
        textTheme: GoogleFonts.notoSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      routes: <String, Widget Function(BuildContext)>{
        Routes.home: (context) => const HomeScreen(),
        Routes.shop: (context) => const ShopScreen(),
        Routes.details: (context) => const ItemDetailsScreen(),
        Routes.login: (context) => const LoginScreen(),
        Routes.register: (context) => const RegisterScreen(),
      },
    );
  }
}
