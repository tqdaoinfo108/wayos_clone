class WorkflowRequestInformationModel {
  final String title;
  final String typeWorkFlowName;
  final String departmentUserRequirement;
  final String userRequirementName;
  final String dateCreated;
  final String fieldDetails;

  WorkflowRequestInformationModel(
      {required this.title,
      required this.typeWorkFlowName,
      required this.departmentUserRequirement,
      required this.userRequirementName,
      required this.dateCreated,
      required this.fieldDetails});

  factory WorkflowRequestInformationModel.fromMap(Map<String, dynamic> json) =>
      WorkflowRequestInformationModel(
        title: json['Title'],
        typeWorkFlowName: json['TypeWorkFlowName'],
        departmentUserRequirement: json['DepartmentUserRequirement'],
        userRequirementName: json['UserRequirementName'],
        dateCreated: json['DateCreated'],
        fieldDetails: json['FieldDetails'],
      );
}
