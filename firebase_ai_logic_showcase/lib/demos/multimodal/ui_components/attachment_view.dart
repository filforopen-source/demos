// Copyright 2025 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import '../../../shared/ui/app_spacing.dart';
import '../models/attachment.dart';

class AttachmentView extends StatelessWidget {
  final Attachment? attachment;

  const AttachmentView({super.key, this.attachment});

  @override
  Widget build(BuildContext context) {
    return attachment == null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                size: 81,
                color: Theme.of(context).colorScheme.outline,
                Icons.attach_file,
              ),
              const SizedBox.square(dimension: AppSpacing.s16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                child: Text(
                  'Select a file',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPreview(context),
              const SizedBox.square(dimension: AppSpacing.s16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                child: Text(
                  attachment!.fileName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
  }

  Widget _buildPreview(BuildContext context) {
    final mimeType = attachment!.mimeType.toLowerCase();
    
    if (mimeType.startsWith('image/')) {
      return Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.memory(
            attachment!.fileBytes,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildIconFallback(
              context,
              Icons.broken_image,
              Colors.red,
              'Image',
            ),
          ),
        ),
      );
    }
    
    if (mimeType.contains('pdf')) {
      return _buildIconFallback(
        context,
        Icons.picture_as_pdf,
        Colors.red.shade600,
        'PDF',
      );
    }
    
    if (mimeType.startsWith('video/')) {
      return _buildIconFallback(
        context,
        Icons.video_file,
        Colors.indigo.shade600,
        'Video',
      );
    }

    if (mimeType.startsWith('audio/')) {
      return _buildIconFallback(
        context,
        Icons.audiotrack,
        Colors.amber.shade700,
        'Audio',
      );
    }

    if (mimeType.startsWith('text/') ||
        mimeType.contains('json') ||
        mimeType.contains('javascript') ||
        mimeType.contains('xml')) {
      return _buildIconFallback(
        context,
        Icons.code,
        Colors.teal.shade600,
        'Code',
      );
    }

    // Default document fallback
    return _buildIconFallback(
      context,
      Icons.insert_drive_file,
      Colors.blueGrey.shade600,
      'File',
    );
  }

  Widget _buildIconFallback(
    BuildContext context,
    IconData icon,
    Color primaryColor,
    String label,
  ) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.15),
            primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: primaryColor.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.05),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: primaryColor,
          ),
          Positioned(
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

