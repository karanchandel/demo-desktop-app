import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Debug बैनर हटाएँ
      title: 'Simple Desktop Form App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal), // थीम को Teal में बदलें
        useMaterial3: true,
      ),
      // MyHomePage को SimpleFormScreen से बदलें
      home: const SimpleFormScreen(), 
    );
  }
}

// ---------------------------------------------
// 💡 Simple Form Screen (StatefulWidget)
// ---------------------------------------------

class SimpleFormScreen extends StatefulWidget {
  const SimpleFormScreen({super.key});

  @override
  State<SimpleFormScreen> createState() => _SimpleFormScreenState();
}

class _SimpleFormScreenState extends State<SimpleFormScreen> {
  // 1. Form को कंट्रोल और वैलिडेट करने के लिए GlobalKey
  final _formKey = GlobalKey<FormState>();

  // 2. Text Input को कंट्रोल करने के लिए Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // 3. Save बटन दबाने पर चलने वाला लॉजिक
  void _saveData() {
    // पहले फॉर्म को वैलिडेट करें
    if (_formKey.currentState!.validate()) {
      // अगर वैलिडेशन पास हो जाता है
      String name = _nameController.text;
      String email = _emailController.text;

      // 💡 यहाँ आपका डेटा सेविंग लॉजिक जाएगा (जैसे डेटाबेस, फ़ाइल, आदि)

      // सक्सेस मैसेज दिखाने के लिए ScaffoldMessenger का उपयोग करें
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data Saved! Name: $name, Email: $email'),
          duration: const Duration(seconds: 3),
        ),
      );
      
      // फ़ॉर्म को रीसेट करें (वैकल्पिक)
      _nameController.clear();
      _emailController.clear();
    }
  }

  @override
  void dispose() {
    // मेमोरी लीक से बचने के लिए Controllers को Dispose करें
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Data Entry Form"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView( // अगर विंडो छोटी हो तो स्क्रॉलिंग सक्षम करने के लिए
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // फॉर्म की को सेट करें
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              
              // --- A. Name Field ---
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                // वैलिडेशन: फील्ड खाली नहीं होनी चाहिए
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // --- B. Email Field ---
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'Enter a valid email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                // वैलिडेशन: ईमेल फॉर्मेट चेक करें
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email.';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),

              // --- C. Save Button ---
              ElevatedButton.icon(
                onPressed: _saveData, // Save लॉजिक कॉल करें
                icon: const Icon(Icons.save),
                label: const Text(
                  'SAVE DATA',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Theme.of(context).colorScheme.primary, // थीम कलर का उपयोग
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // FloatingActionButton हटा दिया गया है
    );
  }
}