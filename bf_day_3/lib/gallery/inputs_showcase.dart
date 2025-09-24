import 'package:flutter/material.dart';

class InputsShowcase extends StatefulWidget {
  const InputsShowcase({super.key});

  @override
  State<InputsShowcase> createState() => _InputsShowcaseState();
}

class _InputsShowcaseState extends State<InputsShowcase> {
  final TextEditingController _controller = TextEditingController();
  String? _dropdownValue = 'Option 1';
  bool _switchValue = false;
  bool _checkboxValue = false;
  double _sliderValue = 0.5;
  int? _radioValue = 1;
  RangeValues _rangeValues = const RangeValues(0.2, 0.8);
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Fields'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Text Fields',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Standard Text Field',
              hintText: 'Enter some text',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: 'Text Field with Icon',
              hintText: 'Search for something',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: () => _controller.clear(),
                icon: const Icon(Icons.clear),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Password Field',
              hintText: 'Enter password',
              prefixIcon: Icon(Icons.lock),
              suffixIcon: Icon(Icons.visibility),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Error Field',
              hintText: 'This field has an error',
              errorText: 'Something went wrong',
              prefixIcon: Icon(Icons.error),
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Multiline Text Field',
              hintText: 'Enter multiple lines of text',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Dropdown',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _dropdownValue,
            decoration: const InputDecoration(
              labelText: 'Select Option',
              prefixIcon: Icon(Icons.category),
            ),
            items: ['Option 1', 'Option 2', 'Option 3', 'Option 4']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _dropdownValue = newValue;
              });
            },
          ),
          const SizedBox(height: 32),
          Text(
            'Switches & Checkboxes',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Switch'),
                    subtitle: const Text('Toggle this switch'),
                    value: _switchValue,
                    onChanged: (bool value) {
                      setState(() {
                        _switchValue = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Checkbox'),
                    subtitle: const Text('Check this box'),
                    value: _checkboxValue,
                    onChanged: (bool? value) {
                      setState(() {
                        _checkboxValue = value ?? false;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Radio Buttons',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  RadioListTile<int>(
                    title: const Text('Option 1'),
                    value: 1,
                    groupValue: _radioValue,
                    onChanged: (int? value) {
                      setState(() {
                        _radioValue = value;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    title: const Text('Option 2'),
                    value: 2,
                    groupValue: _radioValue,
                    onChanged: (int? value) {
                      setState(() {
                        _radioValue = value;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    title: const Text('Option 3'),
                    value: 3,
                    groupValue: _radioValue,
                    onChanged: (int? value) {
                      setState(() {
                        _radioValue = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Sliders',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Slider: ${_sliderValue.toStringAsFixed(2)}'),
                  Slider(
                    value: _sliderValue,
                    onChanged: (double value) {
                      setState(() {
                        _sliderValue = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Text('Range Slider: ${_rangeValues.start.toStringAsFixed(2)} - ${_rangeValues.end.toStringAsFixed(2)}'),
                  RangeSlider(
                    values: _rangeValues,
                    onChanged: (RangeValues values) {
                      setState(() {
                        _rangeValues = values;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Date & Time Pickers',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Select Date'),
                    subtitle: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null && picked != _selectedDate) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: const Text('Select Time'),
                    subtitle: Text(_selectedTime.format(context)),
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (picked != null && picked != _selectedTime) {
                        setState(() {
                          _selectedTime = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}