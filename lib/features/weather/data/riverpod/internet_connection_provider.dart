import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


//the StreamProvider to continuously monitor the connection status
// final internetConnectionProvider = StreamProvider<bool>((ref) {
//   return Connectivity().onConnectivityChanged.map(
//     (connectivityResults) {
//       // Check if any of the connectivity results indicate an active connection
//       return connectivityResults.any(
//         (result) => result != ConnectivityResult.none,
//       );
//     },
//   );
// });
//
final internetConnectionProvider = FutureProvider<bool>((ref) async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return !connectivityResult.contains(ConnectivityResult.none);
});