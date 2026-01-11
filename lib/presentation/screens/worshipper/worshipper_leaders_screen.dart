import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../messaging/chat_screen.dart';

class WorshipperLeadersScreen extends StatefulWidget {
  const WorshipperLeadersScreen({super.key});

  @override
  State<WorshipperLeadersScreen> createState() =>
      _WorshipperLeadersScreenState();
}

class _WorshipperLeadersScreenState extends State<WorshipperLeadersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().loadLeaders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Religious Leaders'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${userProvider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      userProvider.loadLeaders();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (userProvider.leaders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No leaders found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await userProvider.loadLeaders();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: userProvider.leaders.length,
              itemBuilder: (context, index) {
                final leader = userProvider.leaders[index];
                return _LeaderListItem(leader: leader);
              },
            ),
          );
        },
      ),
    );
  }
}

class _LeaderListItem extends StatefulWidget {
  final dynamic leader;

  const _LeaderListItem({required this.leader});

  @override
  State<_LeaderListItem> createState() => _LeaderListItemState();
}

class _LeaderListItemState extends State<_LeaderListItem> {
  bool _isFollowing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkFollowingStatus();
  }

  Future<void> _checkFollowingStatus() async {
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.currentUser?.uid;
    if (userId != null) {
      final isFollowing = await context
          .read<UserProvider>()
          .isFollowing(userId, widget.leader.id);
      if (mounted) {
        setState(() {
          _isFollowing = isFollowing;
        });
      }
    }
  }

  Future<void> _toggleFollow() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.currentUser?.uid;
    if (userId != null) {
      final userProvider = context.read<UserProvider>();
      final success = _isFollowing
          ? await userProvider.unfollowUser(userId, widget.leader.id)
          : await userProvider.followUser(userId, widget.leader.id);

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (success) {
            _isFollowing = !_isFollowing;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: widget.leader.profileImageUrl != null
              ? CachedNetworkImageProvider(widget.leader.profileImageUrl!)
              : null,
          child: widget.leader.profileImageUrl == null
              ? Text(widget.leader.name.isNotEmpty
                  ? widget.leader.name[0].toUpperCase()
                  : 'L')
              : null,
        ),
        title: Text(
          widget.leader.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(widget.leader.email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              ElevatedButton(
                onPressed: _toggleFollow,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isFollowing ? Colors.grey : Theme.of(context).primaryColor,
                ),
                child: Text(_isFollowing ? 'Following' : 'Follow'),
              ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.message),
              onPressed: () {
                final authProvider = context.read<AuthProvider>();
                final userId = authProvider.currentUser?.uid;
                if (userId != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        currentUserId: userId,
                        otherUserId: widget.leader.id,
                        otherUserName: widget.leader.name,
                      ),
                    ),
                  );
                }
              },
              tooltip: 'Message',
            ),
          ],
        ),
      ),
    );
  }
}
