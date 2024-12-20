import 'package:flutter/material.dart';

class Toast {
  // Success Toast
  static void success(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 5)}) {
    _showToast(
      context,
      message,
      isSuccess: true,
      backgroundColor: const Color(0xFFCDFCCD),
      textColor: const Color(0xFF17AD15),
      duration: duration,
    );
  }

  // Error Toast
  static void error(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 5)}) {
    _showToast(
      context,
      message,
      isSuccess: false,
      backgroundColor: const Color(0xFFF9E8E9),
      textColor: Colors.red,
      duration: duration,
    );
  }

  static void _showToast(
    BuildContext context,
    String message, {
    required bool isSuccess,
    required Color backgroundColor,
    required Color textColor,
    required Duration duration,
  }) {
    final overlay = Overlay.of(context);
    late final OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        isSuccess: isSuccess,
        backgroundColor: backgroundColor,
        textColor: textColor,
        duration: duration,
        onDismiss: () => overlayEntry.remove(),
      ),
    );
    overlay.insert(overlayEntry);
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final bool isSuccess;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onDismiss;
  final Duration duration;

  const _ToastWidget({
    required this.message,
    required this.isSuccess,
    required this.backgroundColor,
    required this.textColor,
    required this.onDismiss,
    required this.duration,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () => _fadeIn());
    Future.delayed(widget.duration, () => _fadeOut());
  }

  void _fadeIn() {
    if (mounted) setState(() => _opacity = 1.0);
  }

  void _fadeOut() {
    if (mounted) {
      setState(() => _opacity = 0.0);
      Future.delayed(const Duration(milliseconds: 300), widget.onDismiss);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 32,
      right: 32,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _opacity,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIcon(),
                const SizedBox(width: 8),
                _buildMessage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 20,
      height: 20,
      decoration:
          BoxDecoration(color: widget.textColor, shape: BoxShape.circle),
      child: Icon(
        widget.isSuccess ? Icons.check : Icons.close,
        color: widget.backgroundColor,
        size: 14,
      ),
    );
  }

  Widget _buildMessage() {
    return Text(
      widget.message,
      style: TextStyle(
          color: widget.textColor, fontSize: 14, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}
