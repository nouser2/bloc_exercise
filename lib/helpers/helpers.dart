String formatTime(int sec, bool pad) {
  return (pad)
      ? '${(sec / 60).floor()}:${(sec % 60).toString().padLeft(2, '0')}'
      : (sec > 59)
          ? '${(sec / 60).floor()}:${(sec % 60).toString().padLeft(2, '0')}'
          : sec.toString();
}
