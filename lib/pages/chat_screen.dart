import 'package:archive_chats/models/chat_user.dart';
import 'package:archive_chats/pages/archived_chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:iconsax/iconsax.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  List<ChatUser> allUsers = [];
  List<ChatUser> archivedUsers = [];
  Set<int> selectedIds = {};
  bool isSelectedMode = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() => isLoading = true);
    final response = await http.get(Uri.parse('https://dummyjson.com/users'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['users'];
      setState(() {
        allUsers = data.map((e) => ChatUser.fromJson(e)).toList();
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  void toggleSelection(int id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }
      isSelectedMode = selectedIds.isNotEmpty;
    });
  }

  void archiveSelected() {
    setState(() {
      archivedUsers.addAll(
        allUsers.where((user) => selectedIds.contains(user.id)),
      );
      allUsers.removeWhere((user) => selectedIds.contains(user.id));
      selectedIds.clear();
      isSelectedMode = false;
    });
  }

  void unarchiveSelected() {
    setState(() {
      allUsers.addAll(
        archivedUsers.where((user) => selectedIds.contains(user.id)),
      );
      archivedUsers.removeWhere((user) => selectedIds.contains(user.id));
      selectedIds.clear();
      isSelectedMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          title: Text(
            isSelectedMode ? '${selectedIds.length} selected' : 'Chats',
            style: GoogleFonts.sora(
              color: Colors.white,
              fontSize: 16,
              fontWeight: isSelectedMode ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          actions: [
            if (isSelectedMode)
              IconButton(
                onPressed: archiveSelected,
                icon: Icon(Iconsax.archive_1, color: Colors.white),
              ),
          ],
        ),
      ),
      body:
          isLoading
              ? Center(child: CupertinoActivityIndicator(color: Colors.white))
              : Column(
                children: [
                  if (archivedUsers.isNotEmpty)
                    GestureDetector(
                      onTap: () async {
                        final updatedArchived = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ArchivedChatScreen(
                                  archivedChats: archivedUsers,
                                ),
                          ),
                        );

                        if (updatedArchived != null && mounted) {
                          setState(() {
                            archivedUsers = List<ChatUser>.from(
                              updatedArchived,
                            );
                          });
                        }
                      },

                      child: Container(
                        color: Colors.grey[200],
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(Iconsax.archive_1, size: 18),
                            SizedBox(width: 18),
                            Text("Archived", style: GoogleFonts.sora()),
                            Spacer(),
                            Text(
                              "${archivedUsers.length}",
                              style: GoogleFonts.sora(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: allUsers.length,
                      itemBuilder: (context, index) {
                        final user = allUsers[index];
                        final isSelected = selectedIds.contains(user.id);
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          color:
                              isSelected
                                  ? Colors.blue.withValues(alpha: 0.2)
                                  : null,
                          child: ListTile(
                            onLongPress: () => toggleSelection(user.id),
                            onTap: () {
                              if (isSelectedMode) toggleSelection(user.id);
                            },
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
                              "12:34 PM",
                              style: GoogleFonts.sora(color: Colors.grey),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
