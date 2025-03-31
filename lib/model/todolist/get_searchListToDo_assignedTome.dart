class SearchListToDo_assignedTome {
  final int toDoListsID;
  final String? title;
  final int? statusID;
  final bool? isConfirmed;
  final int? categoryNewsID;
  final DateTime? timeStart;
  final DateTime? timeEnd;
  final int? userCreatedID;
  final int? progressValue;
  final String? colorCode;
  final String? userCreateAvatar;
  final String? userCreateName;
  final String? departmentNameUserCreate;
  final List<String>? userAssignsNames;
  final List<String>? userAssignsAvatars;
  final String? description;

  SearchListToDo_assignedTome({
    required this.toDoListsID,
    required this.title,
    required this.statusID,
    required this.isConfirmed,
    required this.categoryNewsID,
    required this.timeStart,
    required this.timeEnd,
    required this.userCreatedID,
    required this.progressValue,
    required this.colorCode,
    required this.userCreateAvatar,
    required this.userCreateName,
    required this.departmentNameUserCreate,
    required this.userAssignsNames,
    required this.userAssignsAvatars,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'toDoListsID': toDoListsID,
        'title': title,
        'statusID': statusID,
        'isConfirmed': isConfirmed,
        'categoryNewsID': categoryNewsID,
        'timeStart': timeStart,
        'timeEnd': timeEnd,
        'userCreatedID': userCreatedID,
        'progressValue': progressValue,
        'colorCode': colorCode,
        'userCreateAvatar': userCreateAvatar,
        'userCreateName': userCreateName,
        'departmentNameUserCreate': departmentNameUserCreate,
        'userAssignsNames': userAssignsNames?.join(','),
        'userAssignsAvatars': userAssignsAvatars?.join(','),
        'description': description
      };
}

List<SearchListToDo_assignedTome> convertJson(Map<String, dynamic> json) {
  List<SearchListToDo_assignedTome> result = [];
  List<dynamic> data = json['data'];


  for (var item in data) {
    DateTime dateTimeStart = DateTime.parse(item['TimeStart']);
    DateTime dateTimeEnd = DateTime.parse(item['TimeEnd']);

    result.add(SearchListToDo_assignedTome(
      toDoListsID: item['ToDoListsID'],
      title: item['Title'],
      statusID: item['StatusID'],
      isConfirmed: item['IsConfirmed'],
      categoryNewsID: item['CategoryNewsID'],
      timeStart: dateTimeStart,
      timeEnd: dateTimeEnd,
      userCreatedID: item['UserCreatedID'],
      progressValue: item['ProgressValue'],
      colorCode: item['ColorCode'],
      userCreateAvatar: item['UserCreateAvatar'],
      userCreateName: item['UserCreateName'],
      departmentNameUserCreate: item['DepartmentNameUserCreate'],
      userAssignsNames: null,
          // (item['UserAssignsNames'] as String?)?.split(',') ?? [],
      userAssignsAvatars: null,
          // (item['UserAssignsAvatars'] as String?)?.split(',') ?? [],
      description: item['Description'],
    ));


  }

  return result;
}
