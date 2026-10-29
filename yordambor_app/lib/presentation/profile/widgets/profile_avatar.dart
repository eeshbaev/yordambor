import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/public_profile_providers.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/data/auth/auth_repository.dart';
import 'package:yordambor/data/storage/storage_repository.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';

class ProfileAvatar extends ConsumerStatefulWidget {
  const ProfileAvatar({
    super.key,
    required this.fullName,
    this.avatarUrl,
    this.radius = 36,
    this.editable = false,
    this.showChangePhotoAction = true,
  });

  final String fullName;
  final String? avatarUrl;
  final double radius;
  final bool editable;
  final bool showChangePhotoAction;

  @override
  ConsumerState<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends ConsumerState<ProfileAvatar> {
  var _isUploading = false;

  Future<void> _changePhoto() async {
    if (!widget.editable || _isUploading) return;

    final session = ref.read(sessionProvider);
    final userId = session.user?.id;
    if (userId == null) return;

    final strings = ref.read(appStringsProvider);
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1200,
      maxHeight: 1200,
    );
    if (file == null || !mounted) return;

    setState(() => _isUploading = true);

    try {
      final bytes = await file.readAsBytes();
      final ext = file.path.split('.').last.toLowerCase();
      final normalizedExt =
          ext == 'png' || ext == 'webp' || ext == 'jpeg' ? ext : 'jpg';

      final url = await ref.read(storageRepositoryProvider).uploadAvatarImage(
            ownerId: userId,
            bytes: bytes,
            fileExtension: normalizedExt == 'jpeg' ? 'jpg' : normalizedExt,
          );

      await ref.read(authRepositoryProvider).updateAvatarUrl(url);
      await ref.read(sessionProvider.notifier).refreshProfile();
      ref.invalidate(publicUserProfileProvider(userId));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.profilePhotoUpdated)),
        );
      }
    } on StorageFailure catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    } on AuthFailure catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.profilePhotoFailed)),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final diameter = widget.radius * 2;
    final avatarUrl = widget.avatarUrl;
    final initials = _initials(widget.fullName);

    final avatar = SizedBox.square(
      dimension: diameter,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primaryContainer,
          image: avatarUrl != null && avatarUrl.isNotEmpty
              ? DecorationImage(
                  image: CachedNetworkImageProvider(avatarUrl),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: avatarUrl == null || avatarUrl.isEmpty
            // Like CircleAvatar: initials stay inside the circle.
            ? Center(
                child: MediaQuery.withNoTextScaling(
                  child: Text(
                    initials,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              )
            : null,
      ),
    );

    if (!widget.editable) return avatar;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            avatar,
            if (_isUploading)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
              ),
            Positioned(
              right: -2,
              bottom: -2,
              child: Material(
                color: context.ybColors.teal,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _isUploading ? null : _changePhoto,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      YbIcons.cameraAlt,
                      size: 18,
                      color: context.ybColors.onTeal,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (widget.showChangePhotoAction) ...[
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: _isUploading ? null : _changePhoto,
            child: Text(strings.profileChangePhoto),
          ),
        ],
      ],
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
