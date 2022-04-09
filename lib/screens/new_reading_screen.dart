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
      body: const _AskIsbnCode(),
    );
  }
}

class _AskIsbnCode extends StatefulWidget {
  const _AskIsbnCode({Key? key}) : super(key: key);

  @override
  _AskIsbnCodeState createState() {
    return _AskIsbnCodeState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class _AskIsbnCodeState extends State<_AskIsbnCode> {
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FocusTraversalGroup(
                  descendantsAreFocusable: true,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.format_size_sharp),
                      helperText:
                          'Voce encontra o codigo ISBN proximo ao codigo de barras, no verso do livro. \nPor exemplo: 978-8576573937',
                      helperMaxLines: 4,
                      labelText: 'Digite o ISBN',
                    ),
                    validator: (String? value) {
                      // TODO Think about it.
                      return (value == null || value.isEmpty)
                          ? 'Por favor'
                          : null;
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // TODO fetch ISBN code
                        }
                      },
                      child: const Text('Procurar ...'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
