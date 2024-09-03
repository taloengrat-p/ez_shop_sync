import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastNotificationService {
  static show({
    required String title,
    String? desc,
    ToastificationStyle? style,
    ToastificationType? type,
    ValueChanged<ToastificationItem>? onTap,
  }) {
    toastification.show(
      title: Text(title),
      description: desc != null
          ? Text(
              desc,
              style: const TextStyle(color: Colors.black54),
            )
          : null,
      style: style ?? ToastificationStyle.flatColored,
      showProgressBar: false,
      type: type ?? ToastificationType.success,
      autoCloseDuration: const Duration(seconds: 4),
      dragToClose: false,
      pauseOnHover: true,
      closeOnClick: true,
      callbacks: ToastificationCallbacks(onTap: onTap),
    );
  }
}
