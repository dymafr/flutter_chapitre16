import 'package:flutter/material.dart';
import '../activity_form/widgets/activity_form.dart';
import '../../../widgets/dyma_drawer.dart';

class ActivityFormView extends StatelessWidget {
  static const String routeName = '/activity-form';

  @override
  Widget build(BuildContext context) {
    String cityName = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('ajouter une activité'),
      ),
      drawer: DymaDrawer(),
      body: SingleChildScrollView(
        child: ActivityForm(cityName: cityName),
      ),
    );
  }
}
