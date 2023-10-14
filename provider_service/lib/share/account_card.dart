import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  const AccountCard(
      {super.key,
      required this.name,
      required this.imgPath,
      this.isEdit = false,
      this.onViewProfile, // <-- Added a callback function for "View profile" tap event
      this.onTakePicture});

  final String name;
  final String imgPath;
  final bool isEdit;
  final VoidCallback?
      onViewProfile; // <-- Added a callback function type for "View profile" tap event
  final VoidCallback? onTakePicture;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[50], // Background color
        borderRadius: BorderRadius.circular(10.0), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Centers vertically within the Row
          children: [
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: imgPath != ""
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(imgPath) // Use network image,
                            )
                        : const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                                'assets/images/anonymousUserImg.png'),
                          ),
                  ),
                ),
                // Display camera icon only when isEdit is true
                if (isEdit)
                  const Positioned(
                    top: 0,
                    right: 0,
                    child: Icon(Icons.camera_alt, color: Colors.blue),
                  ),
              ],
            ),
            const SizedBox(width: 20), // spacing between image and text
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Aligns text to the start (left)
                mainAxisAlignment: MainAxisAlignment
                    .center, // Centers vertically within the Column
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  // Display "View profile" text only when isEdit is false
                  if (!isEdit)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 8),
                      child: GestureDetector(
                        // <-- Wrapped with a GestureDetector to handle tap events
                        onTap:
                            onViewProfile, // <-- Assigning the passed function to the onTap handler
                        child: const Text(
                          "View profile",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
