import 'package:archive_chats/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class ArchivedChatScreen extends StatefulWidget {
  final List<ChatUser> archivedChats;
  const ArchivedChatScreen({super.key, required this.archivedChats});

  @override
  State<ArchivedChatScreen> createState() => ArchivedChatScreenState();
}

class ArchivedChatScreenState extends State<ArchivedChatScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Iconsax.arrow_left_2, color: Colors.white),
          ),
        ),
      ),
      body:
          isLoading
              ? Center(child: CupertinoActivityIndicator(color: Colors.white))
              : ListView.builder(
                itemCount: widget.archivedChats.length,
                itemBuilder: (context, index) {
                  final user = widget.archivedChats[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.image),
                    ),
                    title: Text(
                      user.firstName,
                      style: GoogleFonts.sora(color: Colors.white),
                    ),
                    subtitle: Text(
                      user.phone,
                      style: GoogleFonts.sora(color: Colors.grey),
                    ),
                    trailing: Text(
                      '12:34 PM',
                      style: GoogleFonts.sora(color: Colors.grey),
                    ),
                  );
                },
              ),
    );
  }
}
