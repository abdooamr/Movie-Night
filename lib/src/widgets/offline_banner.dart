import 'dart:async';

import 'package:Movie_Night/generated/l10n.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

/// Wraps the app and shows a non-blocking banner while the device has no
/// network. Subscribes to [Connectivity.onConnectivityChanged], so it appears
/// when connectivity is lost mid-session and disappears on its own when it
/// returns. Never blocks input and never closes the app.
class OfflineBanner extends StatefulWidget {
  const OfflineBanner({super.key, required this.child});

  final Widget child;

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner> {
  StreamSubscription<List<ConnectivityResult>>? _sub;
  bool _offline = false;

  @override
  void initState() {
    super.initState();
    _sub = Connectivity().onConnectivityChanged.listen(_update);
    Connectivity().checkConnectivity().then(_update).catchError((_) {});
  }

  void _update(List<ConnectivityResult> results) {
    final offline = results.isEmpty ||
        results.every((r) => r == ConnectivityResult.none);
    if (mounted && offline != _offline) setState(() => _offline = offline);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.topCenter,
          child: _offline
              ? Material(
                  color: Colors.red.shade700,
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.wifi_off,
                              size: 16, color: Colors.white),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              S.of(context).noInternet,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
        Expanded(
          // The banner already consumed the status-bar inset when visible.
          child: MediaQuery.removePadding(
            context: context,
            removeTop: _offline,
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
