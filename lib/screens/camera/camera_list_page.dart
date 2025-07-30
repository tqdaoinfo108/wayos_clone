// filepath: c:\Users\daotq\Documents\Source_daotq\Git\wayos_clone\lib\screens\home\application\pages\item_list_page.dart
import 'package:flutter/material.dart';

import 'camera_create_page.dart';

class CameraListPage extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {
      'Title': 'Item 1',
      'Date': '2023-10-01',
      'Status': 'In',
    },
    {
      'Title': 'Item 2',
      'Date': '2023-10-02',
      'Status': 'Out',
    },
    {
      'Title': 'Item 3',
      'Date': '2023-10-03',
      'Status': 'In/Out',
    },
    // Add more items as needed
  ];

  CameraListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Xử lý khi nhấn Thêm mới
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CreateItemPage(),
              ));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ItemRowDetail(
            data: item,
            color: Colors.blue,
            onTap: () {
              print('Tapped on ${item['Title']}');
            },
            status: item['Status'],
          );
        },
      ),
    );
  }
}

class ItemRowDetail extends StatelessWidget {
  const ItemRowDetail({
    Key? key,
    required this.data,
    required this.color,
    required this.onTap,
    required this.status,
  }) : super(key: key);

  final Color color;
  final VoidCallback onTap;
  final Map<String, dynamic> data;
  final String status;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                border: Border(left: BorderSide(width: 3, color: color)),
              ),
              padding: EdgeInsets.only(right: 20),
              child: Row(
                children: [
                  // content
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['Title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Date: ${data['Date']}',
                            style: TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  minimumSize: Size(0, 28),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 0),
                                  side: BorderSide(color: color),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                ),
                                onPressed: () {
                                  // ScaffoldMessenger.of(context)
                                  //     .showSnackBar(
                                  //   SnackBar(
                                  //       content: Text(
                                  //           'Cập nhật ${data['Title']}')),
                                  // );
                                },
                                child: Text(
                                  'Status: $status',
                                  style: TextStyle(fontSize: 13, color: color),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // action indicator (optional)
                  Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 5,
            thickness: 5,
            color: Colors.grey.shade100,
          )
        ],
      ),
    );
  }
}
