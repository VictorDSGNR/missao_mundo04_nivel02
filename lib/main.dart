import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animations/animations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explore Mundo - Turismo RJ',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final List<String> _titulos = [
    'Cristo Redentor',
    'Maracanã',
    'Fluminense Football Club'
  ];

  final List<String> _descricoes = [
    "O Cristo Redentor é um dos monumentos mais famosos do mundo e símbolo do Rio de Janeiro. Localizado no topo do Morro do Corcovado, oferece uma vista espetacular da cidade.",
    "O Estádio do Maracanã é um dos templos do futebol mundial. Foi palco de finais de Copa do Mundo e recebe partidas emocionantes dos principais clubes do Rio, incluindo o Fluminense.",
    "Fundado em 1902, o Fluminense é um dos clubes mais tradicionais do Brasil. Sua torcida é apaixonada e o time tem sede nas Laranjeiras, além de jogar frequentemente no Maracanã.",
  ];

  final List<String> _imagens = [
    'images/cristo.jpg',
    'images/maracana.jpg',
    'images/fluminense.jpg'
  ];

  final Map<String, int> _curtidas = {
    'Cristo Redentor': 0,
    'Maracanã': 0,
    'Fluminense Football Club': 0,
  };

  final Map<String, bool> _curtido = {
    'Cristo Redentor': false,
    'Maracanã': false,
    'Fluminense Football Club': false,
  };

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _titulos.length, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  void _abrirTelefone() async {
    final Uri url = Uri(scheme: 'tel', path: '21999999999');
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  void _abrirMapa(String query) async {
    final Uri url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  void _compartilhar(String query) async {
    final Uri url = Uri.parse("https://pt.wikipedia.org/wiki/$query");
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  void _toggleCurtida(String destino) {
    setState(() {
      _curtido[destino] = !_curtido[destino]!;
      _curtidas[destino] =
          _curtido[destino]! ? _curtidas[destino]! + 1 : _curtidas[destino]! - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _tabController.index;
    final titulo = _titulos[currentIndex];
    final descricao = _descricoes[currentIndex];
    final imagem = _imagens[currentIndex];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Container(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'images/explore.png',
              fit: BoxFit.contain,
              height: 60,
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Cristo Redentor"),
              Tab(text: "Maracanã"),
              Tab(text: "Fluminense"),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation, secondaryAnimation) =>
                  FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              ),
              child: _buildCard(titulo, descricao, imagem),
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.green,
            padding: const EdgeInsets.all(8),
            child: const Center(
              child: Text(
                'App Explore Mundo - Desenvolvido por Victor de A. Costa',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String description, String imagePath) {
    return SingleChildScrollView(
      key: ValueKey(title), // importante para o PageTransitionSwitcher
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(imagePath, fit: BoxFit.cover),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _curtido[title]! ? Icons.star : Icons.star_border,
                          color: _curtido[title]! ? Colors.yellow : Colors.white,
                        ),
                        onPressed: () => _toggleCurtida(title),
                      ),
                      Text(
                        '${_curtidas[title]} Curtidas',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: _abrirTelefone,
                  icon: const Icon(Icons.call),
                  label: const Text("Ligar"),
                ),
                ElevatedButton.icon(
                  onPressed: () => _abrirMapa(title),
                  icon: const Icon(Icons.map),
                  label: const Text("Mapa"),
                ),
                ElevatedButton.icon(
                  onPressed: () => _compartilhar(title),
                  icon: const Icon(Icons.share),
                  label: const Text("Compartilhar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
