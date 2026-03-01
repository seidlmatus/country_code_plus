import 'package:country_codes_plus/country_codes_plus.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CountryCodes.init();
  runApp(CountryCodesExampleApp());
}

class CountryCodesExampleApp extends StatelessWidget {
  TableRow _buildEntry({required String title, required String description}) {
    return TableRow(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: Text(
            title,
            textAlign: TextAlign.end,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(description),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Country codes example app'),
        ),
        body: Builder(builder: (context) {
          final CountryDetails details = CountryCodes.detailsForLocale();
          final Locale locale = CountryCodes.getDeviceLocale()!;
          final String alpha2 = details.alpha2Code!;
          final List<CountrySubdivision> subdivisions =
              CountryCodes.subdivisionsForCountry(alpha2);
          final CountrySubdivision? firstSubdivision = subdivisions.isNotEmpty
              ? CountryCodes.subdivisionFromCode(subdivisions.first.code)
              : null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Table(
                  border: TableBorder(
                    horizontalInside: const BorderSide(width: 0.5),
                    verticalInside: const BorderSide(width: 0.5),
                    top: const BorderSide(),
                    bottom: const BorderSide(),
                    left: const BorderSide(),
                    right: const BorderSide(),
                  ),
                  children: <TableRow>[
                    _buildEntry(
                        title: 'Device region',
                        description:
                            '${locale.languageCode}-${locale.countryCode}'),
                    _buildEntry(title: 'Name', description: '${details.name}'),
                    _buildEntry(
                        title: 'Localized (PT lang)',
                        description: '${details.localizedName}'),
                    _buildEntry(
                        title: 'Alpha 2', description: '${details.alpha2Code}'),
                    _buildEntry(
                        title: 'Dial code', description: '${details.dialCode}'),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Subdivisions for $alpha2 (${subdivisions.length})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8.0),
                if (subdivisions.isEmpty)
                  const Text('No subdivisions available for this country.')
                else
                  ...subdivisions.take(5).map(
                        (subdivision) => Text(
                          '${subdivision.code}: ${subdivision.name}'
                          '${subdivision.type != null ? ' (${subdivision.type})' : ''}',
                        ),
                      ),
                const SizedBox(height: 12.0),
                if (firstSubdivision != null)
                  Text(
                    'Lookup example: ${firstSubdivision.code} -> ${firstSubdivision.name}',
                  ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 200.0,
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    inputFormatters: [DialCodeFormatter()],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
