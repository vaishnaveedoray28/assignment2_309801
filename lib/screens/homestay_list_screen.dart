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

  Future<void> _fetchHomestays() async {}
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}