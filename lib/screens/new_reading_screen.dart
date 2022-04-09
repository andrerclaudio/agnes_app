import 'package:flutter/material.dart';

class AddNewReading extends StatefulWidget {
  const AddNewReading({Key? key}) : super(key: key);

  @override
  State<AddNewReading> createState() => _AddNewReadingState();
}

class _AddNewReadingState extends State<AddNewReading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
        child: SizedBox(
          height: MediaQuery.of(context).padding.top,
        ),
      ),
      body: const _NewReading(),
    );
  }
}

class _NewReading extends StatefulWidget {
  const _NewReading({Key? key}) : super(key: key);

  @override
  _NewReadingState createState() {
    return _NewReadingState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class _NewReadingState extends State<_NewReading> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Build a Form widget using the _formKey created above.
    return SizedBox(
      height: height,
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FocusTraversalGroup(
                descendantsAreFocusable: true,
                child: TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.library_add),
                    hintText: 'What do people call you?',
                    labelText: 'Name *',
                  ),
                  validator: (String? value) {
                    return (value == null || value.isEmpty)
                        ? 'Please enter some text'
                        : null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
