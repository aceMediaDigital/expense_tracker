/* =======================================================
 *
 * Created by anele on 29/07/2025.
 *
 * @anele_ace
 *
 * =======================================================
 */

import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:moola_mate/widgets/widgets.dart';


class ExpenseBottomSheet extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController itemNameController;
  final TextEditingController itemCostController;
  final TextEditingController itemDateController;
  final List<dynamic> itemListApi;
  final String? varsity;
  final Function(String?) onCategoryChanged;

  const ExpenseBottomSheet({
    super.key,
    required this.formKey,
    required this.itemNameController,
    required this.itemCostController,
    required this.itemDateController,
    required this.itemListApi,
    required this.varsity,
    required this.onCategoryChanged,
  });

  @override
  State<ExpenseBottomSheet> createState() => _ExpenseBottomSheetState();
}

class _ExpenseBottomSheetState extends State<ExpenseBottomSheet> {

  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.varsity;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.3,
      maxChildSize: 0.9,
      initialChildSize: 0.9,
      builder: (BuildContext context, ScrollController controller) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'What Did You Buy?',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  )
                ],
              ),
              const SizedBox(height: 20),

              Form(
                key: widget.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Name of Item', style: TextStyle(fontSize: 13),),
                    SizedBox(height: 5),
                    AppInput(
                      controller: widget.itemNameController,
                      obscureText: false,
                      validator: (String? value) => value == null || value.isEmpty
                          ? 'Enter Item Name'
                          : null,
                    ),
                    SizedBox(height: 20),

                    Text('How much was it?', style: TextStyle(fontSize: 13),),
                    SizedBox(height: 5),
                    AppInput(
                      obscureText: false,
                      controller: widget.itemCostController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*$')),
                      ],
                      validator: (String? value) => value == null || value.isEmpty
                          ? 'Enter Cost of Item'
                          : null,
                    ),
                    SizedBox(height: 20),

                    Text('Help Us with A Category ', style: TextStyle(fontSize: 13),),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: .5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButton<String>(
                        //value: widget.varsity,
                        value: selectedValue,
                        isExpanded: true,
                        hint: Text('Select a category', style: TextStyle(fontWeight: FontWeight.w400)),
                        underline: Container(),
                        items: widget.itemListApi.map((dynamic e) {
                          return DropdownMenuItem<String>(
                            value: e['id'].toString(),
                            child: Text(e['description'], style: TextStyle(fontSize: 15)),
                          );
                        }).toList(),
                        onChanged: (String? newVal) {
                          setState(() => selectedValue = newVal);
                          widget.onCategoryChanged(newVal);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text('When did you buy this?', style: TextStyle(fontSize: 13),),
                    TextFormField(
                      controller: widget.itemDateController,
                      keyboardType: TextInputType.datetime,
                      style: TextStyle(fontSize: 13),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2025),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                          setState(() {
                            widget.itemDateController.text = formattedDate;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.calendar_month),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black45),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black45),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      ),

                      validator: (String? value) => value == null || value.isEmpty
                          ? 'When did you buy this?'
                          : null,
                    ),
                    SizedBox(height: 39),

                    ElevatedButton(
                      onPressed: () {
                        if (widget.formKey.currentState!.validate()) {
                          // Collect all values
                          final Map<String, String?> data = <String, String?>{
                            'name': widget.itemNameController.text,
                            'cost': widget.itemCostController.text,
                            'date': widget.itemDateController.text,
                            'category': selectedValue,
                          };

                          Navigator.pop(context, data);
                        }
                      },
                      child: const Text('Add Cost'),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}