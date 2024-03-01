/*
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/dechet.dart';

class Simula extends StatefulWidget {
  const Simula({Key? key}) : super(key: key);

  @override
  _SimulaState createState() => _SimulaState();
}

class _SimulaState extends State<Simula> {
  List<Dechet> dechetList = [];
  TextEditingController _controller = TextEditingController();
  int _selectedNumber = 0;
  Dechet? _selectedDechet; // Track the selected dechet
  List<Map<Dechet, double>> selectedDechetsMap = [];

  void _addSelectedDechet() {
    if (_selectedDechet != null && _selectedNumber > 0) {
      final double totalWeight = _selectedDechet!.poids * _selectedNumber;
      final dechetWithWeight = {_selectedDechet!: totalWeight};

      setState(() {
        selectedDechetsMap.add(dechetWithWeight);
        _selectedNumber = 0; // Reset the number input to 0
        _controller.text = '0'; // Reset the text field to '0'
      });
    }
  }

  void _removeSelectedDechet(int index) {
    setState(() {
      selectedDechetsMap.removeAt(index);
    });
  }

  void _updateSelectedNumber(int number) {
    setState(() {
      _selectedNumber = number;
    });
  }

  void _updateSelectedDechet(Dechet dechet) {
    setState(() {
      _selectedDechet = dechet;
    });
  }

  void _navigateBack() {
    final updatedList = selectedDechetsMap;
    Navigator.pop(context, updatedList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        backgroundColor: const Color(0xFF24306F),
        title: const Text('Simulation Screen'),
      ),
      body: Column(
        children: [
          DisplayDemande(
            onDechetSelected: _updateSelectedDechet,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                NumberInputWidget(
                  controller: _controller,
                  onNumberChanged: _updateSelectedNumber,
                ),
                const SizedBox(width: 60.0),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFF24306F),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: _addSelectedDechet,
                    child: const Text(
                      'Ajouter +',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SelectedItemWidget(
            selectedDechets: selectedDechetsMap,
            onRemove: _removeSelectedDechet,
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: Color(0xFF24306F),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextButton(
              onPressed: _navigateBack,
              child: const Text(
                'Términer',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DisplayDemande extends StatefulWidget {
  final Function(Dechet) onDechetSelected;

  DisplayDemande({required this.onDechetSelected, Key? key}) : super(key: key);

  @override
  _DisplayDemandeState createState() => _DisplayDemandeState();
}

class _DisplayDemandeState extends State<DisplayDemande> {
  int selectedItemId = 0;
  double poidsSelected = 0;
  int selectedNumber = 0;
  late List<Dechet> displayList = [];
  late List<Dechet> filteredList = [];
  Dechet? _selectedDechet;

  Future<List<Dechet>> getDechet() async {
    final List<Dechet> dechet = [];
    final url = Uri.parse('${ENV_variables.API_PATH}/dechet/get_all.php');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseBody = response.body;

        if (responseBody.isNotEmpty) {
          final dechetData = json.decode(responseBody);

          if (dechetData != null && dechetData is List) {
            for (var dechetMap in dechetData) {
              dechet.add(
                Dechet(
                  id: int.parse(dechetMap['id']),
                  poids: double.parse(dechetMap['poids']),
                  type: dechetMap['type'],
                  sousType: dechetMap['sous_type'],
                  objet: dechetMap['objet'],
                  pointKg: double.parse(dechetMap['point_kg']),
                ),
              );
            }
          } else {
            print('Invalid response data format.');
          }
        } else {
          print('Response body is empty.');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }

    return dechet;
  }

  @override
  void initState() {
    super.initState();
    fetchDechets();
  }

  Future<void> fetchDechets() async {
    try {
      displayList = await getDechet();
      filterListByType(displayList[selectedItemId].type);
    } catch (e) {
      print('Error fetching dechets: $e');
      displayList = [];
    }
    setState(() {});
  }

  void filterListByType(String type) {
    setState(() {
      filteredList = displayList.where((dechet) => dechet.type == type).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButton<int>(
                isExpanded: true,
                value: selectedItemId + 1,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedItemId = newValue! - 1;
                    filterListByType(displayList[selectedItemId].type);
                  });
                },
                dropdownColor: Colors.white,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFF24306F),
                ),
                underline: Container(),
                items: [
                  const DropdownMenuItem<int>(
                    value: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Choisir un type dechet',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  ...displayList.toSet().map<DropdownMenuItem<int>>((Dechet dechet) {
                    return DropdownMenuItem<int>(
                      value: dechet.id,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(dechet.type),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredList.length,
            itemBuilder: (BuildContext context, int index) {
              final Dechet dechet = filteredList[index];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    poidsSelected = dechet.poids;
                    _selectedDechet = dechet;
                  });
                  widget.onDechetSelected(dechet); // Notify the parent about the selected dechet
                },
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: dechet == _selectedDechet ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                      child: Text(
                        dechet.objet,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: dechet == _selectedDechet ? Colors.white : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class NumberInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(int) onNumberChanged;

  const NumberInputWidget({required this.controller, required this.onNumberChanged, Key? key}) : super(key: key);

  @override
  _NumberInputWidgetState createState() => _NumberInputWidgetState();
}

class _NumberInputWidgetState extends State<NumberInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                widget.onNumberChanged(int.tryParse(value) ?? 0);
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                hintText: 'Quantité',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: _increment,
            icon: const Icon(Icons.arrow_drop_up),
          ),
          IconButton(
            onPressed: _decrement,
            icon: const Icon(Icons.arrow_drop_down),
          ),
        ],
      ),
    );
  }

  void _increment() {
    final value = int.tryParse(widget.controller.text) ?? 0;
    setState(() {
      widget.controller.text = (value + 1).toString();
      widget.onNumberChanged(value + 1);
    });
  }

  void _decrement() {
    final value = int.tryParse(widget.controller.text) ?? 0;
    if (value > 0) {
      setState(() {
        widget.controller.text = (value - 1).toString();
        widget.onNumberChanged(value - 1);
      });
    }
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}

class SelectedItemWidget extends StatelessWidget {
  final List<Map<Dechet, double>> selectedDechets;
  final Function(int) onRemove;

  const SelectedItemWidget({
    required this.selectedDechets,
    required this.onRemove,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Votre Dechets',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          ListView.builder(
            shrinkWrap: true,
            itemCount: selectedDechets.length,
            itemBuilder: (context, index) {
              final selectedDechet = selectedDechets[index];

              final dechet = selectedDechet.keys.first;
              final totalWeight = selectedDechet.values.first;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dechet Type: ${dechet.type}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Poids: ${totalWeight.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    onPressed: () {
                      // Remove the selected dechet from the list
                      onRemove(index);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
*/
