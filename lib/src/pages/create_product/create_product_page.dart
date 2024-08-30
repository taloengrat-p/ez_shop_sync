import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/models/base_argrument.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_router.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_state.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/image_form_field.dart/image_form_field.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({Key? key}) : super(key: key);

  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  late CreateProductCubit cubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = CreateProductCubit(
      productRepository: GetIt.I<ProductRepository>(),
      baseCubit: GetIt.I<BaseCubit>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return cubit;
      },
      child: BlocListener<CreateProductCubit, CreateProductState>(
        listener: (context, state) {
          if (state is CreateProductSuccess) {
            CreateProductRouter(context).pop(BaseArgrument(refresh: true));
          }
        },
        child: BlocBuilder<CreateProductCubit, CreateProductState>(
            builder: (context, state) {
          return BaseScaffolds(
            appBar: AppbarWidget(context, title: 'Create Product', actions: [])
                .build(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      ImageFormField(
                        imageDetailLimit: 5,
                        onProductDetailImageSelect:
                            cubit.setProductDetailImageSelect,
                        onProductImageSelect: cubit.setProductImageSelect,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormFieldUiWidget(
                        label: 'Name',
                        onChanged: cubit.setName,
                      ),
                      TextFormFieldUiWidget(
                        label: 'Description',
                        onChanged: cubit.setDescription,
                      ),
                      TextFormFieldUiWidget(
                        label: 'Price',
                        onChanged: cubit.setPrice,
                      ),
                      TextFormFieldUiWidget(
                        label: 'Quantity',
                        keyboardType: TextInputType.number,
                        onChanged: cubit.setQuantity,
                      ),
                      TextFormFieldUiWidget(
                        label: 'Category',
                        onChanged: cubit.setCategory,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: ButtonWidget(
              margin: const EdgeInsets.all(16),
              label: 'CREATE',
              onPressed: () {
                cubit.submit();
              },
            ),
          );
        }),
      ),
    );
  }
}
