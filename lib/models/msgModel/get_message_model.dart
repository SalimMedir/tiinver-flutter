// class GetMessageModel {
//   bool? error;
//   String? message;
//   List<Data>? data;
//
//   GetMessageModel({this.error, this.message, this.data});
//
//   GetMessageModel.fromJson(Map<String, dynamic> json) {
//     error = json['error'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['error'] = this.error;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Data {
//   String? messageId;
//   String? conversationId;
//   String? type;
//   String? to;
//   String? sender;
//   String? receiver;
//   String? from;
//   String? nikname;
//   String? message;
//   String? verb;
//   String? object;
//   String? profile;
//   String? status;
//   String? stamp;
//   String? resource;
//   String? isQuoted;
//
//   Data(
//       {this.messageId,
//         this.conversationId,
//         this.type,
//         this.to,
//         this.sender,
//         this.receiver,
//         this.from,
//         this.nikname,
//         this.message,
//         this.verb,
//         this.object,
//         this.profile,
//         this.status,
//         this.stamp,
//         this.resource,
//         this.isQuoted});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     messageId = json['messageId'];
//     conversationId = json['conversationId'];
//     type = json['type'];
//     to = json['to'];
//     sender = json['sender'];
//     receiver = json['receiver'];
//     from = json['from'];
//     nikname = json['nikname'];
//     message = json['message'];
//     verb = json['verb'];
//     object = json['object'];
//     profile = json['profile'];
//     status = json['status'];
//     stamp = json['stamp'];
//     resource = json['resource'];
//     isQuoted = json['isQuoted'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['messageId'] = this.messageId;
//     data['conversationId'] = this.conversationId;
//     data['type'] = this.type;
//     data['to'] = this.to;
//     data['sender'] = this.sender;
//     data['receiver'] = this.receiver;
//     data['from'] = this.from;
//     data['nikname'] = this.nikname;
//     data['message'] = this.message;
//     data['verb'] = this.verb;
//     data['object'] = this.object;
//     data['profile'] = this.profile;
//     data['status'] = this.status;
//     data['stamp'] = this.stamp;
//     data['resource'] = this.resource;
//     data['isQuoted'] = this.isQuoted;
//     return data;
//   }
// }
class GetMessageModel {
  bool? error;
  String? message;
  List<Data>? data;

  GetMessageModel({this.error, this.message, this.data});

  GetMessageModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? messageId;
  String? conversationId;
  String? type;
  String? to;
  String? sender;
  String? receiver;
  String? from;
  String? nikname;
  String? message;
  String? verb;
  String? object;
  String? profile;
  String? status;
  String? stamp;
  String? resource;
  String? isQuoted;

  Data(
      {this.messageId,
        this.conversationId,
        this.type,
        this.to,
        this.sender,
        this.receiver,
        this.from,
        this.nikname,
        this.message,
        this.verb,
        this.object,
        this.profile,
        this.status,
        this.stamp,
        this.resource,
        this.isQuoted});

  Data.fromJson(Map<String, dynamic> json) {
    messageId = json['messageId'];
    conversationId = json['conversationId'];
    type = json['type'];
    to = json['to'];
    sender = json['sender'];
    receiver = json['receiver'];
    from = json['from'];
    nikname = json['nikname'];
    message = json['message'];
    verb = json['verb'];
    object = json['object'];
    profile = json['profile'];
    status = json['status'];
    stamp = json['stamp'];
    resource = json['resource'];
    isQuoted = json['isQuoted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messageId'] = this.messageId;
    data['conversationId'] = this.conversationId;
    data['type'] = this.type;
    data['to'] = this.to;
    data['sender'] = this.sender;
    data['receiver'] = this.receiver;
    data['from'] = this.from;
    data['nikname'] = this.nikname;
    data['message'] = this.message;
    data['verb'] = this.verb;
    data['object'] = this.object;
    data['profile'] = this.profile;
    data['status'] = this.status;
    data['stamp'] = this.stamp;
    data['resource'] = this.resource;
    data['isQuoted'] = this.isQuoted;
    return data;
  }
}