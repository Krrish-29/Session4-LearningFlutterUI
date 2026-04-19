import 'package:flutter/material.dart';

// The `main` function is the entry point of every Dart program. In Flutter
// `runApp` attaches the provided widget (`FlutterUiDemoApp`) to the screen
// and starts the Flutter framework.
void main() => runApp(const FlutterUiDemoApp());

// ---------------- App Root (Stateful) ----------------
// `FlutterUiDemoApp` is a StatefulWidget because it holds the app-level
// theme state. StatefulWidget separates the immutable widget configuration
// from the mutable `State` object that holds changing data.
class FlutterUiDemoApp extends StatefulWidget {
  const FlutterUiDemoApp({Key? key}) : super(key: key);

  @override
  State<FlutterUiDemoApp> createState() => _FlutterUiDemoAppState();
}

// The private State class for `FlutterUiDemoApp`. It stores mutable fields
// (like `_isDark`) and implements the `build` method to describe the UI.
class _FlutterUiDemoAppState extends State<FlutterUiDemoApp> {
  // Private boolean that toggles between light and dark theme. The leading
  // underscore makes the field private to this file.
  bool _isDark = false;

  // Toggle function that flips the theme. `setState` tells Flutter to
  // re-run `build` and update any widgets that depend on this state.
  void _toggleTheme() => setState(() => _isDark = !_isDark);

  // `build` returns the widget tree for this part of the app. It runs again
  // whenever `setState` is called for this State object.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application title shown by the OS in some contexts.
      title: 'Flutter UI Demo',
      // Light and dark theme definitions. These are `ThemeData` objects.
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      // `themeMode` chooses which theme to apply (light/dark/system).
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      // `home` is the default route displayed at app start. We pass the
      // theme toggle callback so the home page can change the theme.
      home: DemoHomePage(onToggleTheme: _toggleTheme, isDark: _isDark),
    );
  }
}

// ---------------- Home Page (Stateless) ----------------
// This stateless page provides navigation to many demo pages. It does not
// need mutable state itself because it receives all data through parameters.
class DemoHomePage extends StatelessWidget {
  // Callback to toggle the app theme (provided by the parent widget).
  final VoidCallback onToggleTheme;
  // Current theme state passed down for display purposes (controls icon).
  final bool isDark;

  // Use named required parameters for clarity and safety.

  // Build a Scaffold with an AppBar and a ListView of navigation tiles.
  const DemoHomePage({required this.onToggleTheme, required this.isDark, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter UI Examples'),
        actions: [
          // IconButton shows a theme icon and calls the provided callback.
          IconButton(
            icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: onToggleTheme,
            tooltip: 'Toggle theme',
          ),
        ],
      ),
      // ListView makes the list scrollable if it does not fit on-screen.
      body: ListView(
        children: [
          // Each tile navigates to a different demo page.
          _tile(context, 'Stateless widget', const StatelessDemoPage()),
          _tile(context, 'Stateful (counter)', const StatefulCounterPage()),
          _tile(context, 'Layout (Row/Column/Expanded)', const LayoutDemoPage()),
          _tile(context, 'Scrolling (ListView)', const ScrollingDemoPage()),
          _tile(context, 'Forms (TextField & validation)', const FormsDemoPage()),
          _tile(context, 'Async (FutureBuilder / StreamBuilder)', const AsyncDemoPage()),
          _tile(context, 'Animation (AnimatedContainer)', const AnimationDemoPage()),
          _tile(context, 'Gesture (GestureDetector / InkWell)', const GestureDemoPage()),
        ],
      ),
    );
  }

  // Simple helper that builds a ListTile and pushes a new page when tapped.
  Widget _tile(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      // Navigator.push adds a new route to the navigation stack, so the
      // pushed page will display an automatic back button in its AppBar.
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => page)),
    );
  }
}

// ---------------- Stateless Widget ----------------
// StatelessWidget is appropriate when the UI depends only on constructor
// parameters and never changes internally.
class StatelessDemoPage extends StatelessWidget {
  const StatelessDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the visual scaffolding (AppBar, body). Center
    // centers its child within available space.
    return Scaffold(
      appBar: AppBar(title: const Text('Stateless Widget')),
      body: const Center(child: Text('I am stateless. I render purely from properties.')),
    );
  }
}

// ---------------- Stateful Widget (counter) ----------------
// StatefulWidget has an associated State object used for mutable state.
class StatefulCounterPage extends StatefulWidget {
  const StatefulCounterPage({Key? key}) : super(key: key);

  @override
  State<StatefulCounterPage> createState() => _StatefulCounterPageState();
}

class _StatefulCounterPageState extends State<StatefulCounterPage> {
  // Mutable counter state. Naming with leading underscore makes it private.
  int _count = 0;

  // initState is called once when the state is inserted into the tree. Use
  // it for initialization that depends on the BuildContext or widget fields.
  @override
  void initState() {
    super.initState();
    // Debug print helps observe lifecycle during development.
    debugPrint('Counter initState');
  }

  // dispose is called when this State object is removed permanently. Clean
  // up controllers, subscriptions, and other resources here.
  @override
  void dispose() {
    debugPrint('Counter dispose');
    super.dispose();
  }

  // Increments the counter and calls setState so Flutter rebuilds the UI.
  void _increment() => setState(() => _count++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stateful Counter')),
      body: Center(child: Text('Count: $_count')),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        child: const Icon(Icons.add),
        tooltip: 'Increment',
      ),
    );
  }
}

// ---------------- Layout Demo (Row / Column / Expanded) ----------------
// Demonstrates how Row, Column, Expanded, Flexible, and SizedBox interact.
class LayoutDemoPage extends StatelessWidget {
  const LayoutDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Layout Demo')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          // crossAxisAlignment controls how children align along the
          // horizontal axis when the column has more width than children.
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Row with Expanded widgets:'),
            Row(
              children: [
                // A fixed-size box with explicit width and height.
                Container(color: Colors.red, height: 50, width: 50),
                const SizedBox(width: 8),
                // Expanded makes the child take remaining space.
                Expanded(child: Container(color: Colors.green, height: 50, child: const Center(child: Text('Expanded')))),
                const SizedBox(width: 8),
                // Flexible is similar, but allows the child to be smaller if it
                // doesn't need all the space (it gives flexibility).
                Flexible(flex: 1, child: Container(color: Colors.blue, height: 50, child: const Center(child: Text('Flexible')))),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Column with spacing and alignment:'),
            Container(
              color: Colors.grey.shade200,
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('First line'),
                  SizedBox(height: 8),
                  Text('Second line'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Scrolling Demo ----------------
// ListView.builder is efficient because it builds list tiles lazily only for
// the items that are visible on-screen.
class ScrollingDemoPage extends StatelessWidget {
  const ScrollingDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ListView (Scrolling)')),
      body: ListView.builder(
        itemCount: 50,
        itemBuilder: (context, index) => ListTile(title: Text('Item #${index + 1}')),
      ),
    );
  }
}

// ---------------- Forms Demo ----------------
// Demonstrates a simple Form with validation and a TextEditingController.
class FormsDemoPage extends StatefulWidget {
  const FormsDemoPage({Key? key}) : super(key: key);

  @override
  State<FormsDemoPage> createState() => _FormsDemoPageState();
}

class _FormsDemoPageState extends State<FormsDemoPage> {
  // A GlobalKey gives access to the FormState so we can call validate().
  final _formKey = GlobalKey<FormState>();
  // Controller to access and manipulate the text field value programmatically.
  final TextEditingController _controller = TextEditingController();

  // Always dispose controllers to avoid memory leaks when the widget is removed.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Validate the form; if valid, show a SnackBar with the entered name.
  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hello ${_controller.text}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forms Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Your name'),
                // Return a string on validation error, or null if the value
                // is valid. The framework shows the returned string as an error.
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _submit, child: const Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- Async Demo (FutureBuilder & StreamBuilder) ----------------
// Shows how to work with Futures (single async result) and Streams
// (multiple async events) in the widget tree.
class AsyncDemoPage extends StatelessWidget {
  const AsyncDemoPage({Key? key}) : super(key: key);

  // Simulate a network call by delaying and then returning a value.
  Future<String> _fakeNetworkCall() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'Data loaded';
  }

  // Simple periodic stream that yields integers over time.
  Stream<int> _counterStream() async* {
    for (var i = 1; i <= 5; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      yield i;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Async Demo')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // FutureBuilder takes a Future and rebuilds when the future
            // completes or fails. The builder receives a snapshot object
            // describing the current connection state and data/error.
            FutureBuilder<String>(
              future: _fakeNetworkCall(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const CircularProgressIndicator();
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                return Text('Future result: ${snapshot.data}');
              },
            ),
            const SizedBox(height: 20),
            // StreamBuilder rebuilds each time the stream emits a new value.
            StreamBuilder<int>(
              stream: _counterStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text('Waiting for stream...');
                return Text('Stream value: ${snapshot.data}');
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Animation Demo ----------------
// `AnimatedContainer` is an implicit animation widget: when its properties
// change (width/height/color) Flutter animates between the old and new
// values automatically.
class AnimationDemoPage extends StatefulWidget {
  const AnimationDemoPage({Key? key}) : super(key: key);

  @override
  State<AnimationDemoPage> createState() => _AnimationDemoPageState();
}

class _AnimationDemoPageState extends State<AnimationDemoPage> {
  // Toggle state to swap animated properties.
  bool _toggled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AnimatedContainer Demo')),
      body: Center(
        // GestureDetector listens for taps; onTap we change state to
        // trigger the AnimatedContainer to animate to new values.
        child: GestureDetector(
          onTap: () => setState(() => _toggled = !_toggled),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: _toggled ? 200 : 100,
            height: _toggled ? 200 : 100,
            color: _toggled ? Colors.purple : Colors.orange,
            alignment: Alignment.center,
            child: const Text('Tap me', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}

// ---------------- Gesture Demo ----------------
// InkWell provides a Material ripple effect when tapped. It needs a
// Material ancestor such as Scaffold to render the ink splash.
class GestureDemoPage extends StatelessWidget {
  const GestureDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gesture Demo')),
      body: Center(
        child: InkWell(
          // Show a SnackBar when the area is tapped. ScaffoldMessenger
          // manages SnackBars for the nearest Scaffold.
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('InkWell tapped'))),
          child: Container(
            padding: const EdgeInsets.all(20),
            // BoxDecoration customizes the container's appearance.
            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
            child: const Text('Tap me', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
