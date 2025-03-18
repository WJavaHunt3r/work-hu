import 'package:work_hu/app/locator.dart';
import 'package:work_hu/features/donation/data/model/donation_model.dart';

import '../../../../api/dio_client.dart';

class DonationsApi {
  final DioClient _dioClient = locator<DioClient>();

  DonationsApi();

  Future<List<dynamic>> getDonations(String dateTime) async {
    try {
      final res = await _dioClient.dio.get("/donations", queryParameters: {"dateTime": dateTime});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getDonation(num donationId) async {
    try {
      final res = await _dioClient.dio.get("/donations/$donationId");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postDonation(DonationModel donation, num userId) async {
    try {
      final res = await _dioClient.dio.post("/donations", data: donation.toJson(), queryParameters: {"userId": userId});
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> putDonation(DonationModel donation, num donationId) async {
    try {
      final res = await _dioClient.dio.put("/donations/$donationId", data: donation.toJson());
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteDonation(num donationId) async {
    try {
      final res = await _dioClient.dio.delete("/donations/$donationId");
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}
