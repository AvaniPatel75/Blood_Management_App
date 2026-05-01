import 'package:blood_bank_app/controller/donation_controller.dart';
import 'package:blood_bank_app/controller/donor_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blood_bank_app/model/donation.dart';

class HistoryScreenDonor extends StatelessWidget {
  const HistoryScreenDonor({super.key});

  @override
  Widget build(BuildContext context) {

    final DonationController _donationController = Get.put(DonationController());
    final DonorController _donorController = Get.find<DonorController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
        if (_donationController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFD3002D),
              strokeWidth: 3,
            ),
          );
        }

        final history = _donationController.donorHistory;
        print("Donation hostory from history screen $history");
        if (history.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          color: const Color(0xFFD3002D),
          onRefresh: () async {
            final donorId = _donorController.donor.value?.donorId;
            print("donor id from history screen $donorId");
            if (donorId != null) {
              await _donationController.fetchHistoryByDonor(donorId);

            }
          },
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
            itemCount: history.length,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            itemBuilder: (context, index) {
              return _buildHistoryCard(history[index]);
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.history_toggle_off_rounded,
                  size: 60,
                  color: Colors.grey.shade400
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "No Record Found",
              style: TextStyle(
                  color: Color(0xFF580000),
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Make your first request for Blood",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(DonationModel donation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            //Navigate to detail view
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildIconSection(),
                const SizedBox(width: 16),
                _buildInfoSection(donation),
                _buildDateSection(donation),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Icon(Icons.water_drop_rounded,
          color: Color(0xFFD3002D),
          size: 28
      ),
    );
  }

  Widget _buildInfoSection(DonationModel donation) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            donation.targetId,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF580000),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                "${donation.units} Unit",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              _buildDotSeparator(),
              _buildStatusBadge(donation.status ?? "Pending"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection(DonationModel donation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _formatDisplayDate(donation.donationDate),
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Icon(Icons.arrow_forward_ios_rounded,
            size: 14,
            color: Color(0xFFE0E0E0)
        ),
      ],
    );
  }

  String _formatDisplayDate(String? dateStr) {
    if (dateStr == null) return "N/A";
    try {
      // Splits 2026-01-17 into [2026, 01, 17]
      List<String> parts = dateStr.split('T')[0].split('-');
      if (parts.length < 3) return dateStr;

      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      int monthIdx = int.parse(parts[1]) - 1;
      return "${parts[2]} ${months[monthIdx]}";
    } catch (e) {
      return dateStr.split('T')[0];
    }
  }

  Widget _buildStatusBadge(String status) {
    final bool isSuccess = ['completed', 'success', 'approved'].contains(status.toLowerCase());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSuccess ? const Color(0xFFE8F5E9) : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: isSuccess ? const Color(0xFF2E7D32) : Colors.orange.shade700,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDotSeparator() {
    return Container(
      width: 4,
      height: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(color: Color(0xFFD1D1D1), shape: BoxShape.circle),
    );
  }
}