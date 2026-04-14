import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view_models/auth_view_model.dart';
import '../models/user.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  final AuthViewModel viewModel;

  const ProfileScreen({super.key, required this.viewModel});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _biometricsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final user = widget.viewModel.user;
        return Scaffold(
          backgroundColor: Colors.white,
          body:
              user == null
                  ? _buildSignedOutView(context)
                  : _buildSignedInView(context, user),
        );
      },
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Sign Out?'),
            content: const Text(
              'Are you sure you want to sign out of The Dash Shop?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  widget.viewModel.signOut();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildSignedOutView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Dash Shop',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed:
                () => widget.viewModel.signIn('Dash User', 'dash@example.com'),
            style: ElevatedButton.styleFrom(minimumSize: const Size(200, 48)),
            child: const Text('Sign In to Account'),
          ),
        ],
      ),
    );
  }

  Widget _buildSignedInView(BuildContext context, User user) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          pinned: true,
          expandedHeight: 120,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            titlePadding: const EdgeInsetsDirectional.only(
              start: 24,
              bottom: 12,
            ),
            title: Text(
              'Profile',
              style: GoogleFonts.playfairDisplay(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.black, size: 20),
              onPressed: () => _confirmSignOut(context),
            ),
            const SizedBox(width: 8),
          ],
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                user.name,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              _buildProfileAvatar(context),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatItem(
                    context,
                    'Orders',
                    '12',
                    () => _showOrders(context),
                  ),
                  const SizedBox(width: 48),
                  _buildStatItem(
                    context,
                    'Points',
                    '${user.dashPoints}',
                    () => _showPoints(context),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              _buildActionList(context, primaryColor),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileAvatar(BuildContext context) {
    return InkWell(
      onTap: () => _updateAvatar(context),
      borderRadius: BorderRadius.circular(75),
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: const DecorationImage(
            image: AssetImage('assets/images/dash.png'),
            fit: BoxFit.cover,
          ),
          border: Border.all(color: Colors.grey.shade100, width: 1),
        ),
      ),
    );
  }

  void _updateAvatar(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Photo Library'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrders(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Recent Orders',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, i) => ListTile(
                  leading: const Icon(Icons.shopping_bag),
                  title: Text('Order #D-10${5 - i}'),
                  subtitle: const Text('Status: Delivered'),
                  trailing: const Text('\$45.00'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPoints(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dash Rewards'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.stars, size: 60, color: Colors.amber),
            SizedBox(height: 16),
            Text(
              'You have 750 Dash Points!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Keep shopping to earn more rewards.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Great!'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionList(BuildContext context, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActionTile(
            context,
            title: 'Notifications',
            subtitle: 'Push notifications',
            trailing: Switch(
              value: _notificationsEnabled,
              activeTrackColor: const Color(0xFF4CD964),
              onChanged: (v) => setState(() => _notificationsEnabled = v),
            ),
          ),
          _buildActionTile(
            context,
            title: 'Security',
            subtitle: 'Biometric Login',
            trailing: Switch(
              value: _biometricsEnabled,
              activeTrackColor: const Color(0xFF4CD964),
              onChanged: (v) => setState(() => _biometricsEnabled = v),
            ),
          ),
          _buildActionTile(
            context,
            title: 'Support',
            subtitle: 'flutter.dev',
            onTap: () => _launchURL('https://flutter.dev'),
          ),
          _buildActionTile(
            context,
            title: 'Birthdate',
            subtitle: 'October 15, 1995',
            onTap: () => _selectDate(context),
          ),
          _buildActionTile(
            context,
            title: 'Location',
            subtitle: 'San Francisco, CA',
            onTap: () => _selectLocation(context),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _selectDate(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: DateTime(1995, 10, 15),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
  }

  void _selectLocation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('San Francisco, California, USA'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (trailing != null)
              trailing
            else
              const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
