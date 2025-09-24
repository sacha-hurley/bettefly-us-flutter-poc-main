import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bf_design_system/bf_design_system.dart';

/// BuddyChatModal - Full-screen modal for AI Health Assistant chat
///
/// Features:
/// - Uses BFModal base component for consistent styling
/// - Placeholder for future AI chat implementation
/// - Health buddy branding and icons
/// - Follows bubble design system patterns
class BuddyChatModal extends StatelessWidget {
  /// Custom buddy icon (defaults to sentiment_very_satisfied)
  final IconData buddyIcon;

  /// Buddy name/title
  final String buddyName;

  const BuddyChatModal({
    super.key,
    this.buddyIcon = Icons.sentiment_very_satisfied,
    this.buddyName = 'Health Buddy',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Buddy introduction section
        _buildBuddyIntro(context),

        const SizedBox(height: 32),

        // Chat placeholder section
        _buildChatPlaceholder(context),

        // Spacer to push content up
        const Spacer(),

        // Future chat input area
        _buildChatInputPlaceholder(context),
      ],
    );
  }

  /// Build the buddy introduction section
  Widget _buildBuddyIntro(BuildContext context) {
    final colors = Theme.of(context).extension<BFColors>() ?? BFColors.light;

    return Column(
      children: [
        // Large buddy icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: colors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Icon(buddyIcon, size: 40, color: colors.primary),
        ),

        const SizedBox(height: 24),

        // Buddy title
        Text(
          'AI Health Assistant',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),

        const SizedBox(height: 8),

        // Buddy description
        Text(
          'Your personal wellness companion',
          style: TextStyle(fontSize: 16, color: colors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build the chat placeholder section
  Widget _buildChatPlaceholder(BuildContext context) {
    final colors = Theme.of(context).extension<BFColors>() ?? BFColors.light;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.background.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.textSecondary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.chat_bubble_outline,
            color: colors.textSecondary,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Chat Interface Coming Soon',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your AI health buddy will help you with wellness tips, answer questions, and provide personalized guidance.',
            style: TextStyle(fontSize: 14, color: colors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Sample chat features
          _buildFeatureItem(
            context,
            icon: Icons.psychology,
            text: 'Personalized health insights',
          ),
          const SizedBox(height: 8),
          _buildFeatureItem(
            context,
            icon: Icons.fitness_center,
            text: 'Workout recommendations',
          ),
          const SizedBox(height: 8),
          _buildFeatureItem(
            context,
            icon: Icons.restaurant_menu,
            text: 'Nutrition guidance',
          ),
        ],
      ),
    );
  }

  /// Build a feature item
  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    final colors = Theme.of(context).extension<BFColors>() ?? BFColors.light;

    return Row(
      children: [
        Icon(icon, color: colors.primary, size: 16),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
      ],
    );
  }

  /// Build the chat input placeholder
  Widget _buildChatInputPlaceholder(BuildContext context) {
    final colors = Theme.of(context).extension<BFColors>() ?? BFColors.light;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.textSecondary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colors.background.withOpacity(0.5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                'Type your message...',
                style: TextStyle(fontSize: 14, color: colors.textSecondary),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.textSecondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.send, color: colors.textSecondary, size: 20),
          ),
        ],
      ),
    );
  }
}
