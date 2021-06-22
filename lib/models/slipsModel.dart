import 'dart:convert';

class Slip {
  int slipId;
  String slipTitle;
  String slipHint;
  String slipDescription;
  List<String> imagesStringList;
  int collectionid;
  bool isSlipLiked;// 0--false,1--true
  String slipColor;
  Slip({
    this.slipTitle,
    this.slipDescription,
    this.slipHint,
    this.imagesStringList,
    this.collectionid,
    this.isSlipLiked=false,
    this.slipColor='0xFFE7E7C7',
  });

  Slip.withId({
    this.slipId,
    this.slipTitle,
    this.slipDescription,
    this.slipHint,
    this.imagesStringList,
    this.collectionid,
    this.isSlipLiked=false,
    this.slipColor='0xFFE7E7C7',
});

  factory Slip.fromDb(Map<String,dynamic> map){
    return Slip.withId(
        slipId : map['slipid'],
        slipTitle : map['slipTitle'],
        slipHint : map['slipHint'],
        slipDescription : map['slipDescription'],
        imagesStringList: jsonDecode(map['slipImagesStringList']).cast<String>(),
        collectionid: map['collectionId'],
        isSlipLiked: map['isslipLiked']==1?true:false,
        slipColor: map['slipColor'],
    );
  }

  Map<String, dynamic> toMap() {
    final map=Map<String,dynamic>();
      if(slipId!=null){
        map["slipid"]= slipId;
      }
      map["slipTitle"]= slipTitle;
      map["slipHint"]=slipHint;
      map["slipDescription"]=slipDescription;
      map['slipImagesStringList']=jsonEncode(imagesStringList);
      map['collectionId']=collectionid;
      map['isslipLiked']=isSlipLiked?1:0;
      map['slipColor']=slipColor;
      return map;
  }
}
