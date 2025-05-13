// lib/presentation/widgets/error_widget.dart
import 'package:flutter/material.dart';

class ErrorDisplayWidget extends StatelessWidget {
  final String message;
  final int? statusCode;
  final VoidCallback? onRetry;
  final bool showDebugInfo;

  const ErrorDisplayWidget({
    super.key,
    required this.message,
    this.statusCode,
    this.onRetry,
    this.showDebugInfo = false, // Set to true for development environments
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconForStatusCode(),
              size: 48,
              color: _getColorForStatusCode(),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            if (showDebugInfo && statusCode != null) ...[
              const SizedBox(height: 8),
              Text(
                'Status code: $statusCode',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (onRetry != null)
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForStatusCode() {
    if (statusCode == null) {
      return Icons.error_outline;
    }
    
    if (statusCode! >= 400 && statusCode! < 500) {
      // Client errors
      if (statusCode == 401 || statusCode == 403) {
        return Icons.lock_outline; // Authentication issues
      } else if (statusCode == 404) {
        return Icons.search_off; // Not found
      } else if (statusCode == 429) {
        return Icons.timer; // Rate limiting
      } else {
        return Icons.warning_amber_rounded; // Other client errors
      }
    } else if (statusCode! >= 500) {
      // Server errors
      return Icons.cloud_off; // Server issues
    } else {
      return Icons.error_outline; // Default error icon
    }
  }

  Color _getColorForStatusCode() {
    if (statusCode == null) {
      return Colors.red;
    }
    
    if (statusCode! >= 400 && statusCode! < 500) {
      return Colors.orange; // Client errors
    } else if (statusCode! >= 500) {
      return Colors.red; // Server errors
    } else {
      return Colors.red; // Default error color
    }
  }
}