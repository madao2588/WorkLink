class SalarySlipItem {
  const SalarySlipItem({
    required this.id,
    required this.month,
    required this.netAmount,
    required this.grossAmount,
    required this.status,
    required this.issuedAt,
  });

  final String id;
  final String month;
  final double netAmount;
  final double grossAmount;
  final String status;
  final DateTime issuedAt;
}
