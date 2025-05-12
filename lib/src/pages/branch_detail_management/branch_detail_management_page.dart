import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/pages/branch_detail_management/branch_detail_management_cubit.dart';
import 'package:ez_shop_sync/src/pages/branch_detail_management/branch_detail_management_state.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class BranchDetailManagementPage extends StatefulWidget {
  const BranchDetailManagementPage({super.key});

  @override
  _BranchDetailManagementState createState() => _BranchDetailManagementState();
}

class _BranchDetailManagementState extends State<BranchDetailManagementPage> {
  final _cubit = GetIt.I<BranchDetailManagementCubit>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((time) {
      final argrument = ModalRoute.of(context)?.settings.arguments;
      if (argrument is BranchDetailManagementArgrument) {
        _cubit.initial(argrument);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BranchDetailManagementCubit, BranchDetailManagementState>(
      bloc: _cubit,
      listener: (context, state) {},
      child: BlocBuilder<BranchDetailManagementCubit, BranchDetailManagementState>(
        bloc: _cubit,
        builder: (context, state) {
          return BaseScaffolds(
            isEmpty: _cubit.members.isEmpty,
            emptyIcon: Icons.person_rounded,
            emptyMessage: LocaleKeys.branchDetailManagementPage_emptyMessage.tr(),
            appBar: AppbarWidget(context, centerTitle: false, title: _cubit.branch?.name ?? '--', actions: []).build(),
            body: _buildPage(context, state),
          );
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context, BranchDetailManagementState state) {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _cubit.members.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final member = _cubit.members[index];
        return CheckboxListTile(title: Text(member.email), value: member.isSelect, onChanged: _cubit.onCheckedChanged);
      },
      separatorBuilder: (context, index) {
        return const Divider(color: Colors.grey);
      },
    );
  }
}
