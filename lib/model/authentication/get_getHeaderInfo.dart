

class Staff {
  final int? staffID;
  final String? staffCode;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? imagesPath;
  final String? currentCompanyName;
  final List<Company>? companies;

  Staff({
    this.staffID,
    this.staffCode,
    this.fullName,
    this.email,
    this.phone,
    this.imagesPath,
    this.currentCompanyName,
    this.companies,
  });

  // Factory constructor to create an instance from JSON
  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      staffID: json['StaffID'] as int?,
      staffCode: json['StaffCode'] as String?,
      fullName: json['FullName'] as String?,
      email: json['Email'] as String?,
      phone: json['Phone'] as String?,
      imagesPath: json['ImagesPath'] as String?,
      currentCompanyName: json['CurrentCompanyName'] as String?,
      companies: (json['Companies'] as List?)
          ?.map((company) => Company.fromJson(company))
          .toList(),
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'StaffID': staffID,
      'StaffCode': staffCode,
      'FullName': fullName,
      'Email': email,
      'Phone': phone,
      'ImagesPath': imagesPath,
      'CurrentCompanyName': currentCompanyName,
      'Companies': companies?.map((company) => company.toJson()).toList(),
    };
  }
}

class Company {
  final int? companyID;
  final String? companyName;
  final String? companyDescription;

  Company({
    this.companyID,
    this.companyName,
    this.companyDescription,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyID: json['CompanyID'] as int?,
      companyName: json['CompanyName'] as String?,
      companyDescription: json['CompanyDescription'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CompanyID': companyID,
      'CompanyName': companyName,
      'CompanyDescription': companyDescription,
    };
  }
}