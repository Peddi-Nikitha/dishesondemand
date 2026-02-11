import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'dart:typed_data';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../providers/product_provider.dart';
import '../../models/product_model.dart';
import '../../services/storage_service.dart';
import '../../services/firestore_service.dart';
import '../../utils/constants.dart';

/// Add/Edit Product Screen for Super Admin
class AddEditProductScreen extends StatefulWidget {
  final ProductModel? product; // If null, it's add mode; if not null, it's edit mode

  const AddEditProductScreen({
    super.key,
    this.product,
  });

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _ratingController = TextEditingController();
  
  final StorageService _storageService = StorageService();
  final ImagePicker _imagePicker = ImagePicker();
  
  File? _selectedImage;
  Uint8List? _selectedImageBytes; // For web support
  String? _imageUrl;
  String _selectedCategory = 'Starters';
  bool _isVeg = false;
  bool _isNonVeg = false;
  bool _isAvailable = true;
  bool _isUploading = false;
  bool _isSaving = false;

  final List<String> _categories = [
    'Starters',
    'Breakfast',
    'Lunch',
    'Supp',
    'Desserts',
    'Beverages',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      // Edit mode - populate fields
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.currentPrice.toStringAsFixed(2);
      _originalPriceController.text = widget.product!.originalPrice?.toStringAsFixed(2) ?? '';
      _quantityController.text = widget.product!.quantity;
      _ratingController.text = widget.product!.rating.toStringAsFixed(1);
      _selectedCategory = widget.product!.category;
      _isVeg = widget.product!.isVeg;
      _isNonVeg = widget.product!.isNonVeg;
      _isAvailable = widget.product!.isAvailable;
      _imageUrl = widget.product!.imageUrl;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _originalPriceController.dispose();
    _quantityController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      
      if (image != null) {
        if (kIsWeb) {
          // For web, read bytes instead of using File
          final bytes = await image.readAsBytes();
          setState(() {
            _selectedImageBytes = bytes;
            _selectedImage = null; // Clear File reference on web
            _imageUrl = null; // Clear old URL when new image is selected
          });
        } else {
          // For mobile/desktop, use File
          setState(() {
            _selectedImage = File(image.path);
            _selectedImageBytes = null; // Clear bytes on mobile
            _imageUrl = null; // Clear old URL when new image is selected
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<String?> _uploadImage(String productId) async {
    if (kIsWeb) {
      if (_selectedImageBytes == null) {
        return _imageUrl; // Return existing URL if no new image
      }
    } else {
      if (_selectedImage == null) {
        return _imageUrl; // Return existing URL if no new image
      }
    }

    // Check if user is authenticated
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in to upload images'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return null;
    }

    try {
      setState(() {
        _isUploading = true;
      });

      String downloadUrl;
      if (kIsWeb) {
        // For web, we need to create a temporary file or use bytes directly
        // Since StorageService expects a File, we'll need to handle this differently
        // For now, we'll need to update StorageService to handle web, but as a workaround:
        // Create a temporary file path (this won't work on web, so we need to modify upload method)
        // Actually, let's check if we can pass bytes to the storage service
        downloadUrl = await _storageService.uploadProductImageBytes(
          _selectedImageBytes!,
          productId,
        );
      } else {
        downloadUrl = await _storageService.uploadProductImage(
          _selectedImage!,
          productId,
        );
      }

      setState(() {
        _isUploading = false;
      });

      return downloadUrl;
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      if (mounted) {
        final errorMessage = e.toString();
        final isCorsError = errorMessage.toLowerCase().contains('cors') || 
                           errorMessage.toLowerCase().contains('xmlhttprequest') ||
                           errorMessage.toLowerCase().contains('preflight');
        final isForbiddenError = errorMessage.toLowerCase().contains('403') ||
                                errorMessage.toLowerCase().contains('forbidden') ||
                                errorMessage.toLowerCase().contains('permission');
        
        if (isForbiddenError) {
          // Show dialog for 403 Forbidden error
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Permission Denied (403)'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Firebase Storage Security Rules are blocking the upload.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text('Quick Fix:'),
                    const SizedBox(height: 8),
                    const Text(
                      '1. Go to Firebase Console → Storage → Rules\n'
                      '2. Copy the rules from storage.rules file\n'
                      '3. Paste and Publish the rules\n'
                      '4. Make sure you are logged in as admin',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'See FIREBASE_STORAGE_RULES_SETUP.md for detailed instructions.',
                      style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else if (isCorsError) {
          // Show a dialog with CORS setup instructions
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('CORS Configuration Required'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Firebase Storage CORS needs to be configured for web uploads.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text('Quick Fix:'),
                    const SizedBox(height: 8),
                    const Text(
                      '1. Install Google Cloud SDK\n'
                      '2. Run: gcloud auth login\n'
                      '3. Run: gcloud config set project dishesondemandv2\n'
                      '4. Run: gsutil cors set cors.json gs://dishesondemandv2.firebasestorage.app',
                      style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Or use the setup script:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Windows: Double-click setup-cors.bat\n'
                      'Linux/Mac: Run ./setup-cors.sh',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'See FIREBASE_CORS_SETUP.md for detailed instructions.',
                      style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error uploading image: $errorMessage'),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
      return null;
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate that at least one of isVeg or isNonVeg is selected
    if (!_isVeg && !_isNonVeg) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one: Veg or Non-Veg'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final firestoreService = FirestoreService();

      String? finalImageUrl = _imageUrl;

      // If editing, use existing product ID; if adding, generate a temporary ID for image upload
      final productId = widget.product?.id ?? 
          firestoreService.instance
              .collection(AppConstants.productsCollection)
              .doc()
              .id;

      // Upload image if a new one was selected (check both mobile and web)
      if (_selectedImage != null || _selectedImageBytes != null) {
        finalImageUrl = await _uploadImage(productId);
        if (finalImageUrl == null) {
          setState(() {
            _isSaving = false;
          });
          return;
        }
      }

      // If no image URL (neither existing nor uploaded), show error
      if (finalImageUrl == null || finalImageUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a product image'),
            backgroundColor: AppColors.error,
          ),
        );
        setState(() {
          _isSaving = false;
        });
        return;
      }

      final product = ProductModel(
        id: widget.product?.id ?? productId,
        name: _nameController.text.trim(),
        category: _selectedCategory,
        imageUrl: finalImageUrl,
        quantity: _quantityController.text.trim(),
        currentPrice: double.parse(_priceController.text.trim()),
        originalPrice: _originalPriceController.text.trim().isNotEmpty
            ? double.parse(_originalPriceController.text.trim())
            : null,
        rating: double.parse(_ratingController.text.trim()),
        description: _descriptionController.text.trim(),
        isVeg: _isVeg,
        isNonVeg: _isNonVeg,
        isAvailable: _isAvailable,
        createdAt: widget.product?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      bool success;
      if (widget.product != null) {
        success = await productProvider.updateProduct(product);
      } else {
        success = await productProvider.createProduct(product);
      }

      setState(() {
        _isSaving = false;
      });

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.product != null
                  ? 'Product updated successfully'
                  : 'Product added successfully',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              productProvider.error ?? 'Failed to save product',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _deleteProduct() async {
    if (widget.product == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final success = await productProvider.deleteProduct(widget.product!.id);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product deleted successfully'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              productProvider.error ?? 'Failed to delete product',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        title: Text(
          widget.product != null ? 'Edit Product' : 'Add Product',
        ),
        actions: [
          if (widget.product != null)
            IconButton(
              icon: const Icon(Icons.delete),
              color: AppColors.error,
              onPressed: _deleteProduct,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Picker
              _buildImagePicker(),
              const SizedBox(height: AppTheme.spacingL),
              
              // Product Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppTheme.spacingM),
              
              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category *',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ),
              const SizedBox(height: AppTheme.spacingM),
              
              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: AppTheme.spacingM),
              
              // Price and Original Price Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Current Price *',
                        border: OutlineInputBorder(),
                        prefixText: '£ ',
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        if (double.tryParse(value.trim()) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: TextFormField(
                      controller: _originalPriceController,
                      decoration: const InputDecoration(
                        labelText: 'Original Price',
                        border: OutlineInputBorder(),
                        prefixText: '£ ',
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          if (double.tryParse(value.trim()) == null) {
                            return 'Invalid number';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingM),
              
              // Quantity and Rating Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity *',
                        border: OutlineInputBorder(),
                        hintText: 'e.g., 1 piece, 250g',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: TextFormField(
                      controller: _ratingController,
                      decoration: const InputDecoration(
                        labelText: 'Rating',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          final rating = double.tryParse(value.trim());
                          if (rating == null || rating < 0 || rating > 5) {
                            return '0-5 only';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingM),
              
              // Veg/Non-Veg Checkboxes
              Row(
                children: [
                  Checkbox(
                    value: _isVeg,
                    onChanged: (value) {
                      setState(() {
                        _isVeg = value ?? false;
                      });
                    },
                  ),
                  const Text('Vegetarian'),
                  const SizedBox(width: AppTheme.spacingL),
                  Checkbox(
                    value: _isNonVeg,
                    onChanged: (value) {
                      setState(() {
                        _isNonVeg = value ?? false;
                      });
                    },
                  ),
                  const Text('Non-Vegetarian'),
                ],
              ),
              const SizedBox(height: AppTheme.spacingM),
              
              // Available Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _isAvailable,
                    onChanged: (value) {
                      setState(() {
                        _isAvailable = value ?? true;
                      });
                    },
                  ),
                  const Text('Available'),
                ],
              ),
              const SizedBox(height: AppTheme.spacingL),
              
              // Save Button
              ElevatedButton(
                onPressed: (_isSaving || _isUploading) ? null : _saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
                ),
                child: (_isSaving || _isUploading)
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary),
                        ),
                      )
                    : Text(
                        widget.product != null ? 'Update Product' : 'Add Product',
                        style: AppTextStyles.buttonMedium,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Image *',
          style: AppTextStyles.labelLarge,
        ),
        const SizedBox(height: AppTheme.spacingS),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(
                color: ThemeHelper.getBorderColor(context),
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
            ),
            child: _isUploading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  )
                : (_selectedImage != null || _selectedImageBytes != null || (_imageUrl != null && _imageUrl!.isNotEmpty))
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppTheme.radiusM),
                            child: _selectedImageBytes != null
                                ? Image.memory(
                                    _selectedImageBytes!,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : _selectedImage != null
                                    ? Image.file(
                                        _selectedImage!,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            color: Colors.grey[300],
                                            child: const Center(
                                              child: Icon(
                                                Icons.broken_image,
                                                size: 50,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                : (_imageUrl != null && _imageUrl!.isNotEmpty
                                    ? Image.network(
                                        _imageUrl!,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            color: Colors.grey[300],
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress.expectedTotalBytes != null
                                                    ? loadingProgress.cumulativeBytesLoaded /
                                                        loadingProgress.expectedTotalBytes!
                                                    : null,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            color: Colors.grey[300],
                                            child: const Center(
                                              child: Icon(
                                                Icons.broken_image,
                                                size: 50,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      )),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: AppColors.textOnPrimary,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 50,
                              color: ThemeHelper.getTextSecondaryColor(context),
                            ),
                            const SizedBox(height: AppTheme.spacingS),
                            Text(
                              'Tap to add image',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: ThemeHelper.getTextSecondaryColor(context),
                              ),
                            ),
                          ],
                        ),
                      ),
          ),
        ),
      ],
    );
  }
}

