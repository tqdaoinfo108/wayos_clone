class WorkflowRequestInformationModel {
  final String title;
  final String typeWorkFlowName;
  final String departmentUserRequirement;
  final String userCreated;
  final String dateCreated;

  WorkflowRequestInformationModel(
      {required this.title,
      required this.typeWorkFlowName,
      required this.departmentUserRequirement,
      required this.userCreated,
      required this.dateCreated});

  factory WorkflowRequestInformationModel.fromMap(Map<String, dynamic> json) =>
      WorkflowRequestInformationModel(
        title: json['Title'],
        typeWorkFlowName: json['TypeWorkFlowName'],
        departmentUserRequirement: json['DepartmentUserRequirement'],
        userCreated: json['UserCreated'],
        dateCreated: json['DateCreated'],
      );
}
