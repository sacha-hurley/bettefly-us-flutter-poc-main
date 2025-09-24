import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bf_design_system/bf_design_system.dart';
import 'package:bubble_ds/bubble_ds.dart';

/// Simple debug version of top navigation to test components
class DebugTopNavigation extends StatelessWidget
    implements PreferredSizeWidget {
  const DebugTopNavigation({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    print('DebugTopNavigation: Building...');

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 1,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Simple avatar test
          GestureDetector(
            onTap: () {
              print('Avatar tapped!');
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Avatar tapped!')));
            },
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blue,
              child: Text(
                'JD',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Right side: Simple currency + buddy test
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Simple currency display
              GestureDetector(
                onTap: () {
                  print('Currency tapped!');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Currency tapped!')),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.flutter_dash, size: 20, color: Colors.orange),
                      SizedBox(width: 4),
                      Text(
                        '300',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Simple buddy icon
              GestureDetector(
                onTap: () {
                  print('Buddy tapped!');
                  // Test simple modal without BFModal
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          children: [
                            // Drag handle
                            Container(
                              width: 40,
                              height: 4,
                              margin: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),

                            // Header
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/IxBuddy.svg',
                                    height: 28,
                                    width: 28,
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Text(
                                      'Test Modal',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.close),
                                  ),
                                ],
                              ),
                            ),

                            // Content
                            const Expanded(
                              child: Center(
                                child: Text(
                                  'This should show only ONE header!',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: SvgPicture.asset(
                  'assets/icons/IxBuddy.svg',
                  height: 28,
                  width: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Test the BF components individually
class TestBFComponents extends StatelessWidget {
  const TestBFComponents({super.key});

  @override
  Widget build(BuildContext context) {
    print('TestBFComponents: Building...');

    return Scaffold(
      appBar: AppBar(title: const Text('BF Components Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Testing BF Design System Components:'),
            const SizedBox(height: 20),

            // Test BFAvatar
            const Text('BdsAvatar:'),
            const SizedBox(height: 8),
            BdsAvatar(
              initialsText: 'JD',
              size: BdsAvatarSize.m,
              onAvatarTap: () {
                print('BdsAvatar tapped!');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('BdsAvatar works!')),
                );
              },
            ),

            const SizedBox(height: 20),

            // Test BFCurrencyCounter
            const Text('BFCurrencyCounter:'),
            const SizedBox(height: 8),
            BFCurrencyCounter(
              amount: 300,
              onTap: () {
                print('BFCurrencyCounter tapped!');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('BFCurrencyCounter works!')),
                );
              },
            ),

            const SizedBox(height: 20),

            // Test modal
            const Text('BFModal:'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                showBFModal(
                  context: context,
                  title: 'Test Modal',
                  child: const BFModalContent(
                    child: Text('This is a test modal!'),
                  ),
                );
              },
              child: const Text('Show Test Modal'),
            ),
          ],
        ),
      ),
    );
  }
}
