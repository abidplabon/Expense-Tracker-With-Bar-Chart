import 'package:flutter/material.dart';
import 'package:track_expense/models/expense.dart';
import 'package:track_expense/widgets/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amount = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.education;
  void _submitExpense(){
    final enterAmount = double.tryParse(_amount.text);
    final amountInvalid = enterAmount == null || enterAmount <=0;
    if(_titleController.text.trim().isEmpty|| amountInvalid || _selectedDate==null){
      showDialog(context: context, builder: (ctx)=> AlertDialog(
        title: const Text('Invalid Input'),
        content: const Text("Please make sure valid information is provided"),
        actions: [
          TextButton(onPressed: (){
                  Navigator.pop(ctx);
            },
            child: const Text('OK'),
          ),
        ],
      ));
      return;
    }
    widget.onAddExpense(Expense(title: _titleController.text, amount: enterAmount, date: _selectedDate!, category: _selectedCategory));
    Navigator.pop(context);
  }

  void _presentDatePicker() async{
    final initialDate = DateTime.now();
    final firstDate = DateTime(initialDate.year-1, initialDate.month,initialDate.day);
    final pickDate = await showDatePicker(context: context, initialDate: initialDate, firstDate: firstDate, lastDate: initialDate);
    setState(() {
      _selectedDate = pickDate;
    });
  }
  @override
  void dispose() {
    _titleController.dispose();
    _amount.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text('Enter Expense Name')
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amount,
                    keyboardType:TextInputType.number,
                    maxLength: 5,
                    decoration: const InputDecoration(
                      prefixText: '\$',
                        label: Text('Enter Expense Amount')
                    ),
                  ),
                ),
                const SizedBox(width: 116,),
                Expanded(child: Row(
                  children: [
                    Text(_selectedDate==null ? 'No date selected':formatter.format(_selectedDate!)),
                    IconButton(onPressed: _presentDatePicker, icon: const Icon(Icons.calendar_month))
                  ],
                ))
              ],
            ),
            //const Spacer(),
            const SizedBox(height: 32,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownButton(
                    value: _selectedCategory,
                    items: Category.values.map(
                            (category) => DropdownMenuItem(
                              value: category,
                                child: Text(
                                    category.name.toUpperCase()))).toList(),
                    onChanged: (value){
                        if(value==null){return;}
                  setState(() {
                    _selectedCategory = value;
                  });
                }),
                const SizedBox(width: 112,),
                ElevatedButton(
                    onPressed: (){
                      _submitExpense();
                      },
                    child: const Text("Save Expense")
                ),
                const SizedBox(width: 23,),
                ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")
                )
              ],
            ),
          ],
        ),
    );
  }
}

//Declare a global variable of Category Type for the dropdown default value
// DropDownButton has
//item in which we put Category type value as Category.value => then map them => map should be iterable so (category array in which we have set labels)
//=> category.name.toList()
//onChange accepts a value as parameter the value should be passed using global variable in "DropDownButton" + "Map" to pass here



//For storing the tasks. We need to add required in new_expense and pass it as void function (Expense expense) then pass it to the dart file from where the function is passed to this page