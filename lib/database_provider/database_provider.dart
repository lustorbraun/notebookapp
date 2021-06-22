import 'package:notebookapp/models/collectionsModel.dart';
import 'package:notebookapp/widgets/slip_tile.dart';
import '../models/slipsModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static final DatabaseHelper instance=DatabaseHelper._instance();
  DatabaseHelper._instance();

  static Database _slips_database;

  String _collectionTable='collectionstable';
  String _colcollectiontitle='collectionTitle';
  String _colcollectiondesc='collectionDescription';
  String _colcollectionId='collectionId';
  String _colcollectioncategory='collectionCategory';
  String _colcollectionimage='collectionImageNumber';
  String _colcollectionisLiked='iscollectionLiked';
  String _colcollectionColor='collectionColor';

  String _slipsTable='slipstable';
  String _colslipsId='slipid';
  String _colsliptitle='slipTitle';
  String _colsliphint='slipHint';
  String _colslipdesc='slipDescription';
  String _colslipimageStringList='slipImagesStringList';
  String _colslipcollectionId='collectionId';
  String _colslipisLiked='isslipLiked';
  String _colslipColor='slipColor';

  Future<Database> get getSlipsDatabase async{
    if(_slips_database==null){
      _slips_database= await init();
    }
    return _slips_database;
  }

  Future<Database> init() async {
    var docDirectory = await getApplicationDocumentsDirectory();
    final path = docDirectory.toString() + '/Slips.db';
    final database = await openDatabase(
      path,
      version: 1,
      onCreate: createDatabase,
      onUpgrade: updateDatabase,
    );
    return database;
  }

  void updateDatabase(Database db, int oldVersion, int newVersion )async{
    Batch batch=db.batch();
    batch.execute("""DROP TABLE IF EXISTS $_collectionTable ;""");
    batch.execute("""DROP TABLE IF EXISTS $_slipsTable ;""");
    batch.execute("""
        CREATE TABLE IF NOT EXISTS $_collectionTable
        (
          $_colcollectionId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_colcollectiontitle TEXT,
          $_colcollectiondesc TEXT,
          $_colcollectioncategory TEXT,
          $_colcollectionimage TEXT,
          $_colcollectionisLiked INTEGER,
          $_colcollectionColor TEXT
        )
        """);
    batch.execute("""
        CREATE TABLE IF NOT EXISTS $_slipsTable
        (
          $_colslipsId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_colsliptitle TEXT,
          $_colsliphint TEXT,
          $_colslipdesc TEXT,
          $_colslipimageStringList BLOB,
          $_colslipcollectionId INTEGER,
          $_colslipisLiked INTEGER,
          $_colslipColor TEXT
        )
      """);
    await batch.commit();
  }

  void createDatabase(Database newDb, int version) async{
    Batch batch = newDb.batch();
      batch.execute("""
        CREATE TABLE IF NOT EXISTS $_collectionTable
        (
          $_colcollectionId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_colcollectiontitle TEXT,
          $_colcollectiondesc TEXT,
          $_colcollectioncategory TEXT,
          $_colcollectionimage TEXT,
          $_colcollectionisLiked INTEGER,
          $_colcollectionColor TEXT
        )
        """);
       batch.execute("""
        CREATE TABLE IF NOT EXISTS $_slipsTable
        (
          $_colslipsId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_colsliptitle TEXT,
          $_colsliphint TEXT,
          $_colslipdesc TEXT,
          $_colslipimageStringList BLOB,
          $_colslipcollectionId INTEGER,
          $_colslipisLiked INTEGER,
          $_colslipColor TEXT
        )
      """);
    await batch.commit();
  }

  Future<List<Map<String,dynamic>>> _getCollectionMapList() async{
    Database _db=await getSlipsDatabase;
    List<Map<String,dynamic>> _listSlipMap=await _db.query(_collectionTable);
    if (_listSlipMap.length > 0) {
      print(_listSlipMap.length);
      return _listSlipMap;
    }
    return null;
  }

  Future<List<Collection>> getCollectionsList() async{
    List<Map<String, dynamic>> _listSlipMap=await _getCollectionMapList();
    List<Collection> _collectionList=[];
    _listSlipMap.forEach((map) {
      Collection collection=Collection.fromDb(map);
      _collectionList.add(collection);
    });
    _collectionList.sort((collectionA, collectionB) => collectionA.collectionid.compareTo(collectionB.collectionid));
    return _collectionList;
  }

  Future<List<Map<String,dynamic>>> _getLikedCollectionMapList() async{
    Database _db=await getSlipsDatabase;
    List<Map<String,dynamic>> _listSlipMap=await _db.query(_collectionTable,columns: null,where: "$_colcollectionisLiked=1");
    if (_listSlipMap.length > 0) {
      return _listSlipMap;
    }
    return null;
  }

  Future<List<Collection>> getLikedCollectionsList() async{
    List<Map<String, dynamic>> _listSlipMap=await _getLikedCollectionMapList();
    List<Collection> _collectionList=[];
    _listSlipMap.forEach((map) {
      Collection collection=Collection.fromDb(map);
      _collectionList.add(collection);
    });
    _collectionList.sort((collectionA, collectionB) => collectionA.collectionid.compareTo(collectionB.collectionid));
    return _collectionList;
  }


  Future<List<Map<String, dynamic>>> _getSlipMapList(int collectionId) async {
    Database _db= await getSlipsDatabase;
    List<Map<String, dynamic>> _listSlipMap = await _db.query(_slipsTable,columns: null, whereArgs: [collectionId],where: "$_colslipcollectionId=?",
    );

    if (_listSlipMap.length > 0) {
      return _listSlipMap;
    }
    return null;
  }

  Future<List<Slip>> getSlipList(int collectionId) async{
    List<Map<String,dynamic>> _slipMapList= await _getSlipMapList(collectionId);
    List<Slip> _slipList=[];
    _slipMapList.forEach((map) {
      Slip _slip=Slip.fromDb(map);
      _slipList.add(_slip);
    });
    _slipList.sort((slipA, slipB) => slipA.slipId.compareTo(slipB.slipId));
    return _slipList;
  }

  Future<List<Map<String, dynamic>>> _getLikedSlipMapList() async {
    Database _db= await getSlipsDatabase;
    List<Map<String, dynamic>> _listSlipMap = await _db.query(_slipsTable,columns: null,whereArgs: [1],where: "$_colslipisLiked=?",
    );

    if (_listSlipMap.length > 0) {
      return _listSlipMap;
    }
    return null;
  }

  Future<List<Slip>> getLikedSlipList() async{
    List<Map<String,dynamic>> _slipMapList= await _getLikedSlipMapList();
    List<Slip> _slipList=[];
    _slipMapList.forEach((map) {
      Slip _slip=Slip.fromDb(map);
      _slipList.add(_slip);
    });
    _slipList.sort((slipA, slipB) => slipA.slipId.compareTo(slipB.slipId));
    return _slipList;
  }

  Future<List<Map<String, dynamic>>> _getCategoryCollectionsMap(String category) async {
    Database _db= await getSlipsDatabase;
    List<Map<String, dynamic>> _listSlipMap = await _db.query(_collectionTable,columns: null,whereArgs: [category],where: "$_colcollectioncategory=?",
    );

    if (_listSlipMap.length > 0) {
      return _listSlipMap;
    }
    return null;
  }

  Future<List<Slip>> getCategoryCollections(String category) async{
    List<Map<String,dynamic>> _collectionMapList= await _getCategoryCollectionsMap(category);
    List<Slip> _collectionList=[];
    _collectionMapList.forEach((map) {
      Slip _slip=Slip.fromDb(map);
      _collectionList.add(_slip);
    });
    _collectionList.sort((slipA, slipB) => slipA.slipId.compareTo(slipB.slipId));
    return _collectionList;
  }

  Future<int> updateSlip(Slip _slip) async{
    Database _db=await getSlipsDatabase;
    final int result = await _db.update(_slipsTable, _slip.toMap(),where: "$_colslipsId=?",whereArgs: [_slip.slipId]);
    return result;
  }

  Future<int> updateCollection(Collection _collection) async{
    Database _db=await getSlipsDatabase;
    final int result=await _db.update(_collectionTable, _collection.toMap(),where: '$_colcollectionId=?',whereArgs: [_collection.collectionid]);
    return result;
  }

  Future<int> insertSlip(Slip _slip) async{
    Database _db=await getSlipsDatabase;
    final int result = await _db.insert(_slipsTable, _slip.toMap());
    return result;
  }

  Future<int> insertCollection(Collection _collection) async{
    Database _db=await getSlipsDatabase;
    final int result = await _db.insert(_collectionTable, _collection.toMap());
    return result;
  }

  Future<int> deleteSlip(int _id) async{
    Database _db=await getSlipsDatabase;
    final int result = await _db.delete(_slipsTable,where: "$_colslipsId=?",whereArgs: [_id]);
    return result;
  }

  Future<int> deleteCollectionSlips(int _collectionId) async{
    Database _db= await getSlipsDatabase;
    final int result= await _db.delete(_slipsTable,where: "$_colslipcollectionId=?",whereArgs: [_collectionId]);
  }

  Future<int> deleteCollection(int _id) async{
    Database _db=await getSlipsDatabase;
    final int result=await _db.delete(_collectionTable,where: '$_colcollectionId=?',whereArgs: [_id]);
    return result;
  }
}
