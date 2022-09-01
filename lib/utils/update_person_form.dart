import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_app/models/person.dart';


class UpdatePersonForm extends StatefulWidget {
  final int index;
  final Person person;

  const UpdatePersonForm({
    required this.index,
    required this.person,
  });

  @override
  _UpdatePersonFormState createState() => _UpdatePersonFormState();
}

class _UpdatePersonFormState extends State<UpdatePersonForm> {
  final _personFormKey = GlobalKey<FormState>();

  late final _nameController;
  late final _countryController;
  late final Box box;

  String? _fieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field can\'t be empty';
    }
    return null;
  }

  // Update info of people box
  _updateInfo() {
    Person newPerson = Person(
      name: _nameController.text,
      country: _countryController.text,
    );

    box.putAt(widget.index, newPerson);

    print('データの更新をしました!');
  }

  @override
  void initState() {
    super.initState();
    // 開封済みボックスのリファレンスを取得
    box = Hive.box('peopleBox');
    _nameController = TextEditingController(text: widget.person.name);
    _countryController = TextEditingController(text: widget.person.country);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _personFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('名前'),
          TextFormField(
            controller: _nameController,
            validator: _fieldValidator,
          ),
          SizedBox(height: 24.0),
          Text('国籍を入力'),
          TextFormField(
            controller: _countryController,
            validator: _fieldValidator,
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 24.0),
            child: Container(
              width: double.maxFinite,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_personFormKey.currentState!.validate()) {
                    _updateInfo();
                    Navigator.of(context).pop();
                  }
                },
                child: Text('更新'),
              ),
            ),
          ),
          const SizedBox(height: 30)
        ],
      ),
    );
  }
}
