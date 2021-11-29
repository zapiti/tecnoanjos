import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tecnoanjosclient/app/core/network/network_info.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfoImpl;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('Conexão com a internert', () {
    test(
      'Chamar a função DataConnectionChecker.hasConnection verificar conexão com a internet (online)',
      () async {

        final tHasConnectionFuture = Future.value(true);
        when(mockDataConnectionChecker.hasConnection).thenAnswer((_) => tHasConnectionFuture);

        final result = networkInfoImpl.isConnected;

        verify(mockDataConnectionChecker.hasConnection);
        expect(result, tHasConnectionFuture);
      },
    );

    test(
      'Chamar a função DataConnectionChecker.hasConnection verificar sem conexão com a internet (offline)',
      () async {
        final tHasConnectionFuture = Future.value(false);
        final tNoHasConnectionFuture = Future.value(false);
        when(mockDataConnectionChecker.hasConnection).thenAnswer((_) => tNoHasConnectionFuture);

        final result =  await networkInfoImpl.isConnected;
        final conection =  await tHasConnectionFuture;
        verify(mockDataConnectionChecker.hasConnection);
        expect(result, conection);
      },
    );
  });
}
