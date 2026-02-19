import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';
import 'package:chicket/api/models/models.dart';
import 'package:chicket/api/repositories/syrve_repository.dart';
import 'package:chicket/services/kiosk_config_service.dart';
import 'package:chicket/services/menu_cache_service.dart';
import 'package:chicket/theme/colors.dart';
import 'package:chicket/routes.dart';
import 'package:chicket/gen/assets.gen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final SyrveRepository _repository = SyrveRepository();
  final KioskConfigService _configService = Get.find<KioskConfigService>();
  late final GifController _gifController;

  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  List<Organization> _organizations = [];
  List<TerminalGroup> _terminalGroups = [];
  List<ExternalMenu> _externalMenus = [];
  List<OrderType> _orderTypes = [];

  Organization? _selectedOrg;
  TerminalGroup? _selectedTerminal;
  ExternalMenu? _selectedMenu;
  OrderType? _selectedOrderType;

  @override
  void initState() {
    super.initState();
    _gifController = GifController();
    _loadInitialData();
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final orgsResult = await _repository.getOrganizations();
      if (!orgsResult.isSuccess) {
        throw Exception(orgsResult.error);
      }
      _organizations = orgsResult.data ?? [];

      final savedConfig = _configService.config.value;
      if (savedConfig != null && _organizations.isNotEmpty) {
        _selectedOrg = _organizations.firstWhereOrNull(
          (o) => o.id == savedConfig.organizationId,
        );
        if (_selectedOrg != null) {
          await _onOrganizationChanged(_selectedOrg);

          _selectedTerminal = _terminalGroups.firstWhereOrNull(
            (t) => t.id == savedConfig.terminalGroupId,
          );
          _selectedMenu = _externalMenus.firstWhereOrNull(
            (m) => m.id == savedConfig.externalMenuId,
          );
          _selectedOrderType = _orderTypes.firstWhereOrNull(
            (o) => o.id == savedConfig.defaultOrderTypeId,
          );
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = '${"failed_to_load_data".tr} $e';
      });
    }
  }

  Future<void> _onOrganizationChanged(Organization? org) async {
    if (org == null) return;

    setState(() {
      _selectedOrg = org;
      _selectedTerminal = null;
      _selectedMenu = null;
      _selectedOrderType = null;
      _terminalGroups = [];
      _externalMenus = [];
      _orderTypes = [];
      _isLoading = true;
    });

    try {
      final terminalsResult = await _repository.getTerminalGroups(
        organizationIds: [org.id],
      );
      if (terminalsResult.isSuccess && terminalsResult.data != null) {
        _terminalGroups = terminalsResult.data!;
      }

      final menusResult = await _repository.getExternalMenus(
        organizationId: org.id,
      );
      if (menusResult.isSuccess && menusResult.data != null) {
        _externalMenus = menusResult.data!;
      }

      final orderTypesResult = await _repository.getOrderTypes(
        organizationIds: [org.id],
      );
      if (orderTypesResult.isSuccess && orderTypesResult.data != null) {
        _orderTypes = orderTypesResult.data!
            .where((t) => t.isDeleted != true)
            .toList();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = '${"failed_to_load_organization_data".tr} $e';
      });
    }
  }

  bool get _canSave =>
      _selectedOrg != null &&
      _selectedTerminal != null &&
      _selectedMenu != null;

  Future<void> _saveConfig() async {
    if (!_canSave) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final cacheService = Get.find<MenuCacheService>();
      await cacheService.clearCache();

      final config = KioskConfig(
        organizationId: _selectedOrg!.id,
        organizationName: _selectedOrg!.name ?? 'unknown'.tr,
        terminalGroupId: _selectedTerminal!.id,
        terminalGroupName: _selectedTerminal!.name ?? 'unknown'.tr,
        externalMenuId: _selectedMenu!.id,
        externalMenuName: _selectedMenu!.name,
        defaultOrderTypeId: _selectedOrderType?.id,
        defaultOrderTypeName: _selectedOrderType?.name,
      );

      final success = await _configService.saveConfig(config);
      if (success) {
        Get.offAllNamed(Routes.splash);
      } else {
        _showError('failed_to_save_configuration'.tr);
      }
    } catch (e) {
      _showError('${"error_saving_configuration".tr} $e');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.RED,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                ),
                child: _isLoading && _organizations.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.RED),
                      )
                    : _error != null && _organizations.isEmpty
                    ? _buildErrorView()
                    : _buildForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.RED,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        children: [
          SizedBox(
            height: 0.2.sh,
            width: 1.sw,
            child: GifView.asset(
              Assets.gif.chicket.path,
              controller: _gifController,
              fit: BoxFit.cover,
              loop: true,
            ),
          ),
          Gap(8.h),
          Text(
            "kiosk_setup".tr,
            style: TextStyle(
              fontFamily: 'Oswald',
              fontSize: 36.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.WHITE,
            ),
          ),
          Text(
            "configure_branch_settings".tr,
            style: TextStyle(
              fontFamily: 'Oswald',
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.WHITE,
            ),
          ),
          Gap(16.h),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: AppColors.RED),
            Gap(16.h),
            Text(
              _error ?? 'unknown_error'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.sp, color: Colors.grey[700]),
            ),
            Gap(24.h),
            ElevatedButton(
              onPressed: _loadInitialData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.RED,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
              ),
              child: Text(
                'retry'.tr,
                style: TextStyle(fontSize: 18.sp, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDropdownCard(
                  title: 'organization_branch'.tr,
                  icon: Icons.store_outlined,
                  child: _buildOrganizationDropdown(),
                ),
                Gap(16.h),
                _buildDropdownCard(
                  title: 'terminal_group'.tr,
                  icon: Icons.point_of_sale_outlined,
                  child: _buildTerminalDropdown(),
                  enabled: _selectedOrg != null,
                ),
                Gap(16.h),
                _buildDropdownCard(
                  title: 'menu'.tr,
                  icon: Icons.restaurant_menu_outlined,
                  child: _buildMenuDropdown(),
                  enabled: _selectedOrg != null,
                ),
                Gap(16.h),
                _buildDropdownCard(
                  title: 'default_order_type_optional'.tr,
                  icon: Icons.shopping_bag_outlined,
                  child: _buildOrderTypeDropdown(),
                  enabled: _selectedOrg != null,
                ),
              ],
            ),
          ),
        ),
        _buildBottomSection(),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInfoCard(),
          Gap(16.h),
          _buildSaveButton(),
          if (_configService.isConfigured) ...[Gap(12.h), _buildCancelButton()],
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: Colors.blue[700],
            size: 28.sp,
          ),
          Gap(12.w),
          Expanded(
            child: Text(
              'kiosk_setup_description'.tr,
              style: TextStyle(fontSize: 16.sp, color: Colors.blue[900]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownCard({
    required String title,
    required IconData icon,
    required Widget child,
    bool enabled = true,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.RED, size: 24.sp),
                Gap(8.w),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Oswald',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            Gap(12.h),
            IgnorePointer(ignoring: !enabled, child: child),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganizationDropdown() {
    return DropdownButtonFormField<Organization>(
      initialValue: _selectedOrg,
      isExpanded: true,
      decoration: _dropdownDecoration(),
      hint: Text('select_organization'.tr, style: TextStyle(fontSize: 16.sp)),
      items: _organizations.map((org) {
        return DropdownMenuItem(
          value: org,
          child: Text(
            org.name ?? 'unknown'.tr,
            style: TextStyle(fontSize: 16.sp),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: _onOrganizationChanged,
    );
  }

  Widget _buildTerminalDropdown() {
    return DropdownButtonFormField<TerminalGroup>(
      initialValue: _selectedTerminal,
      isExpanded: true,
      decoration: _dropdownDecoration(),
      hint: Text(
        _terminalGroups.isEmpty
            ? 'select_organization_first'.tr
            : 'select_terminal_group'.tr,
        style: TextStyle(fontSize: 16.sp),
      ),
      items: _terminalGroups.map((terminal) {
        return DropdownMenuItem(
          value: terminal,
          child: Text(
            terminal.name ?? 'unknown'.tr,
            style: TextStyle(fontSize: 16.sp),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (terminal) {
        setState(() {
          _selectedTerminal = terminal;
        });
      },
    );
  }

  Widget _buildMenuDropdown() {
    return DropdownButtonFormField<ExternalMenu>(
      initialValue: _selectedMenu,
      isExpanded: true,
      decoration: _dropdownDecoration(),
      hint: Text(
        _externalMenus.isEmpty
            ? 'select_organization_first'.tr
            : 'select_menu'.tr,
        style: TextStyle(fontSize: 16.sp),
      ),
      items: _externalMenus.map((menu) {
        return DropdownMenuItem(
          value: menu,
          child: Text(
            menu.name,
            style: TextStyle(fontSize: 16.sp),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (menu) {
        setState(() {
          _selectedMenu = menu;
        });
      },
    );
  }

  Widget _buildOrderTypeDropdown() {
    return DropdownButtonFormField<OrderType>(
      initialValue: _selectedOrderType,
      isExpanded: true,
      decoration: _dropdownDecoration(),
      hint: Text(
        _orderTypes.isEmpty
            ? 'select_organization_first'.tr
            : 'select_order_type_optional'.tr,
        style: TextStyle(fontSize: 16.sp),
      ),
      items: _orderTypes.map((orderType) {
        return DropdownMenuItem(
          value: orderType,
          child: Text(
            '${orderType.name} (${orderType.orderServiceType})',
            style: TextStyle(fontSize: 16.sp),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (orderType) {
        setState(() {
          _selectedOrderType = orderType;
        });
      },
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(color: AppColors.RED, width: 2),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _canSave && !_isSaving ? _saveConfig : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.RED,
        disabledBackgroundColor: Colors.grey[400],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.w),
      ),
      child: _isSaving
          ? SizedBox(
              width: 24.w,
              height: 24.w,
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Text(
                'save_configuration'.tr,
                style: TextStyle(
                  fontFamily: 'Oswald',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }

  Widget _buildCancelButton() {
    return TextButton(
      onPressed: () => Get.back(),
      child: Text(
        'cancel_btn'.tr,
        style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
      ),
    );
  }
}
