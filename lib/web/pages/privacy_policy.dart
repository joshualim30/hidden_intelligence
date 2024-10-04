// privacy_poilcy.dart
// Privacy Policy Page

/*
Effective Date: [Insert Date]
Hidden Intelligence ("we," "us," or "our") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and share information about you when you use our mobile application, Hidden Intelligence (the "App"), and your rights concerning that information. By using our App, you agree to the collection and use of information in accordance with this Privacy Policy.

1. Information We Collect
We may collect the following types of information:

a. Personal Information
Personal information is data that can be used to identify or contact you. The App may collect personal information when you:

Create an account (e.g., name, email address)
Contact us for support (e.g., email address, phone number)
Participate in in-app purchases (e.g., payment information)
b. Non-Personal Information
We may also collect non-personal information, which does not directly identify you. This may include:

Device information (e.g., model, operating system, device identifiers)
Usage data (e.g., how you use the App, in-game activities, preferences)
Game interaction data (e.g., scores, responses to prompts)
2. How We Use Your Information
We use your information for the following purposes:

To provide and maintain the App
To personalize your gaming experience
To process in-app purchases
To send updates, notifications, or promotional materials (with your consent)
To improve and develop new features or services
To comply with legal obligations or enforce our terms
3. Sharing Your Information
We do not sell your personal information. However, we may share your information in the following ways:

Service Providers: We may share your information with third-party service providers who assist us in operating the App, processing payments, or providing analytics.
Legal Requirements: We may disclose your information if required to do so by law, in response to valid requests by public authorities, or to protect our rights or property.
Business Transfers: In the event of a merger, acquisition, or sale of assets, your information may be transferred as part of the transaction.
4. Your Choices
You have the following rights regarding your information:

Access: You can request access to your personal information.
Correction: You can request that we correct any inaccuracies in your personal information.
Deletion: You can request the deletion of your personal information, subject to certain legal obligations.
Opt-Out: You may opt-out of receiving promotional communications by following the instructions provided in those communications or by contacting us.
5. Data Retention
We will retain your information for as long as necessary to fulfill the purposes outlined in this Privacy Policy, or as required by law. When your information is no longer needed, we will securely delete or anonymize it.

6. Security
We take reasonable measures to protect your information from unauthorized access, use, or disclosure. However, no data transmission over the internet or method of electronic storage is entirely secure. We cannot guarantee absolute security.

7. Children's Privacy
The App is not intended for use by individuals under the age of 13. We do not knowingly collect personal information from children under 13. If we become aware that we have collected such information without verification of parental consent, we will delete it as quickly as possible.

8. International Transfers
Your information may be transferred to, and maintained on, servers located outside of your state, province, country, or other governmental jurisdiction, where the data protection laws may differ from those in your jurisdiction. By using the App, you consent to such transfers.

9. Changes to this Privacy Policy
We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy in the App. You are advised to review this Privacy Policy periodically for any updates. Changes to this Privacy Policy are effective when they are posted.

10. Contact Us
If you have any questions about this Privacy Policy or wish to exercise any of your rights, please contact us at:

Hidden Intelligence
[Insert Address]
Email: [Insert Contact Email]
*/

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: SingleChildScrollView(
            child: ListView(
              shrinkWrap: true,
              children: const <Widget>[
                // MARK: Title (Hidden Intelligence)
                Text(
                  'Hidden Intelligence',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            
                // MARK: Subtitle (A Game with Trust Issues!)
                Text(
                  'A Game with Trust Issues!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
            
                // Spacer
                Spacer(),
            
                // MARK: Privacy Policy
                SizedBox(
                  width: 700,
                  child: Text(
                    'Effective Date: October 3rd, 2024\n'
                    'Hidden Intelligence ("we," "us," or "our") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and share information about you when you use our mobile application, Hidden Intelligence (the "App"), and your rights concerning that information. By using our App, you agree to the collection and use of information in accordance with this Privacy Policy.\n\n'
                    '1. Information We Collect\n'
                    'We may collect the following types of information:\n\n'
                    'a. Personal Information\n'
                    'Personal information is data that can be used to identify or contact you. The App may collect personal information when you:\n\n'
                    'Create an account (e.g., name, email address)\n'
                    'Contact us for support (e.g., email address, phone number)\n'
                    'Participate in in-app purchases (e.g., payment information)\n\n'
                    'b. Non-Personal Information\n'
                    'We may also collect non-personal information, which does not directly identify you. This may include:\n\n'
                    'Device information (e.g., model, operating system, device identifiers)\n'
                    'Usage data (e.g., how you use the App, in-game activities, preferences)\n'
                    'Game interaction data (e.g., scores, responses to prompts)\n\n'
                    '2. How We Use Your Information\n'
                    'We use your information for the following purposes:\n\n'
                    'To provide and maintain the App\n'
                    'To personalize your gaming experience\n'
                    'To process in-app purchases\n'
                    'To send updates, notifications, or promotional materials (with your consent)\n'
                    'To improve and develop new features or services\n'
                    'To comply with legal obligations or enforce our terms\n\n'
                    '3. Sharing Your Information\n'
                    'We do not sell your personal information. However, we may share your information in the following ways:\n\n'
                    'Service Providers: We may share your information with third-party service providers who assist us in operating the App, processing payments, or providing analytics.\n'
                    'Legal Requirements: We may disclose your information if required to do so by law, in response to valid requests by public authorities, or to protect our rights or property.\n'
                    'Business Transfers: In the event of a merger, acquisition, or sale of assets, your information may be transferred as part of the transaction.\n\n'
                    '4. Your Choices\n'
                    'You have the following rights regarding your information:\n\n'
                    'Access: You can request access to your personal information.\n'
                    'Correction: You can request that we correct any inaccuracies in your personal information.\n'
                    'Deletion: You can request the deletion of your personal information, subject to certain legal obligations.\n'
                    'Opt-Out: You may opt-out of receiving promotional communications by following the instructions provided in those communications or by contacting us.\n\n'
                    '5. Data Retention\n'
                    'We will retain your information for as long as necessary to fulfill the purposes outlined in this Privacy Policy, or as required by law. When your information is no longer needed, we will securely delete or anonymize it.\n\n'
                    '6. Security\n'
                    'We take reasonable measures to protect your information from unauthorized access, use, or disclosure. However, no data transmission over the internet or method of electronic storage is entirely secure. We cannot guarantee absolute security.\n\n'
                    '7. Children\'s Privacy\n'
                    'The App is not intended for use by individuals under the age of 13. We do not knowingly collect personal information from children under 13. If we become aware that we have collected such information without verification of parental consent, we will delete it as quickly as possible.\n\n'
                    '8. International Transfers\n'
                    'Your information may be transferred to, and maintained on, servers located outside of your state, province, country, or other governmental jurisdiction, where the data protection laws may differ from those in your jurisdiction. By using the App, you consent to such transfers.\n\n'
                    '9. Changes to this Privacy Policy\n'
                    'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy in the App. You are advised to review this Privacy Policy periodically for any updates. Changes to this Privacy Policy are effective when they are posted.\n\n'
                    '10. Contact Us\n'
                    'If you have any questions about this Privacy Policy or wish to exercise any of your rights, please contact us at:\n\n'
                    'Hidden Intelligence\n'
                    'Email: joshualim3612@gmail.com\n\n\n',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}