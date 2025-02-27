import 'data/datasources/firebase_data_source.dart';
import 'data/repo/firebase_repo.dart';

// service

// Datasource
final FirebaseDataSource _firebaseDataSource = FirebaseDataSource();

// Repo
final FirebaseRepo firebaseRepo = FirebaseRepo(_firebaseDataSource);
