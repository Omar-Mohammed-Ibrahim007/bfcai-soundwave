import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'startup.dart';
import 'themes/dark_theme.dart';
import 'services/auth_service.dart';
import 'services/favorites_service.dart';
import 'controllers/music_controller.dart';
import 'controllers/songs_controller.dart';
import 'controllers/artist_controller.dart';
import 'widgets/login_page.dart';
import 'widgets/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Startup.initialize();
  runApp(const JELMusicApp());
}

class JELMusicApp extends StatelessWidget {
  const JELMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(
          create: (_) => FavoritesService()..loadFavorites(),
        ),
        ChangeNotifierProvider(create: (_) => MusicController()),
        ChangeNotifierProvider(create: (_) => SongsController()),
        ChangeNotifierProvider(create: (_) => ArtistController()),
      ],
      child: MaterialApp(
        title: 'Jamendo',
        debugShowCheckedModeBanner: false,
        theme: darkTheme,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}
