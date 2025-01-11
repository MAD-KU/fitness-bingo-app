import 'package:application/controllers/user_controller.dart';
import 'package:application/models/user_model.dart';
import 'package:application/screens/admin/manage_user/user_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({Key? key}) : super(key: key);

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSorted = false;
  bool _isLoadingMore = false;
  List<UserModel> _originalUsers = [];

  @override
  void initState() {
    super.initState();
    final userController = Provider.of<UserController>(context, listen: false);
    userController.resetPagination();
    userController.fetchUsersWithPagination().then((_) {
      setState(() {
        _originalUsers = List.from(userController.users);
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _sortUsers(UserController userController) {
    if (_isSorted) {
      userController.sortUsersByName();
    } else {
      userController.setUsers(List.from(_originalUsers));
    }
  }

  Future<void> _loadMoreUsers(UserController userController) async {
    if (_isLoadingMore || !userController.hasMoreUsers) return;

    setState(() {
      _isLoadingMore = true;
    });

    await userController.fetchUsersWithPagination();

    setState(() {
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black54,
              Colors.grey[900]!,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<UserController>(
            builder: (context, userController, child) {
              if (userController.isLoading && userController.users.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (userController.errorMessage.isNotEmpty) {
                return Center(child: Text(userController.errorMessage));
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      decoration: InputDecoration(
                        labelText: 'Search Users',
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                        suffixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).primaryColor,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onChanged: (value) {
                        // Reset sorting when the search query changes
                        if (_isSorted) {
                          setState(() {
                            _isSorted = false;
                          });
                        }
                        // Call searchUsers on every change in the text field
                        userController.searchUsers(value);
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isSorted = !_isSorted;
                          });
                          _sortUsers(userController);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(_isSorted ? 'Unsort' : 'Sort A-Z'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (!_isSorted &&
                            scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent) {
                          _loadMoreUsers(userController);
                        }
                        return false;
                      },
                      child: ListView.builder(
                        itemCount: userController.users.length +
                            (_isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < userController.users.length) {
                            final user = userController.users[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'assets/images/profile.png'), // Hardcoded image
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                title: Text(
                                  user.name ?? 'No Name',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  user.email ?? 'No Email',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.8),
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserDetailsScreen(
                                        userId: user.id!,
                                      ),
                                    ),
                                  );
                                },
                                tileColor: Colors.grey[800],
                              ),
                            );
                          } else {
                            return _isLoadingMore
                                ? const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
