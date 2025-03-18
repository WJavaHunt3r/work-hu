import 'package:dio/dio.dart';
import 'package:work_hu/features/donation/data/api/donation_api.dart';
import 'package:work_hu/features/donation/data/model/donation_model.dart';
import 'package:work_hu/features/utils.dart';

class DonationRepository {
  final DonationsApi _donationApi;

  DonationRepository(this._donationApi);

  Future<List<DonationModel>> getDonations(DateTime? dateTime) async {
    try {
      final res = await _donationApi.getDonations(dateTime == null ? "" : dateTime.toString().replaceAll(" ", "T"));
      return res.map((e) => DonationModel.fromJson(e)).toList();
    } on DioException {
      rethrow;
    }
  }

  Future<DonationModel> getDonation(num donationId) async {
    try {
      final res = await _donationApi.getDonation(donationId);
      return DonationModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<DonationModel> postDonation(DonationModel donation, num userId) async {
    try {
      final res = await _donationApi.postDonation(donation, userId);
      return DonationModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<DonationModel> putDonation(DonationModel donation, num donationId) async {
    try {
      final res = await _donationApi.putDonation(donation, donationId);
      return DonationModel.fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deleteDonation(num donationId) async {
    try {
      final res = await _donationApi.deleteDonation(donationId);
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
