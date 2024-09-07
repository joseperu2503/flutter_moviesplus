import 'package:flutter/material.dart';
import 'package:moviesplus/config/constants/app_colors.dart';
import 'package:moviesplus/config/constants/styles.dart';
import 'package:moviesplus/features/dashboard/widgets/web/appbar.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final List<Policy> policies = [
    Policy(
      title: '1. Information Collected',
      description:
          'MoviesPlus does not collect or store any personally identifiable information from users. The app simply displays information about movies, actors, and other related content.',
    ),
    Policy(
      title: '2. Use of Information',
      description:
          'MoviesPlus uses a third-party API (The Movie Database) to provide data on movies and related content. The information displayed includes descriptions, images, trailers, release dates, and more, but no personal data from users is collected.',
    ),
    Policy(
      title: '3. Browsing Data',
      description:
          'While we do not collect personal data, MoviesPlus may automatically collect non-identifiable technical data, such as device type and operating system, to improve the user experience. This information is used solely for analytical purposes and to optimize app performance.',
    ),
    Policy(
      title: '4. Information Sharing',
      description:
          'MoviesPlus does not share personal or technical information with third parties. The data provided by The Movie Database API is used exclusively within the app to display content.',
    ),
    Policy(
      title: '5. External Links',
      description:
          'MoviesPlus may contain links to external websites or services, such as trailers or videos. We are not responsible for the privacy practices or content of these external sites, and we encourage users to review their privacy policies before engaging with them.',
    ),
    Policy(
      title: '6. Security',
      description:
          'We are committed to protecting the data used within MoviesPlus. Although we do not store personal information, we take steps to ensure that the data provided by the API is handled securely.',
    ),
    Policy(
      title: '7. Changes to This Policy',
      description:
          'We reserve the right to update this Privacy Policy at any time. Any changes will be posted on this page, and we encourage users to review it periodically.',
    ),
    Policy(
      title: '8. Contact Us',
      description:
          'If you have any questions about our Privacy Policy, please contact us at joseperu2503@gmail.com.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWeb(
        scrollController: _scrollController,
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(
              left: horizontalPaddingWeb,
              right: horizontalPaddingWeb,
              top: 30,
            ),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                          height: 19.5 / 16,
                          letterSpacing: 0.12,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Text(
                        'Last updated: 06/09/2024',
                        style: descripcionStyle,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'At MoviesPlus, we respect and value the privacy of our users. This Privacy Policy outlines how we collect, use, and protect user information.',
                        style: descripcionStyle,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              left: horizontalPaddingWeb,
              right: horizontalPaddingWeb,
              bottom: 40,
            ),
            sliver: SliverList.separated(
              itemBuilder: (context, index) {
                final Policy policy = policies[index];
                return Center(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 500,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          policy.title,
                          style: subtitleStyle,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          policy.description,
                          style: descripcionStyle,
                        )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 20,
                );
              },
              itemCount: policies.length,
            ),
          )
        ],
      ),
    );
  }
}

class Policy {
  final String title;
  final String description;

  Policy({
    required this.title,
    required this.description,
  });
}

const subtitleStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: AppColors.white,
  height: 19.5 / 16,
  letterSpacing: 0.12,
  leadingDistribution: TextLeadingDistribution.even,
);

const descripcionStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: AppColors.textGrey,
  height: 17.07 / 14,
  letterSpacing: 0.12,
  leadingDistribution: TextLeadingDistribution.even,
);
