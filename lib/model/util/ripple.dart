class Ripple {
  const Ripple({required this.peaks, required this.magnitude});
  final int peaks;
  final double magnitude;

  double of(double x) {
    final px = peaks * x / 2;
    return magnitude * ((4 * (px - (px + .25).floor()) - 1).abs() - 1);
  }
}
