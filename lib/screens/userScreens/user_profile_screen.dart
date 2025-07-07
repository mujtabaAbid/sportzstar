import 'package:flutter/material.dart';
import 'package:sportzstar/helper/page_navigate.dart';
import 'package:sportzstar/routing/routing_constrants.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String selectedSection = 'Profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const ProfileHeader(),
          const SizedBox(height: 8),
          MenuRow(
            selected: selectedSection,
            onSelect: (value) => setState(() => selectedSection = value),
          ),
          const Divider(),
          Expanded(
            child: _buildSectionContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContent() {
    switch (selectedSection) {
      case 'Profile':
        return const ProfileContent();
      case 'Timeline':
        return const Center(child: Text('Timeline Content'));
      case 'Videos':
        return const Center(child: Text('Videos Content'));
      default:
        return const SizedBox();
    }
  }
}

// -------------------- Header --------------------

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple, Colors.indigo],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
           Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: (){
                pushNamedNavigate(
                  context: context,
                  pageName: settingsScreenRoute,
                );
              }, // Add settings action here
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50),
                ),
                SizedBox(height: 8),
                Text('abcd', style: TextStyle(color: Colors.white, fontSize: 18)),
                Text('brave0333@gmail.com', style: TextStyle(color: Colors.white70)),
                Text('0 Followers', style: TextStyle(color: Colors.white54)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// -------------------- Menu Row --------------------

class MenuRow extends StatelessWidget {
  final String selected;
  final Function(String) onSelect;

  const MenuRow({super.key, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    List<String> sections = ['Profile', 'Timeline', 'Videos'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: sections.map((item) {
        final isSelected = selected == item;
        return GestureDetector(
          onTap: () => onSelect(item),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: isSelected
                ? const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.deepPurple, width: 2),
                    ),
                  )
                : null,
            child: Text(
              item,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// -------------------- Profile Content --------------------

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Player Info', showEdit: true),
          const SizedBox(height: 8),
          InfoBox(data: {
            'UserName': 'abcd',
            'Email': 'brave0333@gmail.com',
            'Gender': '-',
            'Age': 'null',
          }),
          const SizedBox(height: 16),
          const SectionHeader(title: 'Bio'),
          const PlaceholderBox(showMore: true),
          const SizedBox(height: 16),
          const SectionHeader(title: 'Players'),
          const PlaceholderBox(),
          const SizedBox(height: 16),
          const SectionHeader(title: 'Class Year'),
          const PlaceholderBox(),
          const SizedBox(height: 16),
          const SectionHeader(title: 'Social Media', showEdit: true),
          const PlaceholderBox(),
          const SizedBox(height: 24),
          const Divider(),
          const SectionHeader(title: 'Career History', showEdit: true, editText: 'Add History'),
          const SizedBox(height: 12),
          const Text('Medal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 24),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Add logout logic here
            },
          ),
        ],
      ),
    );
  }
}

// -------------------- Reusable Widgets --------------------

class SectionHeader extends StatelessWidget {
  final String title;
  final bool showEdit;
  final String editText;

  const SectionHeader({
    super.key,
    required this.title,
    this.showEdit = false,
    this.editText = 'Edit Profile',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        if (showEdit)
          Text(editText, style: const TextStyle(color: Colors.blue, fontSize: 13)),
      ],
    );
  }
}

class InfoBox extends StatelessWidget {
  final Map<String, String> data;

  const InfoBox({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data.entries
            .map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('${e.key}: ${e.value}'),
                ))
            .toList(),
      ),
    );
  }
}

class PlaceholderBox extends StatelessWidget {
  final bool showMore;

  const PlaceholderBox({super.key, this.showMore = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (showMore)
            const Text("see more", style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }
}
