import 'dart:io';
import 'dart:typed_data';

void main() {
  final files = ['backend/scaler_mean.npy', 'backend/scaler_scale.npy'];
  for (var fileName in files) {
    final file = File(fileName);
    if (!file.existsSync()) {
      print('$fileName not found');
      continue;
    }
    final bytes = file.readAsBytesSync();
    print('\nFile: $fileName');
    print('Size: ${bytes.length} bytes');
    
    // Check magic number
    if (bytes[0] != 0x93 || 
        bytes[1] != 0x4E || // N
        bytes[2] != 0x55 || // U
        bytes[3] != 0x4D || // M
        bytes[4] != 0x50 || // P
        bytes[5] != 0x59) { // Y
      print('Not a valid .npy file');
      continue;
    }
    
    final major = bytes[6];
    final minor = bytes[7];
    final headerLen = ByteData.sublistView(bytes, 8, 10).getUint16(0, Endian.little);
    
    print('Version: $major.$minor');
    print('Header Length: $headerLen');
    
    final headerStr = String.fromCharCodes(bytes.sublist(10, 10 + headerLen));
    print('Header: $headerStr');
    
    final data = bytes.sublist(10 + headerLen);
    print('Data Length: ${data.length} bytes');
    
    // Assuming float64 (double) or float32 based on header
    if (headerStr.contains('<f8')) {
      final doubleList = Float64List.view(data.buffer, data.offsetInBytes, data.length ~/ 8);
      print('Values: $doubleList');
    } else if (headerStr.contains('<f4')) {
      final floatList = Float32List.view(data.buffer, data.offsetInBytes, data.length ~/ 4);
      print('Values: $floatList');
    }
  }
}

