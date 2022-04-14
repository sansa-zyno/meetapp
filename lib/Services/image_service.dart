import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meeter/providers/user_controller.dart';
import 'package:meeter/Model/user.dart';
import 'package:meeter/Services/database.dart';

class ImageService {
  ImageService() {
    getUser();
  }
  late OurUser user;
  getUser() async {
    user = await UserController().getCurrentUserInfo();
  }

  Future<String> getImage() async {
    late String urlImage;
    try {
      ImagePicker imagePicker = ImagePicker();
      PickedFile? image = await imagePicker.getImage(
          source: ImageSource.gallery, imageQuality: 25);
      String fileName = '${DateTime.now().toString()}.png';

      if (image != null) {
        ///Saving Pdf to firebase
        Reference reference = FirebaseStorage.instance.ref().child(fileName);
        UploadTask uploadTask = reference.putData(await image.readAsBytes());
        urlImage = await (await uploadTask).ref.getDownloadURL();
      }
      return urlImage;
    } catch (e) {
      return e.toString();
    }
  }

  void setImageMsg(String url, String chatRoomId, String username) async {
    var lastMessageTs = DateTime.now();
    Map<String, dynamic> messageInfoMap = {
      "type": 'image',
      "read": false,
      "photoUrl": url,
      "sendBy": username,
      "ts": lastMessageTs,
    };

    Database().addMessage(chatRoomId, messageInfoMap).then((value) {
      Map<String, dynamic> lastMessageInfoMap = {
        "type": 'image',
        "read": false,
        "lastMessage": url,
        "lastMessageSendTs": lastMessageTs,
        "lastMessageSendBy": username,
        "lastMessageSendByImgUrl": user.avatarUrl
      };
      Database().updateLastMessageSend(chatRoomId, lastMessageInfoMap);
    });
  }

  void uploadImage(String chatRoomId, String username) async {
    String url = await getImage();
    setImageMsg(url, chatRoomId, username);
  }
}
