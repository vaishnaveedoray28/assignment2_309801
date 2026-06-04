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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 209, 223, 227),
      appBar: AppBar(
        title: const Text(
          'Homestay2U Malaysia',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 2, 90, 141),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 2,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search homestay...',
                        prefixIcon: const Icon(Icons.search, color: Colors.teal),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  _fetchHomestays();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      onSubmitted: (_) => _fetchHomestays(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                
                Card(
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  color: _selectedState == 'All' ? Colors.white : Colors.teal,
                  child: PopupMenuButton<String>(
                    initialValue: _selectedState,
                    icon: Icon(
                      Icons.filter_list, 
                      color: _selectedState == 'All' ? Colors.teal : Colors.white,
                    ),
                    tooltip: 'Filter by State',
                    onSelected: (String stateName) {
                      setState(() {
                        _selectedState = stateName;
                      });
                      _fetchHomestays();
                    },
                    itemBuilder: (BuildContext context) {
                      return _malaysianStates.map((String state) {
                        return PopupMenuItem<String>(
                          value: state,
                          child: Row(
                            children: [
                              Icon(
                                state == 'All' ? Icons.map : Icons.location_on, 
                                size: 18, 
                                color: _selectedState == state ? Colors.teal : Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                state,
                                style: TextStyle(
                                  fontWeight: _selectedState == state ? FontWeight.bold : FontWeight.normal,
                                  color: _selectedState == state ? Colors.teal : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ],
            ),
          ),
          
          if (_selectedState != 'All')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 2.0),
              child: Row(
                children: [
                  Text(
                    'Active Filter: ',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Chip(
                    label: Text(_selectedState, style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                    backgroundColor: Colors.teal,
                    visualDensity: VisualDensity.compact,
                    deleteIcon: const Icon(Icons.close, size: 14, color: Colors.white),
                    onDeleted: () {
                      setState(() {
                        _selectedState = 'All';
                      });
                      _fetchHomestays();
                    },
                  ),
                ],
              ),
            ),
          
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.teal))
                : _errorMessage.isNotEmpty
                    ? _buildStateMessage(Icons.cloud_off, _errorMessage)
                    : _homestays.isEmpty
                        ? _buildStateMessage(Icons.search_off, 'No matching homestays found.')
                        : RefreshIndicator(
                            onRefresh: _fetchHomestays,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              itemCount: _homestays.length,
                              itemBuilder: (context, index) {
                                return _buildHomestayItemCard(context, _homestays[index]);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateMessage(IconData icon, String message) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
              onPressed: _fetchHomestays,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry / Refresh'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHomestayItemCard(BuildContext context, HomestayModel homestay) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomestayDetailScreen(homestay: homestay)),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            homestay.imageUrl.isNotEmpty
                ? Image.network(
                    homestay.imageUrl,
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 160,
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator(color: Colors.teal)),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => _buildCardImagePlaceholder(),
                  )
                : _buildCardImagePlaceholder(),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          homestay.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'RM ${homestay.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 31, 115)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, size: 14, color: Color.fromARGB(255, 243, 62, 2)),
                      const SizedBox(width: 4),
                      Text('${homestay.district}, ${homestay.state}', style: const TextStyle(fontSize: 13, color: Color.fromARGB(255, 150, 13, 13))),
                    ],
                  ),
                  const Divider(height: 16),
                  Text(
                    homestay.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 160,
      color: Colors.grey[200],
      child: const Icon(Icons.home_work_outlined, size: 45, color: Colors.grey),
    );
  }
}