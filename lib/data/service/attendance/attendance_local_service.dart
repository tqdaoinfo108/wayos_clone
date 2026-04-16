import 'package:get_storage/get_storage.dart';
import 'package:wayos_clone/data/model/attendance_record.dart';
import 'package:wayos_clone/core/utils/constants.dart';
import 'package:wayos_clone/core/utils/connectivity_utils.dart';
import 'dart:convert';

class AttendanceLocalService {
  static const String _storageKey = 'ATTENDANCE_RECORDS';
  final GetStorage _storage = GetStorage();

  /// Gets all attendance records from local storage
  List<AttendanceRecord> getAllRecords() {
    final String? dataString = _storage.read(_storageKey);
    if (dataString == null || dataString.isEmpty) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(dataString);
      return jsonList.map((json) => AttendanceRecord.fromJson(json)).toList();
    } catch (e) {
      print('Error parsing attendance records: $e');
      return [];
    }
  }

  /// Gets records specifically for today
  List<AttendanceRecord> getTodayRecords() {
    final now = DateTime.now();
    final records = getAllRecords();
    return records.where((r) {
      return r.time.year == now.year &&
             r.time.month == now.month &&
             r.time.day == now.day;
    }).toList();
  }

  /// Gets today's attendance status and what the next action should be
  /// Returns (AttendanceType? nextAction, DailyAttendance? todayData)
  (AttendanceType?, DailyAttendance?) getTodayStatus() {
    final todayRecords = getTodayRecords();
    
    // Sort chronologically
    todayRecords.sort((a, b) => a.time.compareTo(b.time));
    
    // Check if we have check-in
    final checkIns = todayRecords.where((r) => r.type == AttendanceType.checkin).toList();
    final checkOuts = todayRecords.where((r) => r.type == AttendanceType.checkout).toList();
    
    final checkIn = checkIns.isNotEmpty ? checkIns.last : null;
    final checkOut = checkOuts.isNotEmpty ? checkOuts.last : null;
    
    DailyAttendance? todayData;
    if (checkIn != null) {
      todayData = DailyAttendance(
        date: DateTime.now(),
        checkIn: checkIn,
        checkOut: checkOut,
        location: checkIn.address,
        status: AttendanceStatus.notYet, // Dummy for today view
      );
    }
    
    if (checkIns.isEmpty) {
      return (AttendanceType.checkin, todayData);
    } else if (checkOuts.isEmpty) {
      return (AttendanceType.checkout, todayData);
    } else {
      // Done for today
      return (null, todayData);
    }
  }

  /// Adds a new record, saves it, and attempts to sync
  Future<void> saveRecord(AttendanceRecord record) async {
    final records = getAllRecords();
    records.add(record);
    
    // Save to local storage immediately (Offline-first)
    _storage.write(_storageKey, jsonEncode(records.map((r) => r.toJson()).toList()));
    
    // Attempt sync if online
    syncPendingRecords();
  }

  /// Simulates syncing pending records to server
  Future<void> syncPendingRecords() async {
    final isOnline = await ConnectivityUtils.isOnline();
    if (!isOnline) return;

    final records = getAllRecords();
    bool hasChanges = false;
    
    for (int i = 0; i < records.length; i++) {
      if (!records[i].isSynced) {
        // [SIMULATE API TIMEOUT/CALL MOCK]
        // Assume API success:
        await Future.delayed(const Duration(milliseconds: 500)); 
        
        records[i] = records[i].copyWith(isSynced: true);
        hasChanges = true;
      }
    }
    
    if (hasChanges) {
      // Update local storage with synced status
      _storage.write(_storageKey, jsonEncode(records.map((r) => r.toJson()).toList()));
    }
  }
}
