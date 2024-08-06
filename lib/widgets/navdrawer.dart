import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:test/global/colors.dart';
import 'package:test/views/dogprofil.dart';
import 'package:test/views/login.dart';
import 'package:test/views/ownerbidlist.dart';
import 'package:test/views/ownermywalks.dart';
import 'package:test/views/ownerprofil.dart';
import 'package:test/views/walkerbidlist.dart';
import 'package:test/views/walkermywalks.dart';
import 'package:test/views/walkerprofil.dart';

import '../providers/auth.dart';
import '../views/register.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  final storage = const FlutterSecureStorage();

  void _attemptAuthentication() async {
    String? key = await storage.read(key: 'auth');
    Provider.of<Auth>(context, listen: false).attempt(key);
  }

  @override
  void initState() {
    super.initState();
    _attemptAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Consumer<Auth>(
        builder: ((context, auth, child) {
          if (auth.authenticated) {
            return ListView(
              children: [
                // ignore: unnecessary_null_comparison
                DrawerHeader(
                  child: auth == null
                      ? const CircleAvatar(
                          backgroundColor: primary,
                        )
                      : ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: primary,
                            // child: ,
                          ),
                          title: Text(auth.user?.name ?? ''),
                          subtitle: Text(
                            auth.user?.email ?? '',
                            style: const TextStyle(fontSize: 11),
                          ),
                          // trailing: Text(auth.user?.id ?? ''),
                        ),
                ),
                if (auth.isOwner)
                  ListTile(
                      leading: const Icon(Icons.nordic_walking),
                      title: const Text('Bid list'),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  const Ownerbidlist()),
                        );
                      }),
                if (auth.isOwner) const Divider(),
                if (auth.isOwner)
                  ListTile(
                      leading: const Icon(Icons.nordic_walking),
                      title: const Text('My walks'),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  const Ownermywalks()),
                        );
                      }),
                if (auth.isOwner) const Divider(),
                if (auth.isOwner)
                  ListTile(
                      leading: const Icon(FontAwesomeIcons.dog),
                      title: const Text('My Dog'),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) => const Dogprofil()),
                        );
                      }),
                if (auth.isOwner) const Divider(),

                if (auth.isWalker)
                  ListTile(
                      leading: const Icon(Icons.directions_walk),
                      title: const Text('Bid list'),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  const Walkerbidlist()),
                        );
                      }),
                if (auth.isWalker) const Divider(),
                if (auth.isWalker)
                  ListTile(
                      leading: const Icon(Icons.directions_walk),
                      title: const Text('My walks'),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  const Walkermywalks()),
                        );
                      }),
                if (auth.isWalker) const Divider(),
                ListTile(
                    leading: const Icon(Icons.person_pin),
                    title: const Text('My Profile'),
                    onTap: () async {
                      if (auth.isWalker) {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  const Walkerprofil()),
                        );
                      }
                      if (auth.isOwner) {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) => const Ownerprofil()),
                        );
                      }
                    }),
                const Divider(),

                ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('logout'),
                    onTap: () {
                      Provider.of<Auth>(context, listen: false).logout();
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (_, __, ___) => const Login()),
                      );
                    }),
                const Divider(),
              ],
            );
          } else {
            return ListView(
              children: [
                ListTile(
                    title: const Text('register'),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const Register())))),
                ListTile(
                  title: const Text('Login'),
                  onTap: (() => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const Login())))),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}
