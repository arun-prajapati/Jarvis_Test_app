class Users {
  int page;
  int perPage;
  int total;
  int totalPages;
  List<Data> data;

  Users({this.page, this.perPage, this.total, this.totalPages, this.data});

  Users.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    perPage = json['per_page'];
    total = json['total'];
    totalPages = json['total_pages'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    data['total_pages'] = this.totalPages;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int id;
  String email;
  String first_Name;
  String last_Name;
  String avatar;

  Data({this.id, this.email, this.first_Name, this.last_Name, this.avatar});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    first_Name = json['first_name'];
    last_Name = json['last_name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['first_name'] = this.first_Name;
    data['last_name'] = this.last_Name;
    data['avatar'] = this.avatar;
    return data;
  }



  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'first_name': first_Name,
      'last_name': last_Name,
      'email':email,
      'avatar':avatar
    };
  }


}


