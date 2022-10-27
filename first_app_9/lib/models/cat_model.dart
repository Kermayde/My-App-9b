import 'dart:convert';

class Planet {
  final int?id;
  final String Description;
  final String Type;
  final String Nature;
  final String Size;
  final String Distance;
  final String Image;
  final String Name;

  Planet(
  {
    this.id, required this.Description, required this.Type, required this.Nature, required this.Size, required this.Distance, required this.Image, required this.Name
  }
  );
  factory Planet.formMap(Map<String, dynamic> json) => 
    Planet(id: json['id'], Description: json['Description'], Type: json['Type'], Nature: json['Nature'], Size: json['Size'], Distance: json['Distance'], Image: json['Image'], Name: json['Name']);

    Map<String, dynamic> toMap(){
      return{
        'id': id,
        'Description': Description,
        'Type': Type,
        'Nature': Nature,
        'Size': Size,
        'Distance': Distance,
        'Image': Image,
        'Name': Name,
      };
    }
}





