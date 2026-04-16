import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wayos_clone/data/service/bill_tracking/bill_tracking_service.dart';
import 'package:wayos_clone/data/service/project_service.dart';

class MaterialCreateController extends ChangeNotifier {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController(text: '0');
  final TextEditingController deliveryVehicleController = TextEditingController();

  List<File?> inImages = List.generate(3, (_) => null);
  List<String?> inImagePaths = List.generate(3, (_) => null);
  
  List<Map<String, dynamic>> typeBillList = [];
  int? selectedTypeBillId;

  List<Map<String, dynamic>> projectList = [];
  int? selectedProjectId;

  List<Map<String, dynamic>> deliveryList = [];
  int? selectedDeliveryId;

  bool isLoadingTitle = false;
  bool isFirstTitleFetch = true;

  Future<void> initData() async {
    await Future.wait([
      fetchTypeBillList(),
      fetchProjectList(),
      fetchDeliveryList(),
    ]);
    await fetchTitle();
    await _loadLastTrackingBill();
  }

  Future<void> _loadLastTrackingBill() async {
    try {
      final response = await BillRequestService().getTrackingBillLatest();
      if (response != null && response['data'] != null) {
        final data = response['data'];
        
        if (data['ProjectID'] != null && projectList.any((p) => p['ProjectID'] == data['ProjectID'])) {
          selectedProjectId = data['ProjectID'];
        }
        
        if (data['TypeTrackingBillID'] != null && typeBillList.any((t) => t['TypeTrackingBillID'] == data['TypeTrackingBillID'])) {
          selectedTypeBillId = data['TypeTrackingBillID'];
        }
        
        if (data['DeliveryVehicleID'] != null) {
          final delId = data['DeliveryVehicleID'];
          final deliveryVehicle = deliveryList.firstWhere((d) => d['DeliveryVehicleID'] == delId, orElse: () => {});
          if (deliveryVehicle.isNotEmpty) {
            selectedDeliveryId = delId;
            deliveryVehicleController.text = '${deliveryVehicle['NumberVehicle'] ?? ''} - ${deliveryVehicle['TypeVehicleName'] ?? ''}';
            if (data['Amount'] == null && deliveryVehicle['NumberContainer'] != null) {
              amountController.text = deliveryVehicle['NumberContainer'].toString();
            }
          }
        }
        if (data['Amount'] != null) {
          amountController.text = data['Amount'].toString();
        }
        notifyListeners();
        await fetchTitle();
      }
    } catch (e) {
      print('Error load latest: $e');
    }
  }

  Future<void> fetchTypeBillList() async {
    final response = await BillRequestService().getTypeBillTracking();
    if (response?['data'] != null) typeBillList = List<Map<String, dynamic>>.from(response!['data']);
  }

  Future<void> fetchProjectList() async {
    final response = await ProjectService().getProjectList();
    if (response?['data'] != null) projectList = List<Map<String, dynamic>>.from(response!['data']);
  }

  Future<void> fetchDeliveryList() async {
    final response = await BillRequestService().getDeliveryVehicleList();
    if (response?['data'] != null) deliveryList = List<Map<String, dynamic>>.from(response!['data']);
  }

  Future<void> fetchTitle() async {
    isLoadingTitle = true;
    notifyListeners();

    try {
      final response = await BillRequestService().getTitle(
        projectID: selectedProjectId ?? 0,
        typeTrackingBillID: selectedTypeBillId ?? 0,
        deliveryVehicleID: selectedDeliveryId ?? 0,
        isFirst: isFirstTitleFetch,
      );

      if (response != null) {
        titleController.text = response['data'] ?? 'Tiêu đề được tạo tự động';
        isFirstTitleFetch = false;
      }
    } catch (_) { } 
    
    isLoadingTitle = false;
    notifyListeners();
  }

  void onChangeProject(int? val) {
    selectedProjectId = val;
    notifyListeners();
    fetchTitle();
  }

  void onChangeTypeBill(int? val) {
    selectedTypeBillId = val;
    notifyListeners();
    fetchTitle();
  }

  void onSelectDelivery(Map<String, dynamic> item) {
    selectedDeliveryId = item['DeliveryVehicleID'];
    if (item['NumberContainer'] != null) {
      amountController.text = item['NumberContainer'].toString();
    }
    notifyListeners();
    fetchTitle();
  }

  void updateImage(int index, File image, String publicPath) {
    inImages[index] = image;
    inImagePaths[index] = publicPath;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    deliveryVehicleController.dispose();
    super.dispose();
  }
}
