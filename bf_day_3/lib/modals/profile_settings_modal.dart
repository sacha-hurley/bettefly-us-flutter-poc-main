import 'package:flutter/material.dart';

/// ProfileSettingsModal - Full-screen modal for user profile and settings
///
/// Features:
/// - Uses BFModal base component for consistent styling
/// - Displays user profile information
/// - Placeholder content for future settings implementation
/// - Follows bubble design system patterns
class ProfileSettingsModal extends StatelessWidget {
  /// User initials to display in the large avatar
  final String userInitials;

  /// User display name
  final String userName;

  /// User email address
  final String userEmail;

  const ProfileSettingsModal({
    super.key,
    this.userInitials = 'JD',
    this.userName = 'John Doe',
    this.userEmail = 'john.doe@company.com',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile section
        _buildProfileSection(context),

        const SizedBox(height: 32),

        // Settings placeholder
        _buildSettingsSection(context),

        // Spacer to push content up
        const Spacer(),
      ],
    );
  }

  /// Build the user profile section with avatar and info
  Widget _buildProfileSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Large avatar
        CircleAvatar(
          radius: 50,
          backgroundColor: theme.colorScheme.primary,
          child: Text(
            userInitials,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // User name
        Text(
          userName,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: 8),

        // User email
        Text(
          userEmail,
          style: TextStyle(
            fontSize: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// Build the settings section with placeholder content
  Widget _buildSettingsSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Settings placeholder text
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.settings,
                color: theme.colorScheme.onSurfaceVariant,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Profile settings and preferences will go here',
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Future settings items placeholder
        _buildSettingsItem(
          context,
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'Coming soon',
        ),

        const SizedBox(height: 12),

        _buildSettingsItem(
          context,
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy',
          subtitle: 'Coming soon',
        ),

        const SizedBox(height: 12),

        _buildSettingsItem(
          context,
          icon: Icons.help_outline,
          title: 'Help & Support',
          subtitle: 'Coming soon',
        ),
      ],
    );
  }

  /// Build a settings item row
  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.onSurfaceVariant, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: theme.colorScheme.onSurfaceVariant,
            size: 16,
          ),
        ],
      ),
    );
  }
}
