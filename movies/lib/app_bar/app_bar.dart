import 'package:flutter/material.dart';
import 'package:movies/Colors/colors_theme.dart';
import 'package:movies/models/providers/provider_account.dart';
import 'package:movies/models/providers/provider_home.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _openProfile(ProviderHome homeProvider) {
      if (homeProvider.currentPageIndex != 2) {
        homeProvider.updateCurrentPageIndex(2);
      }
    }

    _openDrawer(ProviderHome homeProvider) {
      homeProvider.scaffoldKey.currentState?.openDrawer();
    }

    return Consumer<ProviderHome>(builder: (context, homeProvider, child) {
      return Consumer<ProviderAccount>(
          builder: (context, accountProvider, child) {
        return AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          backgroundColor: ColorSelect.customBlue,
          leading: IconButton(
              icon: const Icon(
                Icons.account_circle_outlined,
                size: 30,
              ),
              onPressed: () => _openProfile(homeProvider)),
          title: Center(
              child: RichText(
                  text: TextSpan(children: [
            const TextSpan(
                text: "Hi",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            TextSpan(
                text:
                    ", ${accountProvider.name == '' ? 'user' : accountProvider.name}",
                style: const TextStyle(fontSize: 22))
          ]))),
          actions: [
            IconButton(
                icon: const Icon(Icons.menu_rounded, size: 30),
                onPressed: () => _openDrawer(homeProvider)),
            const Padding(padding: EdgeInsets.only(right: 15)),
          ],
        );
      });
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
