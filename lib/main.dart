import 'package:expressions/expressions.dart'; // Add this dependency for evaluating expressions
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Multi Page App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // List of pages for bottom navigation
  final List<Widget> _pages = [
    CalculatorPage(),
    SearchPage(),
    LoginPage(),
  ];

  // List of page titles for AppBar
  final List<String> _titles = [
    'Calculator',
    'Search',
    'Login',
  ];

  // Change the selected index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]), // Change title based on the selected page
        backgroundColor: Colors.indigo, // AppBar color
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.indigo,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[300],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Login',
          ),
        ],
      ),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _output = "0";
  String _input = "";

  void _onButtonPressed(String value) {
    setState(() {
      if (value == "=") {
        try {
          _output = _calculate(_input);
        } catch (e) {
          _output = "Error";
        }
        _input = "";
      } else if (value == "C") {
        _input = "";
        _output = "0";
      } else {
        _input += value;
      }
    });
  }

  String _calculate(String input) {
    try {
      final expression = Expression.parse(input);
      final evaluator = const ExpressionEvaluator();
      var result = evaluator.eval(expression, {});
      return result.toString();
    } catch (e) {
      return "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Result: $_output',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        SizedBox(height: 20),
        _buildButtons(),
      ],
    );
  }

  Widget _buildButtons() {
    final buttons = [
      ['7', '8', '9', '/'],
      ['4', '5', '6', '*'],
      ['1', '2', '3', '-'],
      ['C', '0', '=', '+'],
    ];

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: buttons.map((row) {
            return Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: row.map((buttonText) {
                  return _buildButton(buttonText);
                }).toList(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildButton(String text) {
    return ElevatedButton(
      onPressed: () => _onButtonPressed(text),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        backgroundColor: Colors.blueAccent,
        shape: CircleBorder(),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _firstNameController,
            decoration: InputDecoration(labelText: 'First Name'),
          ),
          TextField(
            controller: _lastNameController,
            decoration: InputDecoration(labelText: 'Last Name'),
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              print('Logged in with: ${_firstNameController.text}, ${_lastNameController.text}, ${_emailController.text}');
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(labelText: 'Search Google'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final query = _searchController.text;
              if (query.isNotEmpty) {
                _launchGoogleSearch(query);
              }
            },
            child: Text('Search'),
          ),
        ],
      ),
    );
  }

  void _launchGoogleSearch(String query) {
    final searchUrl = 'https://www.google.com/search?q=$query';
    print('Launching Google search for: $searchUrl');
  }
}
