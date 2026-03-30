import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_first_app/app/app.dart';
import 'package:my_first_app/app/shared/storage/auth_storage.dart';

void main() {
  testWidgets('login screen renders backend-connected form', (
    WidgetTester tester,
  ) async {
    final LocalAuthStorage authStorage = LocalAuthStorage();
    await authStorage.initialize();

    await tester.pumpWidget(WorkLinkBootstrap(authStorage: authStorage));

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Connected Team Workflow'), findsOneWidget);
    expect(find.text('Demo account: zhangsan / 123456'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
