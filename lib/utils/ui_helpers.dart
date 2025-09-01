String secondsToMinutesLabel(int seconds) {
  final m = (seconds / 60).round();
  if (m == 1) return 'دقيقة واحدة';
  if (m < 5) return '$m دقائق';
  return '$m دقيقة';
}

String formatDistance(double meters) {
  if (meters < 1000) {
    return '${meters.toStringAsFixed(0)} م';
  } else {
    return '${(meters / 1000).toStringAsFixed(2)} كم';
  }
}
