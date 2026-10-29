import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/yordam_kerak_provider.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_job_post_card.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/share/feed_share.dart';
import 'package:yordambor/presentation/kelishuv/yordam_bor_flow.dart';

class YordamKerakPostScreen extends ConsumerWidget {
  const YordamKerakPostScreen({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final postAsync = ref.watch(yordamKerakPostProvider(postId));

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.filterYordamKerak),
        actions: [
          postAsync.maybeWhen(
            data: (item) {
              if (item == null) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(YbIcons.share),
                tooltip: strings.shareYordamKerak,
                onPressed: () => FeedShare.shareYordamKerakPost(
                  strings: strings,
                  postId: item.id,
                  title: item.title,
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: postAsync.when(
        loading: () => const YbSkeletonList(),
        error: (_, _) => Center(child: Text(strings.postNotFound)),
        data: (item) {
          if (item == null) {
            return Center(child: Text(strings.postNotFound));
          }

          return ListView(
            padding: EdgeInsets.only(
              top: AppSpacing.sm,
              bottom: AppSpacing.lg + AppShell.scrollBottomPadding(context),
            ),
            children: [
              YbJobPostCard(
                item: item,
                sectorLine: strings.sectorLine(
                  item.categoryLabel,
                  item.subcategoryLabel,
                ),
                cityLabel: strings.serviceCityDisplayLabel(item.serviceCity),
                sampleLabel: item.isDemo ? strings.sampleTag : null,
                yordamBorLabel: strings.filterYordamBor,
                compact: false,
                onTap: () {},
                onAuthorTap: item.authorId != null && item.showProfile
                    ? () => context.push('/user/${item.authorId}')
                    : null,
                phoneHiddenLabel: strings.userProfilePhoneHidden,
                onYordamBor: () => answerHelpRequest(context, ref, item),
              ),
            ],
          );
        },
      ),
    );
  }
}
