import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_text_style.dart';
import '../../common/constants/app_colors.dart';
import '../../common/extensions/date_formatter.dart';
import '../../common/extensions/sizes.dart';
import '../../common/models/transaction_model.dart';
import '../../common/utils/money_mask_controller.dart';
import '../../common/widgets/app_header.dart';
import '../../common/widgets/custom_circular_progress_indicator.dart';
import '../../common/widgets/custom_text_form_field.dart';
import '../../common/widgets/primary_button.dart';
import '../../locator.dart';
import '../../repositories/transaction_repository.dart';
import '../../services/secure_storage.dart';
import 'transaction_controller.dart';
import 'transaction_state.dart';

class TransactionPage extends StatefulWidget {
  final TransactionModel? transaction;
  const TransactionPage({
    super.key,
    this.transaction,
  });

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}
class _TransactionPageState extends State<TransactionPage>
    with SingleTickerProviderStateMixin {
  final _transactionController = TransactionController(
    repository: locator.get<TransactionRepository>(),
    storage: const Securestorage(),
  );
  final _formKey = GlobalKey<FormState>();
  final _incomes = ['Services', 'Investment', 'Other'];
  final _outcomes = ['House', 'Grocery', 'Other'];
  DateTime? _date;
  bool value = false;
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _dateController = TextEditingController();
  final _amountController = MoneyMaskedTextController(
    prefix: 'R\$',
  );
  late final TabController _tabController;
  int get _initialIndex {
    if (widget.transaction != null && widget.transaction!.value.isNegative) {
      return 1;
    }
    return 0;
  }
  @override
  void initState() {
    super.initState();
    _amountController.updateValue(widget.transaction?.value ?? 0);
    _descriptionController.text = widget.transaction?.description ?? ''; //troquei o description pelo title
    _categoryController.text = widget.transaction?.category ?? '';
    _date = DateTime.fromMillisecondsSinceEpoch(widget.transaction?.date ?? 0);
    _dateController.text = widget.transaction?.date != null
        ? DateTime.fromMillisecondsSinceEpoch(widget.transaction!.date).toText
        : '';
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _initialIndex,
    );
    _transactionController.addListener(() {
      if (_transactionController.state is TransactionStateLoading) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => const CustomCircularProgressIndicator(),
        );
      }
      if (_transactionController.state is TransactionStateSuccess) {
        Navigator.pop(context);
      }
    });
  }
  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _dateController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppHeader(
            title: widget.transaction != null
                ? 'Edit Transaction'
                : 'Add Transaction',
          ),
          Positioned(
            top: 164.h,
            left: 28.w,
            right: 28.w,
            bottom: 16.h,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      StatefulBuilder(
                        builder: (context, setState) {
                          return TabBar(
                            labelPadding: EdgeInsets.zero,
                            controller: _tabController,
                            onTap: (_) {
                              if (_tabController.indexIsChanging) {
                                setState(() {});
                              }
                              if (_tabController.indexIsChanging &&
                                  _categoryController.text.isNotEmpty) {
                                _categoryController.clear();
                              }
                            },
                            tabs: [
                              Tab(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: _tabController.index == 0
                                        ? AppColors.iceWhite
                                        : AppColors.white,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(24.0),
                                    ),
                                  ),
                                  child: Text(
                                    'Income',
                                    style: AppTextStyles.mediumText16w500
                                        .apply(color: AppColors.darkGrey),
                                  ),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: _tabController.index == 1
                                        ? AppColors.iceWhite
                                        : AppColors.white,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(24.0),
                                    ),
                                  ),
                                  child: Text(
                                    'Expense',
                                    style: AppTextStyles.mediumText16w500
                                        .apply(color: AppColors.darkGrey),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16.0),
                      CustomTextFormField(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        labelText: "Amount",
                        hintText: "Type an amount",
                        suffixIcon: StatefulBuilder(
                          builder: (context, setState) {
                            return IconButton(
                              onPressed: () {
                                setState(() {
                                  value = !value;
                                });
                              },
                              icon: AnimatedContainer(
                                transform: value
                                    ? Matrix4.rotationX(math.pi * 2)
                                    : Matrix4.rotationX(math.pi),
                                transformAlignment: Alignment.center,
                                duration: const Duration(milliseconds: 200),
                                child: const Icon(Icons.thumb_up_alt_rounded),
                              ),
                            );
                          },
                        ),
                      ),
                      CustomTextFormField(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        controller: _descriptionController,
                        labelText: 'Description',
                        hintText: 'Add a description',
                        validator: (value) {
                          if (_descriptionController.text.isEmpty) {
                            return 'This field cannot be empty.';
                          }
                          return null;
                        },
                      ),
                      CustomTextFormField(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        controller: _categoryController,
                        readOnly: true,
                        labelText: "Category",
                        hintText: "Select a category",
                        validator: (value) {
                          if (_categoryController.text.isEmpty) {
                            return 'This field cannot be empty.';
                          }
                          return null;
                        },
                        onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (context) => Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: (_tabController.index == 0
                                    ? _incomes
                                    : _outcomes)
                                .map(
                                  (e) => TextButton(
                                    onPressed: () {
                                      _categoryController.text = e;
                                      Navigator.pop(context);
                                    },
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      CustomTextFormField(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        controller: _dateController,
                        readOnly: true,
                        labelText: "Date",
                        hintText: "Select a date",
                        validator: (value) {
                          if (_dateController.text.isEmpty) {
                            return 'This field cannot be empty.';
                          }
                          return null;
                        },
                        onTap: () async {
                          print('object');
                          _date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1970),
                            lastDate: DateTime(2030),
                          );
                          _date = _date?.microsecondsSinceEpoch != 0
                              ? DateTime.now().copyWith(
                                  day: _date?.day,
                                  month: _date?.month,
                                  year: _date?.year,
                                )
                              : null;
                          _dateController.text =
                              _date != null ? _date!.toText : '';
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: PrimaryButton(
                          text: widget.transaction != null ? 'Save' : 'Add',
                          onPressed: () async {
  FocusScope.of(context).unfocus();
  if (_formKey.currentState!.validate()) {
    final newValue = double.parse(_amountController
        .text
        .replaceAll('R\$', '')
        .replaceAll('.', '')
        .replaceAll(',', '.'));

    final newTransaction = TransactionModel(
      category: _categoryController.text,
      description: _descriptionController.text,
      value: _tabController.index == 1 ? newValue * -1 : newValue,
      date: _date != null
          ? _date!.millisecondsSinceEpoch
          : DateTime.now().millisecondsSinceEpoch,
      status: value,
      id: widget.transaction?.id,  // Se widget.transaction for nulo, id será nulo.
    );

    log('Nova transação gerada: ${newTransaction.toMap()}');

    if (widget.transaction == newTransaction) {
      log('Nenhuma alteração detectada, fechando página');
      Navigator.pop(context);
      return;
    }

    // Se estiver editando, o widget.transaction precisa ter um id válido.
    if (widget.transaction != null) {
      if (widget.transaction!.id == null) {
        log('Erro: A transação original não possui ID. Verifique se o objeto foi carregado corretamente.');
      }
      log('Chamando updateTransaction para ID: ${newTransaction.id}');
      await _transactionController.updateTransaction(newTransaction);
      if (mounted) {
        log('Fechando página após update');
        Navigator.pop(context, true);
      }
    } else {
      log('Chamando addTransaction para nova transação');
      await _transactionController.addTransaction(newTransaction);
      if (mounted) {
        log('Fechando página após adicionar nova transação');
        Navigator.pop(context, true);
      }
    }
  } else {
    log('Erro: Formulário inválido');
  }
},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}