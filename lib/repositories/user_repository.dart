import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../utils/constants.dart';

/// Repository for user operations
class UserRepository {
  final FirestoreService _firestoreService = FirestoreService();

  /// Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firestoreService.getDocument(
          AppConstants.usersCollection, userId);

      if (doc.exists) {
        return UserModel.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw 'Error fetching user: $e';
    }
  }

  /// Update user
  Future<void> updateUser(UserModel user) async {
    try {
      await _firestoreService.updateDocument(
        AppConstants.usersCollection,
        user.uid,
        user.copyWith().toFirestore(),
      );
    } catch (e) {
      throw 'Error updating user: $e';
    }
  }

  /// Add favorite product to user
  Future<void> addFavorite(String userId, String productId) async {
    try {
      final user = await getUserById(userId);
      if (user == null) throw 'User not found';
      
      if (!user.favorites.contains(productId)) {
        final updatedFavorites = [...user.favorites, productId];
        final updatedUser = user.copyWith(favorites: updatedFavorites);
        await updateUser(updatedUser);
      }
    } catch (e) {
      throw 'Error adding favorite: $e';
    }
  }

  /// Remove favorite product from user
  Future<void> removeFavorite(String userId, String productId) async {
    try {
      final user = await getUserById(userId);
      if (user == null) throw 'User not found';
      
      final updatedFavorites = user.favorites.where((id) => id != productId).toList();
      final updatedUser = user.copyWith(favorites: updatedFavorites);
      await updateUser(updatedUser);
    } catch (e) {
      throw 'Error removing favorite: $e';
    }
  }

  /// Get user favorites (product IDs)
  Future<List<String>> getUserFavorites(String userId) async {
    try {
      final user = await getUserById(userId);
      return user?.favorites ?? [];
    } catch (e) {
      throw 'Error fetching favorites: $e';
    }
  }

  /// Add address to user
  Future<void> addAddress(String userId, AddressModel address) async {
    try {
      final user = await getUserById(userId);
      if (user == null) throw 'User not found';
      
      final addresses = List<AddressModel>.from(user.addresses);
      
      // If this is set as default, unset other defaults
      if (address.isDefault) {
        for (int i = 0; i < addresses.length; i++) {
          if (addresses[i].isDefault) {
            addresses[i] = AddressModel(
              id: addresses[i].id,
              label: addresses[i].label,
              street: addresses[i].street,
              city: addresses[i].city,
              state: addresses[i].state,
              zipCode: addresses[i].zipCode,
              country: addresses[i].country,
              isDefault: false,
              coordinates: addresses[i].coordinates,
            );
          }
        }
      }
      
      addresses.add(address);
      final updatedUser = user.copyWith(addresses: addresses);
      await updateUser(updatedUser);
    } catch (e) {
      throw 'Error adding address: $e';
    }
  }

  /// Update address in user
  Future<void> updateAddress(String userId, AddressModel address) async {
    try {
      final user = await getUserById(userId);
      if (user == null) throw 'User not found';
      
      final addresses = user.addresses.map((addr) {
        if (addr.id == address.id) {
          return address;
        }
        // If this address is set as default, unset other defaults
        if (address.isDefault && addr.isDefault && addr.id != address.id) {
          return AddressModel(
            id: addr.id,
            label: addr.label,
            street: addr.street,
            city: addr.city,
            state: addr.state,
            zipCode: addr.zipCode,
            country: addr.country,
            isDefault: false,
            coordinates: addr.coordinates,
          );
        }
        return addr;
      }).toList();
      
      final updatedUser = user.copyWith(addresses: addresses);
      await updateUser(updatedUser);
    } catch (e) {
      throw 'Error updating address: $e';
    }
  }

  /// Delete address from user
  Future<void> deleteAddress(String userId, String addressId) async {
    try {
      final user = await getUserById(userId);
      if (user == null) throw 'User not found';
      
      final addresses = user.addresses.where((addr) => addr.id != addressId).toList();
      final updatedUser = user.copyWith(addresses: addresses);
      await updateUser(updatedUser);
    } catch (e) {
      throw 'Error deleting address: $e';
    }
  }

  /// Get all users (for admin)
  Future<List<UserModel>> getAllUsers() async {
    try {
      final snapshot = await _firestoreService
          .queryCollection(AppConstants.usersCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw 'Error fetching users: $e';
    }
  }

  /// Stream all users (for admin - real-time)
  Stream<List<UserModel>> streamAllUsers() {
    return _firestoreService
        .queryCollection(AppConstants.usersCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  /// Search users
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      final snapshot = await _firestoreService
          .queryCollection(AppConstants.usersCollection)
          .get();

      final allUsers = snapshot.docs
          .map((doc) => UserModel.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      final lowerQuery = query.toLowerCase();
      return allUsers.where((user) {
        return (user.name?.toLowerCase().contains(lowerQuery) ?? false) ||
            user.email.toLowerCase().contains(lowerQuery) ||
            (user.phone?.contains(query) ?? false);
      }).toList();
    } catch (e) {
      throw 'Error searching users: $e';
    }
  }
}

