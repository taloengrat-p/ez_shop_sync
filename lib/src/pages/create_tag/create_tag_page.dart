import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_tag/create_tag_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_tag/create_tag_router.dart';
import 'package:ez_shop_sync/src/pages/create_tag/create_tag_state.dart';
import 'package:ez_shop_sync/src/utils/color_picker_utils.dart';
import 'package:ez_shop_sync/src/utils/extensions/color_extension.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/tag_widget.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:get_it/get_it.dart';

class CreateTagPage extends StatefulWidget {
  const CreateTagPage({
    Key? key,
  }) : super(key: key);

  @override
  _CreateTagState createState() => _CreateTagState();
}

class _CreateTagState extends State<CreateTagPage> {
  late CreateTagCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = CreateTagCubit(
      storeRepository: GetIt.I<StoreRepository>(),
      baseCubit: GetIt.I<BaseCubit>(),
    );

    WidgetsBinding.instance.addPostFrameCallback((time) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocListener<CreateTagCubit, CreateTagState>(
        listener: (context, state) {
          if (state is CreateTagSuccess) {
            CreateTagRouter(context).pop(state);
          }
        },
        child: BlocBuilder<CreateTagCubit, CreateTagState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(
                centerTitle: false,
                title: "CreateTag",
                actions: [],
              ).build(),
              body: _buildPage(context, state),
              bottomNavigationBar: ButtonWidget(
                margin: const EdgeInsets.all(8),
                label: 'CREATE',
                onPressed: () {
                  _cubit.doSubmit();
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, CreateTagState state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Preview'),
                  ),
                  Center(
                    child: TagWidget(
                      model: Tag(
                        id: 'id',
                        name: _cubit.name.isEmpty ? '         ' : _cubit.name,
                        color: _cubit.color.toHex(),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormFieldUiWidget(
              label: 'Name',
              onChanged: _cubit.setName,
              autofocus: true,
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormFieldUiWidget(
              label: 'Color',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _cubit.color,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(DimensionsKeys.radius),
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    child: ButtonWidget(
                      height: 50,
                      label: 'Choose',
                      onPressed: () async {
                        final color = await ColorPickerUtils.showDialogPicker(context);

                        _cubit.setColor(color);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              height: DimensionsKeys.heightBts,
            ),
          ],
        ),
      ),
    );
  }
}
