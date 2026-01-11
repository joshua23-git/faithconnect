import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/post_provider.dart';
import '../../widgets/post_card.dart';
import 'worshipper_leaders_screen.dart';
import 'worshipper_profile_screen.dart';

class WorshipperHomeScreen extends StatefulWidget {
  const WorshipperHomeScreen({super.key});

  @override
  State<WorshipperHomeScreen> createState() => _WorshipperHomeScreenState();
}

class _WorshipperHomeScreenState extends State<WorshipperHomeScreen> {
  int _currentIndex = 0;
  late final PostProvider _postProvider;

  @override
  void initState() {
    super.initState();
    _postProvider = context.read<PostProvider>();
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.currentUser?.uid;
    if (userId != null) {
      _postProvider.loadFollowingPosts(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _HomeFeedTab(),
          WorshipperLeadersScreen(),
          WorshipperProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outlined),
            selectedIcon: Icon(Icons.people),
            label: 'Leaders',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _HomeFeedTab extends StatelessWidget {
  const _HomeFeedTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FaithConnect'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final authProvider = context.read<AuthProvider>();
              final userId = authProvider.currentUser?.uid;
              if (userId != null) {
                context.read<PostProvider>().loadFollowingPosts(userId);
              }
            },
          ),
        ],
      ),
      body: Consumer<PostProvider>(
        builder: (context, postProvider, _) {
          if (postProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (postProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${postProvider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final authProvider = context.read<AuthProvider>();
                      final userId = authProvider.currentUser?.uid;
                      if (userId != null) {
                        postProvider.loadFollowingPosts(userId);
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (postProvider.posts.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.feed_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No posts yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Follow leaders to see their posts here',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              final authProvider = context.read<AuthProvider>();
              final userId = authProvider.currentUser?.uid;
              if (userId != null) {
                postProvider.loadFollowingPosts(userId);
              }
            },
            child: ListView.builder(
              itemCount: postProvider.posts.length,
              itemBuilder: (context, index) {
                final post = postProvider.posts[index];
                return PostCard(post: post);
              },
            ),
          );
        },
      ),
    );
  }
}
