import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class HttpSSLPinning {
  static Future<http.Client> get _instance async =>
      _clientInstance ??= await createClient();

  static http.Client? _clientInstance;
  static http.Client get client => _clientInstance ?? http.Client();

  static Future<void> init() async {
    _clientInstance = await _instance;
  }

  static Future<http.Client> createClient({bool isTestMode = false}) async {
    HttpClient client =
        HttpClient(context: await initSecurity(isTestMode: isTestMode));
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    return IOClient(client);
  }

  static Future<SecurityContext> initSecurity({bool isTestMode = false}) async {
    log("Initializing Security cert");
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    try {
      List<int> certFileBytes = [];
      if (isTestMode) {
        certFileBytes = utf8.encode(_errCertificate);
      } else {
        try {
          final data = await rootBundle.load('certificates/themoviedb.pem');
          certFileBytes = data.buffer.asUint8List();
          log("Cert File success loaded");
        } catch (e) {
          log("Err Access Cert: $e");
        }
      }

      securityContext.setTrustedCertificatesBytes(certFileBytes);
    } on TlsException catch (e) {
      if (e.osError?.message != null &&
          e.osError!.message.contains('CERT_ALREADY_IN_HASH_TABLE')) {
        log('Cert trusted.');
      } else {
        log('Exception: $e');
        rethrow;
      }
    } catch (e) {
      log("Exception: $e");
      rethrow;
    }
    return securityContext;
  }
}

const _errCertificate = """-----BEGIN CERTIFICATE-----
MIIDpTCCA0ugAwIBAgIRAOPOqehKnAvAEf911DBF7OkwCgYIKoZIzj0EAwIwOzEL
MAkGA1UEBhMCVVMxHjAcBgNVBAoTFUdvb2dsZSBUcnVzdCBTZXJ2aWNlczEMMAoG
A1UEAxMDV0UxMB4XDTI1MDkyMzA1MjQ1OFoXDTI1MTIyMjA2MjQ1NVowFjEUMBIG
A1UEAxMLbmV3c2FwaS5vcmcwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAAT4YW6+
7wvy9J1Y/zIo4LuP7QBVK303frAZ06yQn8AkaCz+9RKqdmk7Kn1WJDBLZ9sstuSJ
u56fM85xh/3115e0o4ICUzCCAk8wDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoG
CCsGAQUFBwMBMAwGA1UdEwEB/wQCMAAwHQYDVR0OBBYEFBmOxQe4oRl97irKeCUh
Hj/XTTeOMB8GA1UdIwQYMBaAFJB3kjVnxP+ozKnme9mAeXvMk/k4MF4GCCsGAQUF
BwEBBFIwUDAnBggrBgEFBQcwAYYbaHR0cDovL28ucGtpLmdvb2cvcy93ZTEvNDg0
MCUGCCsGAQUFBzAChhlodHRwOi8vaS5wa2kuZ29vZy93ZTEuY3J0MCUGA1UdEQQe
MByCC25ld3NhcGkub3Jngg0qLm5ld3NhcGkub3JnMBMGA1UdIAQMMAowCAYGZ4EM
AQIBMDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jLnBraS5nb29nL3dlMS90eWdx
bTJJcDBfdy5jcmwwggEEBgorBgEEAdZ5AgQCBIH1BIHyAPAAdgDM+w9qhXEJZf6V
m1PO6bJ8IumFXA2XjbapflTA/kwNsAAAAZl1Py9xAAAEAwBHMEUCIQDLm8Vwje61
18OkMvNqSYLG8mi70EfOvJQp89oI/7sr9wIgOXUP1MfGU83bbwj3iip3sLjxq5Jx
waI7XklPPg1amtYAdgAS8U40vVNyTIQGGcOPP3oT+Oe1YoeInG0wBYTr5YYmOgAA
AZl1Py8zAAAEAwBHMEUCIQDT5YYSRs90B8gMVQdPKkGNfmrv6T2OPMZn5KxIQwH0
JAIgAr1LJHauK1ZX+RfTSNkYRRpPt9Cerl0/KAkihn8wnY0wCgYIKoZIzj0EAwID
SAAwRQIgJKa7k52Jxu+W34Ifg+jk6pF7fY2kN+1mofGpZOJyL0sCIQCq8VY7j0DI
1KfRTXDEJt8+0DlzrTC5lmBepAgnIRJzpA==
-----END CERTIFICATE-----
""";
