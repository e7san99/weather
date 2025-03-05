import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// final internetConnectionProvider = StreamProvider<bool>((ref) {
//   return InternetConnection().onStatusChange.map(
//         (status) => status == InternetStatus.connected,
//       );
// });

// final internetConnectionProvider = FutureProvider<bool>((ref) async {
//   var connectivityResult = await Connectivity().checkConnectivity();
//   return connectivityResult != ConnectivityResult.none;
// });

final internetConnectionProvider = FutureProvider<bool>((ref) async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return !connectivityResult.contains(ConnectivityResult.none);
});