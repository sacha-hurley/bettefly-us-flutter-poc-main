import 'package:flutter/material.dart';
import 'package:bubble_ds/bubble_ds.dart';

class SecondaryPageNavBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;

  const SecondaryPageNavBar({super.key, required this.title, this.onBack});

  @override
  Widget build(BuildContext context) {
    // Outer container to provide height and background without changing inner structure
    return Container(
      color: BdsColors.backgroundSecondary,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 64,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // LEFT: Back area (fixed width 44) with exact nested structure preserved
                SizedBox(
                  width: 44,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onBack,
                    child: Semantics(
                      button: true,
                      label: 'Back',
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Column(
                                        children: [
                                          Column(
                                            children: [
                                              Container(width: 20, height: 20),
                                              Container(
                                                width: 7.949999809265137,
                                                height: 14.199999809265137,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Overlay actual chevron icon within the fixed left area
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 18,
                                  color: BdsColors.onSurfaceText,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // CENTER: Title (force perfect vertical centering)
                SizedBox(
                  height: double.infinity,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // RIGHT: Empty spacer matching left width (44) to maintain true centering
                Row(children: const [SizedBox(width: 44)]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
