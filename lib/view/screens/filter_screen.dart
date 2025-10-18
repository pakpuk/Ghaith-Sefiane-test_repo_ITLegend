import 'package:flutter/material.dart';

/// Filter Page for Real Estate
/// Allows users to filter properties by various criteria
class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String? _selectedCategory = 'عقارات';
  String? _selectedLocation;
  double _minMonthlyPayment = 0;
  double _maxMonthlyPayment = 10000;
  String? _selectedGenre;
  String? _selectedRooms;
  double _minPrice = 0;
  double _maxPrice = 5000000;
  String? _selectedPaymentMethod;
  String? _selectedPropertyState;

  final TextEditingController _minMonthlyController = TextEditingController();
  final TextEditingController _maxMonthlyController = TextEditingController();

  final List<String> _categories = [
    'عقارات',
    'سيارات',
    'إلكترونيات',
    'أثاث',
  ];

  final List<String> _locations = [
    'القاهرة',
    'الإسكندرية',
    'الجيزة',
    'الأقصر',
    'أسوان',
  ];

  final List<String> _genres = [
    'فيلا',
    'شقة',
    'دوبلكس',
    'بنتهاوس',
    'استوديو',
  ];

  final List<String> _roomNumbers = [
    '1',
    '2',
    '3',
    '4',
    '5+',
  ];

  final List<String> _paymentMethods = [
    'كاش',
    'تقسيط',
    'كاش وتقسيط',
  ];

  final List<String> _propertyStates = [
    'جديد',
    'مستعمل',
    'تحت الإنشاء',
  ];

  @override
  void initState() {
    super.initState();
    _minMonthlyController.text = _minMonthlyPayment.toStringAsFixed(0);
    _maxMonthlyController.text = _maxMonthlyPayment.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'تصفية النتائج',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: const Text(
              'إعادة تعيين',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Section
                  _buildSectionTitle('الفئة'),
                  const SizedBox(height: 8),
                  _buildCategoryDropdown(),

                  const SizedBox(height: 24),

                  // Location Section
                  _buildSectionTitle('الموقع'),
                  const SizedBox(height: 8),
                  _buildLocationDropdown(),

                  const SizedBox(height: 24),

                  // Monthly Installments Section
                  _buildSectionTitle('الأقساط الشهرية'),
                  const SizedBox(height: 8),
                  _buildMonthlyPaymentFields(),

                  const SizedBox(height: 24),

                  // Genre Section
                  _buildSectionTitle('النوع'),
                  const SizedBox(height: 8),
                  _buildGenreChips(),

                  const SizedBox(height: 24),

                  // Number of Rooms Section
                  _buildSectionTitle('عدد الغرف'),
                  const SizedBox(height: 8),
                  _buildRoomChips(),

                  const SizedBox(height: 24),

                  // Price Range Section
                  _buildSectionTitle('السعر'),
                  const SizedBox(height: 8),
                  _buildPriceRangeCard(),

                  const SizedBox(height: 24),

                  // Payment Method Section
                  _buildSectionTitle('طريقة الدفع'),
                  const SizedBox(height: 8),
                  _buildPaymentMethodChips(),

                  const SizedBox(height: 24),

                  // Property State Section
                  _buildSectionTitle('حالة العقار'),
                  const SizedBox(height: 8),
                  _buildPropertyStateChips(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Bottom Button
          _buildApplyButton(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,
          hint: const Text('اختر الفئة'),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: _categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCategory = newValue;
            });
          },
        ),
      ),
    );
  }

  Widget _buildLocationDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLocation,
          isExpanded: true,
          hint: const Text('اختر الموقع'),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: _locations.map((String location) {
            return DropdownMenuItem<String>(
              value: location,
              child: Text(location),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedLocation = newValue;
            });
          },
        ),
      ),
    );
  }

  Widget _buildMonthlyPaymentFields() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _minMonthlyController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'الحد الأدنى',
              suffixText: 'ج.م',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _minMonthlyPayment = double.tryParse(value) ?? 0;
              });
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: _maxMonthlyController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'الحد الأقصى',
              suffixText: 'ج.م',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _maxMonthlyPayment = double.tryParse(value) ?? 10000;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGenreChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _genres.map((genre) {
        final isSelected = _selectedGenre == genre;
        return FilterChip(
          label: Text(genre),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              _selectedGenre = selected ? genre : null;
            });
          },
          backgroundColor: Colors.white,
          selectedColor: Colors.red[50],
          checkmarkColor: Colors.red,
          labelStyle: TextStyle(
            color: isSelected ? Colors.red : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isSelected ? Colors.red : Colors.grey[300]!,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRoomChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _roomNumbers.map((room) {
        final isSelected = _selectedRooms == room;
        return FilterChip(
          label: Text(room),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              _selectedRooms = selected ? room : null;
            });
          },
          backgroundColor: Colors.white,
          selectedColor: Colors.red[50],
          checkmarkColor: Colors.red,
          labelStyle: TextStyle(
            color: isSelected ? Colors.red : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isSelected ? Colors.red : Colors.grey[300]!,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPriceRangeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_minPrice.toStringAsFixed(0)} ج.م',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${_maxPrice.toStringAsFixed(0)} ج.م',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          RangeSlider(
            values: RangeValues(_minPrice, _maxPrice),
            min: 0,
            max: 10000000,
            divisions: 100,
            activeColor: Colors.red,
            inactiveColor: Colors.red[100],
            onChanged: (RangeValues values) {
              setState(() {
                _minPrice = values.start;
                _maxPrice = values.end;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _paymentMethods.map((method) {
        final isSelected = _selectedPaymentMethod == method;
        return FilterChip(
          label: Text(method),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              _selectedPaymentMethod = selected ? method : null;
            });
          },
          backgroundColor: Colors.white,
          selectedColor: Colors.red[50],
          checkmarkColor: Colors.red,
          labelStyle: TextStyle(
            color: isSelected ? Colors.red : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isSelected ? Colors.red : Colors.grey[300]!,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPropertyStateChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _propertyStates.map((state) {
        final isSelected = _selectedPropertyState == state;
        return FilterChip(
          label: Text(state),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              _selectedPropertyState = selected ? state : null;
            });
          },
          backgroundColor: Colors.white,
          selectedColor: Colors.red[50],
          checkmarkColor: Colors.red,
          labelStyle: TextStyle(
            color: isSelected ? Colors.red : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isSelected ? Colors.red : Colors.grey[300]!,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context, {
                'category': _selectedCategory,
                'location': _selectedLocation,
                'minMonthly': _minMonthlyPayment,
                'maxMonthly': _maxMonthlyPayment,
                'genre': _selectedGenre,
                'rooms': _selectedRooms,
                'minPrice': _minPrice,
                'maxPrice': _maxPrice,
                'paymentMethod': _selectedPaymentMethod,
                'propertyState': _selectedPropertyState,
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'تطبيق الفلتر',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedCategory = 'عقارات';
      _selectedLocation = null;
      _minMonthlyPayment = 0;
      _maxMonthlyPayment = 10000;
      _selectedGenre = null;
      _selectedRooms = null;
      _minPrice = 0;
      _maxPrice = 5000000;
      _selectedPaymentMethod = null;
      _selectedPropertyState = null;
      _minMonthlyController.text = '0';
      _maxMonthlyController.text = '10000';
    });
  }

  @override
  void dispose() {
    _minMonthlyController.dispose();
    _maxMonthlyController.dispose();
    super.dispose();
  }
}
