import 'package:flutter/material.dart';

class DialogsShowcase extends StatelessWidget {
  const DialogsShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dialogs & Sheets'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            context,
            'Dialogs',
            [
              FilledButton(
                onPressed: () => _showBasicDialog(context),
                child: const Text('Basic Dialog'),
              ),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => _showFullScreenDialog(context),
                child: const Text('Full Screen Dialog'),
              ),
            ],
          ),
          _buildSection(
            context,
            'Alert Dialogs',
            [
              FilledButton(
                onPressed: () => _showAlertDialog(context),
                child: const Text('Alert Dialog'),
              ),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => _showConfirmDialog(context),
                child: const Text('Confirmation Dialog'),
              ),
            ],
          ),
          _buildSection(
            context,
            'Bottom Sheets',
            [
              FilledButton(
                onPressed: () => _showBottomSheet(context),
                child: const Text('Bottom Sheet'),
              ),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => _showModalBottomSheet(context),
                child: const Text('Modal Bottom Sheet'),
              ),
            ],
          ),
          _buildSection(
            context,
            'Snackbars',
            [
              FilledButton(
                onPressed: () => _showSnackbar(context),
                child: const Text('Simple Snackbar'),
              ),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: () => _showActionSnackbar(context),
                child: const Text('Snackbar with Action'),
              ),
            ],
          ),
          _buildSection(
            context,
            'Banners',
            [
              FilledButton(
                onPressed: () => _showBanner(context),
                child: const Text('Material Banner'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showBasicDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Basic Dialog',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                const Text(
                  'This is a basic dialog with custom content.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFullScreenDialog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Full Screen Dialog'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Save'),
                ),
              ],
            ),
            body: const Center(
              child: Text('Full screen dialog content'),
            ),
          );
        },
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.warning),
          title: const Text('Alert'),
          content: const Text('This is an alert dialog with an icon.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Action'),
          content: const Text('Are you sure you want to proceed with this action?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    showBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Bottom Sheet',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              const Text('This is a persistent bottom sheet.'),
              const Spacer(),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Modal Bottom Sheet',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: const Icon(Icons.link),
                title: const Text('Get link'),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This is a simple snackbar'),
      ),
    );
  }

  void _showActionSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('This snackbar has an action'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Undo action triggered'),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showBanner(BuildContext context) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: const Text('This is a material banner with actions'),
        leading: const Icon(Icons.info),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text('Dismiss'),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text('Learn More'),
          ),
        ],
      ),
    );
  }
}