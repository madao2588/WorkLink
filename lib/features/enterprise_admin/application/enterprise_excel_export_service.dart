import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_selector/file_selector.dart';

class EnterpriseExcelExportService {
  Future<String?> export({
    required String fileName,
    required List<String> headers,
    required List<List<Object?>> rows,
  }) async {
    final Excel excel = Excel.createExcel();
    final Sheet sheet = excel['Data'];

    for (int column = 0; column < headers.length; column++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: column, rowIndex: 0))
          .value = TextCellValue(headers[column]);
    }

    for (int row = 0; row < rows.length; row++) {
      final List<Object?> values = rows[row];
      for (int column = 0; column < values.length; column++) {
        final Object? value = values[column];
        sheet
            .cell(
              CellIndex.indexByColumnRow(
                columnIndex: column,
                rowIndex: row + 1,
              ),
            )
            .value = _toCellValue(value);
      }
    }

    final List<int>? bytes = excel.encode();
    if (bytes == null) {
      return null;
    }

    final FileSaveLocation? location = await getSaveLocation(
      suggestedName: fileName,
      acceptedTypeGroups: <XTypeGroup>[
        const XTypeGroup(
          label: 'Excel',
          extensions: <String>['xlsx'],
          mimeTypes: <String>[
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
          ],
        ),
      ],
    );

    if (location == null) {
      return null;
    }

    final XFile file = XFile.fromData(
      Uint8List.fromList(bytes),
      name: fileName,
      mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    );
    await file.saveTo(location.path);
    return location.path;
  }

  CellValue _toCellValue(Object? value) {
    if (value == null) {
      return TextCellValue('');
    }
    if (value is int) {
      return IntCellValue(value);
    }
    if (value is double) {
      return DoubleCellValue(value);
    }
    if (value is bool) {
      return BoolCellValue(value);
    }
    return TextCellValue(value.toString());
  }
}
