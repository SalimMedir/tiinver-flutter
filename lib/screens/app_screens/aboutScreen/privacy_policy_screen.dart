import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/constants/text_widget.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: bgColor,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        children: const [
          Heading1(text: "Privacy Policy"),
          Heading2(text: "Salim Medir built the Tiinver app as a Free app."
              " This SERVICE is provided by Salim Medir at no cost and is"
              " intended for use as is.\n\nThis page is used to inform visitors"
              " regarding my policies with the collection, use, and disclosure"
              " of Personal Information if anyone decided to use my Service.\n\n"
              "If you choose to use my Service, then you agree to the collection"
              " and use of information in relation to this policy. The Personal"
              " Information that I collect is used for providing and improving "
              "the Service. I will not use or share your information with anyone"
              " except as described in this Privacy Policy\n\n.The terms used in this"
              " Privacy Policy have the same meanings as in our Terms and Conditions,"
              " which is accessible at Tiinver unless otherwise defined in this Privacy Policy."),
          Heading1(text: "Information Collection and Use"),
          Heading2(
              text: "For a better experience, while using our Service,"
                  " I may require you to provide us with certain personally "
                  "identifiable information, including but not limited to "
                  "name, phone, email, age, location. The information that "
                  "I request will be retained on your device and is not collected"
                  " by me in any way\n\n.The app does use third party services that may"
                  " collect information used to identify you.\n\nLink to privacy policy of"
                  " third party service providers used by the app"),
          Heading1(text: "Log Data"),
          Heading2(
              text: "I want to inform you that whenever you use my Service,"
                  " in a case of an error in the app I collect data and information"
                  " (through third party products) on your phone called Log Data. "
                  "This Log Data may include information such as your device Internet "
                  "Protocol (“IP”) address, device name, operating system version, the"
                  " configuration of the app when utilizing my Service, the time and date"
                  " of your use of the Service, and other statistics."),
          Heading1(text: "Cookies"),
          Heading2(
              text: "Cookies are files with a small amount of data that"
                  " are commonly used as anonymous unique identifiers. "
                  "These are sent to your browser from the websites that "
                  "you visit and are stored on your device's internal memory.\n\n"
                  "This Service does not use these “cookies” explicitly."
                  " However, the app may use third party code and libraries "
                  "that use “cookies” to collect information and improve their"
                  " services. You have the option to either accept or refuse "
                  "these cookies and know when a cookie is being sent to your device."
                  " If you choose to refuse our cookies, you may not be able to use"
                  " some portions of this Service."),
          Heading1(text: "Service Providers"),
          Heading2(
              text: "I may employ third-party companies and "
                  "individuals due to the following reasons:\n\n"
                  ".To facilitate our Service;\n"
                  ".To provide Service on our behalf;\n"
                  ".To perform Service-related services; or \n"
                  ".To assist us in analyzing how our Service is used.\n\n"
                  "I want to inform users of this Service that these third"
                  " parties have access to your Personal Information. The"
                  " reason is to perform the tasks assigned to them on our"
                  " behalf. However, they are obligated not to disclose or"
                  " use the information for any other purpose."),
          Heading1(text: "Security"),
          Heading2(
              text: "I value your trust in providing us your Personal"
                  " Information, thus we are striving to use commercially"
                  " acceptable means of protecting it. But remember that no "
                  "method of transmission over the internet, or method of"
                  " electronic storage is 100% secure and reliable, and I "
                  "cannot guarantee its absolute security."),
          Heading1(text: "Links to Others Sites"),
          Heading2(
              text: "This Service may contain links to other sites."
                  " If you click on a third-party link, you will be"
                  " directed to that site. Note that these external"
                  " sites are not operated by me. Therefore, I strongly "
                  "advise you to review the Privacy Policy of these websites."
                  " I have no control over and assume no responsibility for"
                  " the content, privacy policies, or practices of any third-party"
                  " sites or services."),
          Heading1(text: "Children's Privacy"),
          Heading2(
              text: "These Services do not address anyone under the"
                  " age of 13. I do not knowingly collect personally"
                  " identifiable information from children under 13 "
                  "years of age. In the case I discover that a child "
                  "under 13 has provided me with personal information,"
                  " I immediately delete this from our servers. If you"
                  " are a parent or guardian and you are aware that your "
                  "child has provided us with personal information, please"
                  " contact me so that I will be able to do necessary actions."),
          Heading1(text: "Changes to this Privacy Policy"),
          Heading2(
              text: "I may update our Privacy Policy from time to time."
                  " Thus, you are advised to review this page periodically"
                  " for any changes. I will notify you of any changes by "
                  "posting the new Privacy Policy on this page.\n\n"
                  "This policy is effective as of 2021-11-16"),
          Heading1(text: "Contact Us"),
          Heading2(
              text: "If you have any questions or suggestions"
                  " about my Privacy Policy, do not hesitate to"
                  " contact me at salimmedirsm@gmail.com."),
        ],
      ),
    );
  }
}

class Heading1 extends StatelessWidget {
  const Heading1({super.key,required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextWidget1(
          text: text,
          fontSize: 16.dp,
          fontWeight: FontWeight.bold,
          isTextCenter: false,
          textColor: textColor
      ),
    );
  }
}

class Heading2 extends StatelessWidget {
  const Heading2({super.key,required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return TextWidget1(
        text: text,
        fontSize: 12.dp,
        fontWeight: FontWeight.bold,
        isTextCenter: false,
        textColor: textColor,
      maxLines: null,
    );
  }
}
