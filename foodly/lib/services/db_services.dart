import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodly/constants/strings.dart';
import 'package:foodly/models/caroSlide.dart';
import 'package:foodly/models/cartItem.dart';
import 'package:foodly/models/category.dart';
import 'package:foodly/models/database_item.dart';
import 'package:foodly/models/order.dart';
import 'package:foodly/models/product.dart';

class DatabaseService<T extends DatabaseItem> {
  final String collection;
  final Firestore _db = Firestore.instance;
  final T Function(String, Map<String, dynamic>) fromDS;
  final Map<String, dynamic> Function(T) toMap;
  DatabaseService(this.collection, {this.fromDS, this.toMap});

  Future<T> getSingle(String id) async {
    var snap = await _db.collection(collection).document(id).get();
    if (!snap.exists) return null;
    return fromDS(snap.documentID, snap.data);
  }

  Stream<T> streamSingle(String id) {
    return _db
        .collection(collection)
        .document(id)
        .snapshots()
        .map((snap) => fromDS(snap.documentID, snap.data));
  }

  Stream<List<T>> streamListByUserId(String uid) {
    var ref = _db.collection(collection).where("userId", isEqualTo: uid);

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => fromDS(doc.documentID, doc.data)).toList());
  }

  Stream<List<T>> streamListByCategoryId(String cid) {
    var ref = _db.collection(collection).where("categoryId", isEqualTo: cid);

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => fromDS(doc.documentID, doc.data)).toList());
  }

  Stream<List<T>> streamList() {
    var ref = _db.collection(collection);

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => fromDS(doc.documentID, doc.data)).toList());
  }

  //for order specially
  Stream<List<T>> streamOrderList() {
    var ref =
        _db.collection(collection).orderBy("orderState", descending: true);

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => fromDS(doc.documentID, doc.data)).toList());
  }

  Stream<List<T>> streamOrderListByUserId(String uid) {
    var ref = _db
        .collection(collection)
        .where("userId", isEqualTo: uid)
        .orderBy("orderState", descending: true);

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => fromDS(doc.documentID, doc.data)).toList());
  }

  Future<List<T>> getQueryList({List<QueryArgs> args = const []}) async {
    CollectionReference collref = _db.collection(collection);
    Query ref;
    for (QueryArgs arg in args) {
      if (ref == null)
        ref = collref.where(arg.key, isEqualTo: arg.value);
      else
        ref = ref.where(arg.key, isEqualTo: arg.value);
    }
    QuerySnapshot query;
    if (ref != null)
      query = await ref.getDocuments();
    else
      query = await collref.getDocuments();

    return query.documents
        .map((doc) => fromDS(doc.documentID, doc.data))
        .toList();
  }

  Stream<List<T>> streamQueryList({List<QueryArgs> args = const []}) {
    CollectionReference collref = _db.collection(collection);
    Query ref;
    for (QueryArgs arg in args) {
      ref = ref.where(arg.key, isEqualTo: arg.value);
    }
    var query;
    if (ref != null)
      query = ref.snapshots();
    else
      query = collref.snapshots();
    return query.map((snap) =>
        snap.documents.map((doc) => fromDS(doc.documentID, doc.data)).toList());
  }

  Future<List<T>> getListFromTo(String field, DateTime from, DateTime to,
      {List<QueryArgs> args = const []}) async {
    var ref = _db.collection(collection).orderBy(field);
    for (QueryArgs arg in args) {
      ref = ref.where(arg.key, isEqualTo: arg.value);
    }
    QuerySnapshot query = await ref.startAt([from]).endAt([to]).getDocuments();
    return query.documents
        .map((doc) => fromDS(doc.documentID, doc.data))
        .toList();
  }

  Stream<List<T>> streamListFromTo(String field, DateTime from, DateTime to,
      {List<QueryArgs> args = const []}) {
    var ref = _db.collection(collection).orderBy(field, descending: true);
    for (QueryArgs arg in args) {
      ref = ref.where(arg.key, isEqualTo: arg.value);
    }
    var query = ref.startAfter([to]).endAt([from]).snapshots();
    return query.map((snap) =>
        snap.documents.map((doc) => fromDS(doc.documentID, doc.data)).toList());
  }

  Future<dynamic> createItem(T item, {String id}) {
    if (id != null) {
      return _db.collection(collection).document(id).setData(toMap(item));
    } else {
      return _db.collection(collection).add(toMap(item));
    }
  }

  Future<void> updateItem(T item) {
    return _db
        .collection(collection)
        .document(item.id)
        .setData(toMap(item), merge: true);
  }

  Future<void> removeItem(String id) {
    return _db.collection(collection).document(id).delete();
  }
}

class QueryArgs {
  final String key;
  final dynamic value;

  QueryArgs(this.key, this.value);
}

DatabaseService<CartItem> cartItemDb = DatabaseService<CartItem>(
    CART_COLLECTION,
    fromDS: (id, data) => CartItem.fromDS(id, data),
    toMap: (cartItem) => cartItem.toMap());

DatabaseService<Order> orderItemDb = DatabaseService<Order>(ORDERS_COLLECTION,
    fromDS: (id, data) => Order.fromDS(id, data),
    toMap: (order) => order.toMap());

DatabaseService<Product> productItemDb = DatabaseService<Product>(
    PRODUCTS_COLLECTION,
    fromDS: (id, data) => Product.fromDS(id, data),
    toMap: (order) => order.toMap());

DatabaseService<Category> categoryItemDb = DatabaseService<Category>(
    CATEGORIES_COLLECTION,
    fromDS: (id, data) => Category.fromDS(id, data),
    toMap: (order) => order.toMap());

DatabaseService<CaroSlide> caroSlideItemDb = DatabaseService<CaroSlide>(
    CAROSLIDE_COLLECTION,
    fromDS: (id, data) => CaroSlide.fromDS(id, data),
    toMap: (caroSlide) => caroSlide.toMap());
