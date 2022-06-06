import 'package:flutter/material.dart';

import '../../../data/models/categories.dart';
import '../../widgets/custom/full_button.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/upload/list_categories_selected.dart';

class SelectCat extends StatelessWidget {
  SelectCat({Key? key}) : super(key: key);

  final CategoriesSelectCount count = CategoriesSelectCount();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: ListCategoriesSelected(
                items: listCategory,
                count: count,
              ),
            ),
            Flexible(
              flex: 0,
              child: FullButton(
                onPressed: () => '',
                marginTop: 5,
                marginBot: 10,
              ),
            )
          ],
        ),
      ),
    );
  }
}