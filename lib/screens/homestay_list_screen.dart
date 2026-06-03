import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/homestay.dart';
import 'homestay_detail_screen.dart';

class HomestayListScreen extends StatefulWidget {
  const HomestayListScreen({super.key});

  @override
  State<HomestayListScreen> createState() => _HomestayListScreenState();
}

class _HomestayListScreenState extends State<HomestayListScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  List<HomestayModel> _homestays = [];
  bool _isLoading = false;
  String _errorMessage = '';
  
  String _selectedState = 'All';
  final List<String> _malaysianStates = [
    'All', 'Kedah', 'Penang', 'Perak', 'Selangor', 'Melaka', 'Johor', 
    'Pahang', 'Terengganu', 'Kelantan', 'Sabah', 'Sarawak', 'Kuala Lumpur'
  ];

  @override
  void initState() {
    super.initState();
    _fetchHomestays();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchHomestays() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    String urlString = 'http://slum78.myddns.me/homestay2u/api/homestays?limit=30';
    
    if (_searchController.text.trim().isNotEmpty) {
      urlString += '&search=${Uri.encodeComponent(_searchController.text.trim())}';
    }
    
    if (_selectedState != 'All') {
      urlString += '&state=${Uri.encodeComponent(_selectedState)}';
    }

    try {
      final response = await http.get(Uri.parse(urlString)).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['success'] == true) {
          final List<dynamic> homestayListJson = responseData['data'] ?? [];
          setState(() {
            _homestays = homestayListJson.map((json) => HomestayModel.fromJson(json)).toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = (responseData['message'] ?? 'Data processing issue encountered.').toString();
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Server error status code: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Connection failure. Please verify network access.';
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}