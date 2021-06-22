class Collection{
  int collectionid;
  String collectionCategory;
  String collectionTitle;
  String collectionDescription;
  String collectionImage;
  bool isCollectionLiked;// 0--false,1--true
  String collectionColor;

  Collection({
    this.collectionTitle,
    this.collectionCategory,
    this.collectionDescription,
    this.collectionImage,
    this.isCollectionLiked,
    this.collectionColor,
  });

  Collection.withId({
    this.collectionid,
    this.collectionTitle,
    this.collectionCategory,
    this.collectionDescription,
    this.collectionImage,
    this.isCollectionLiked,
    this.collectionColor,
  });

  factory Collection.fromDb( Map<String,dynamic> map){
    return Collection.withId(
      collectionid: map['collectionId'],
      collectionCategory: map['collectionCategory'],
      collectionTitle: map['collectionTitle'],
      collectionDescription: map['collectionDescription'],
      collectionImage: map['collectionImageNumber'],
      isCollectionLiked: map['iscollectionLiked']==1?true:false,
      collectionColor: map['collectionColor'],
    );
  }
  
  Map<String,dynamic> toMap(){
    final map=Map<String,dynamic>();
    if(collectionid!=null){
      map['collectionId']=collectionid;
    }
    map['collectionCategory']=collectionCategory;
    map['collectionTitle']=collectionTitle;
    map['collectionDescription']=collectionDescription;
    map['collectionImageNumber']=collectionImage;
    map['iscollectionLiked']=isCollectionLiked?1:0;
    map['collectionColor']=collectionColor;
    return map;
  }
}