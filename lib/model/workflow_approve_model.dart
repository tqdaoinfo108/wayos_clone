// Định nghĩa class cho định dạng mới
class ApprovalItem {
  final String status;
  final String title;
  final String name;
  final String timestamp;

  ApprovalItem({
    required this.status,
    required this.title,
    required this.name,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'status': status,
        'title': title,
        'name': name,
        'timestamp': timestamp,
      };
}

List<ApprovalItem> convertJson(Map<String, dynamic> json) {
  List<ApprovalItem> result = [];

  List<dynamic> data = json['data'];

  for (var item in data) {
    DateTime dateTime = DateTime.parse(item['DateCreated']);
    String timestamp = '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';

    var approvalItem = ApprovalItem(
      status: item['IsApprove'] == 1 ? 'approved' : 'pending',
      title: item['DepartmentApproveName'],
      name: item['UserApproveName'],
      timestamp: timestamp,
    );

    result.add(approvalItem);
  }

  return result;
}
