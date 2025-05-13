// lib/core/error/error_handler.dart
import 'dart:async';
import 'dart:io';
import '../../core/error/failures.dart';

class ErrorHandler {
  // Convert failures to user-friendly messages
  static String getErrorMessage(Failure failure) {
    if (failure is ServerFailure) {
      return _handleServerFailure(failure);
    } else if (failure is NetworkFailure) {
      return _handleNetworkFailure(failure);
    } else {
      return failure.message.isNotEmpty ? failure.message : 'An unexpected error occurred';
    }
  }

  // Handle server-specific failures
  static String _handleServerFailure(ServerFailure failure) {
    // You can handle specific status codes here
    switch (failure.statusCode) {
      case 400:
        return 'Invalid request. Please try with different parameters.';
      case 401:
        return 'Authentication error. Please try again later.';
      case 403:
        return 'Access denied. You don\'t have permission to access this content.';
      case 404:
        return 'The requested content was not found.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
      case 501:
      case 502:
      case 503:
        return 'Server error. Please try again later.';
      default:
        return failure.message.isNotEmpty ? failure.message : 'Server communication error';
    }
  }

  // Handle network-specific failures
  static String _handleNetworkFailure(NetworkFailure failure) {
    return 'No internet connection. Please check your network settings.';
  }

  // Handle any general exception
  static String handleException(dynamic exception) {
    if (exception is SocketException) {
      return 'Network error. Please check your internet connection.';
    } else if (exception is HttpException) {
      return 'Could not connect to the server. Please try again.';
    } else if (exception is FormatException) {
      return 'Invalid response format. Please try again later.';
    } else if (exception is TimeoutException) {
      return 'Request timed out. Please try again later.';
    } else if (exception is Exception) {
      return 'An error occurred: ${exception.toString().replaceAll('Exception: ', '')}';
    }
    return 'An unexpected error occurred';
  }
  
  // Method to determine if error is recoverable (can retry)
  static bool isRecoverableError(dynamic error) {
    if (error is NetworkFailure) return true;
    if (error is ServerFailure && (error.statusCode == 429 || (error.statusCode ?? 0) >= 500)) return true;
    if (error is SocketException || error is TimeoutException) return true;
    return false;
  }
}