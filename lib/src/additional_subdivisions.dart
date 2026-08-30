import 'subdivision_details.dart';

/// ISO 3166-2 records added with the AX and SZ country records.
const Map<String, List<CountrySubdivision>> additionalSubdivisionsByCountry = {
  'AX': [
    CountrySubdivision(
        code: 'AX-001',
        countryAlpha2Code: 'AX',
        name: 'Mariehamn',
        type: 'Municipality'),
    CountrySubdivision(
        code: 'AX-002',
        countryAlpha2Code: 'AX',
        name: 'Brändö',
        type: 'Municipality'),
    CountrySubdivision(
        code: 'AX-003',
        countryAlpha2Code: 'AX',
        name: 'Eckerö',
        type: 'Municipality'),
    CountrySubdivision(
        code: 'AX-004',
        countryAlpha2Code: 'AX',
        name: 'Finström',
        type: 'Municipality'),
    CountrySubdivision(
        code: 'AX-005',
        countryAlpha2Code: 'AX',
        name: 'Föglö',
        type: 'Municipality'),
    CountrySubdivision(
        code: 'AX-006',
        countryAlpha2Code: 'AX',
        name: 'Geta',
        type: 'Municipality'),
    CountrySubdivision(
        code: 'AX-007',
        countryAlpha2Code: 'AX',
        name: 'Hammarland',
        type: 'Municipality'),
    CountrySubdivision(
        code: 'AX-008',
        countryAlpha2Code: 'AX',
        name: 'Jomala',
        type: 'Municipality'),
    CountrySubdivision(
        code: 'AX-009',
        countryAlpha2Code: 'AX',
        name: 'Kumlinge',
        type: 'Municipality'),
    CountrySubdivision(
        code: 'AX-010',
        countryAlpha2Code: 'AX',
        name: 'Kökar',
        type: 'Municipality'),
    CountrySubdivision(
        code: 'AX-011',
        countryAlpha2Code: 'AX',
        name: 'Lemland',
        type: 'Municipality'),
    CountrySubdivision(
        code: 'AX-012',
        countryAlpha2Code: 'AX',
        name: 'Lumparland',
        type: 'Municipality'),
    CountrySubdivision(
        code: 'AX-013',
        countryAlpha2Code: 'AX',
        name: 'Saltvik',
        type: 'Municipality'),
    CountrySubdivision(
        code: 'AX-014',
        countryAlpha2Code: 'AX',
        name: 'Sottunga',
        type: 'Municipality'),
    CountrySubdivision(
        code: 'AX-015',
        countryAlpha2Code: 'AX',
        name: 'Sund',
        type: 'Municipality'),
    CountrySubdivision(
        code: 'AX-016',
        countryAlpha2Code: 'AX',
        name: 'Vårdö',
        type: 'Municipality'),
  ],
  'SZ': [
    CountrySubdivision(
        code: 'SZ-HH', countryAlpha2Code: 'SZ', name: 'Hhohho', type: 'Region'),
    CountrySubdivision(
        code: 'SZ-LU',
        countryAlpha2Code: 'SZ',
        name: 'Lubombo',
        type: 'Region'),
    CountrySubdivision(
        code: 'SZ-MA',
        countryAlpha2Code: 'SZ',
        name: 'Manzini',
        type: 'Region'),
    CountrySubdivision(
        code: 'SZ-SH',
        countryAlpha2Code: 'SZ',
        name: 'Shiselweni',
        type: 'Region'),
  ],
};
