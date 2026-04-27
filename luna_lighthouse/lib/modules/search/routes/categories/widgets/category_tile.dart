import 'package:flutter/material.dart';
import 'package:luna_lighthouse/core.dart';
import 'package:luna_lighthouse/modules/search.dart';
import 'package:luna_lighthouse/router/routes/search.dart';

class SearchCategoryTile extends StatelessWidget {
  final NewznabCategoryData category;
  final int index;

  const SearchCategoryTile({
    Key? key,
    required this.category,
    this.index = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      title: category.name ?? 'luna_lighthouse.Unknown'.tr(),
      body: [TextSpan(text: category.subcategoriesTitleList)],
      trailing: LunaIconButton(
        icon: category.icon,
        color: LunaColours().byListIndex(index),
      ),
      onTap: () async {
        context.read<SearchState>().activeCategory = category;
        SearchRoutes.SUBCATEGORIES.go();
      },
    );
  }
}
