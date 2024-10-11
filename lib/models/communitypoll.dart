class CommunityPoll{
  final String? id;
  final String ProjectID;
  final String image;
  final String question;
  final String type;

  CommunityPoll({required this.id, required this.ProjectID, required this.image, required this.question, required this.type});

  String? get idx => id;
  String? get ProjectIDx => ProjectID;
  String? get imagex => image;
  String? get questionx => question;
  String? get typex => type;

  void printValue(){
    print(id);
    print(ProjectID);
    print(image);
    print(question);
    print(type);
  }

  @override
  String toString() => 'image: ${image}, type: ${type}';

}