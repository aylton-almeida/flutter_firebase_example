import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'Routes.dart';

Future main() async {
  await DotEnv().load('.env');
  Routes();
}
