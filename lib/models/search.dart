class Search {
  final String id;
  final String depart;

  Search({required this.id, required this.depart});

  factory Search.formJson(Map <dynamic, dynamic> json){
    return new Search(
      id: json['id'],
      depart: json['depart'],
    );
  }
}
