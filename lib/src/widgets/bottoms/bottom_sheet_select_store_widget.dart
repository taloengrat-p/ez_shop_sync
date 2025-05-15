// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:flutter/material.dart';

import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';
import 'package:ez_shop_sync/src/widgets/bottom_sheet/bottom_menu_item.dart';
import 'package:ez_shop_sync/src/widgets/circle_profile_widget.dart';

class BottomSheetSelectStoreWidgetArgrument {
  final String storeId;
  final String? branchId;
  BottomSheetSelectStoreWidgetArgrument({required this.storeId, this.branchId});
}

class BottomSheetSelectStoreWidget extends StatefulWidget {
  final List<Store> stores;
  final String initStoreId;
  final String? initBranchId;
  const BottomSheetSelectStoreWidget({super.key, required this.stores, required this.initStoreId, this.initBranchId});

  @override
  State<BottomSheetSelectStoreWidget> createState() => _BottomSheetSelectStoreWidgetState();
}

class _BottomSheetSelectStoreWidgetState extends State<BottomSheetSelectStoreWidget> {
  String? _expandedStoreId;
  String? _branchSelected;

  @override
  void initState() {
    if (widget.initBranchId != null) {
      _expandedStoreId = widget.initStoreId;
    }
    _branchSelected = widget.initBranchId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList.radio(
        expandedHeaderPadding: EdgeInsets.zero,
        elevation: 0,

        initialOpenPanelValue: _expandedStoreId,
        children:
            widget.stores.map((store) {
              return ExpansionPanelRadio(
                value: store.id,
                canTapOnHeader: false,
                headerBuilder: (context, isExpanded) {
                  return BottomMenuItem(
                    label: store.name,
                    leading: CircleProfileWidget(title: store.name.toSubStringFirstToIndex(2)),
                    value: BottomSheetSelectStoreWidgetArgrument(storeId: store.id),

                    trailing:
                        store.id == widget.initStoreId
                            ? const Icon(Icons.check_circle_rounded, color: Colors.green)
                            : null,
                  );
                },
                body:
                    (store.branches?.isEmpty ?? true)
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text(LocaleKeys.branchDetailManagementPage_branchEmpty.tr())],
                        )
                        : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView.separated(
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: store.branches?.length ?? 0,
                            itemBuilder: (context, index) {
                              final branch = store.branches?.elementAtOrNull(index);

                              return RadioListTile(
                                key: ValueKey('branch-item-${branch?.id}'),
                                activeColor: Colors.green,
                                title: Text(branch?.name ?? '--', style: Theme.of(context).textTheme.bodyMedium),
                                value: branch?.id,
                                groupValue: _branchSelected,
                                onChanged: (value) async {
                                  setState(() {
                                    _branchSelected = value;
                                  });

                                  await Future.delayed(const Duration(milliseconds: 250));

                                  Navigator.of(
                                    context,
                                  ).pop(BottomSheetSelectStoreWidgetArgrument(storeId: store.id, branchId: branch?.id));
                                },
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return const SizedBox(height: 16);
                            },
                          ),
                        ),
              );
            }).toList(),
      ),
    );
  }
}
