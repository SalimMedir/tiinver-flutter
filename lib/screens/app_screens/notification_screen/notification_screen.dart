import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/constants/colors.dart';
import 'package:tiinver_project/widgets/header.dart';

import '../../../providers/notification/notification_provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<NotificationProvider>(context,listen: false).getNotification(context);
    return Scaffold(
      backgroundColor: bgColor,
      appBar: Header().header1("Notification",
          [],
          isCenterTitle: true,
          isIconShow: false),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          if (notificationProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (notificationProvider.error) {
            return Center(child: Text('Failed to load notifications'));
          } else if (notificationProvider.notifications.isEmpty) {
            return Center(child: Text('No notifications found'));
          } else {
            return ListView.builder(
              itemCount: notificationProvider.notifications.length,
              itemBuilder: (context, index) {
                final notification = notificationProvider.notifications[index];
                return ListTile(
                  title: Text(notification['title']), // Adjust according to your data structure
                  subtitle: Text(notification['body']), // Adjust according to your data structure
                );
              },
            );
          }
        },
      ),
    );
  }
}
//             FollowNotificationTile(),
//             SimpleNotificationTile(),
//             FollowNotificationTile(bgColor: lightGreyColor.withOpacity(0.3),),
//             SimpleNotificationTile(bgColor: lightGreyColor.withOpacity(0.3),),