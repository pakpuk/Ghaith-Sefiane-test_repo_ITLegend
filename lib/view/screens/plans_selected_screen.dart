import 'package:flutter/material.dart';

/// Plans Selection Page
/// Displays subscription plans with features and pricing
class PlansPage extends StatefulWidget {
  const PlansPage({Key? key}) : super(key: key);

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  final List<int> _selectedPlanIds = [];

  final List<Map<String, dynamic>> _plans = [
    {
      'id': 1,
      'name': 'أساسية',
      'price': 3000.0,
      'isPopular': false,
      'features': [
        'صلاحية الاشغال 30 يوم',
      ],
    },
    {
      'id': 2,
      'name': 'إكسبرس',
      'price': 3000.0,
      'isPopular': true,
      'badge': 'الاكثر شهرة',
      'stats': {
        'count': 7,
        'label': 'عملاء مشابهين',
      },
      'features': [
        'صلاحية الاشغال 30 يوم',
        'ردود اعلى المقدمة 10 أيام',
        'تثبيت في مقابل مجى',
        'تثبيت في مقابل مجى (شامل ارسالة شامل المجى)',
        'الظهور في كل خدماتك فى مصر',
        'اظهار مميز',
      ],
    },
    {
      'id': 3,
      'name': 'بنفس',
      'price': 3000.0,
      'isPopular': false,
      'stats': {
        'count': 18,
        'label': 'عملاء مشابهين',
      },
      'features': [
        'صلاحية الاشغال 30 يوم',
        'ردود اعلى المقدمة 10 أيام',
        'تثبيت في مقابل مجى',
        'تثبيت في مقابل مجى (شامل ارسالة شامل المجى)',
        'الظهور في كل خدماتك فى مصر',
      ],
    },
    {
      'id': 4,
      'name': 'سوبر',
      'price': 3000.0,
      'isPopular': false,
      'stats': {
        'count': 24,
        'label': 'عملاء مشابهين',
      },
      'features': [
        'صلاحية الاشغال 30 يوم',
        'ردود اعلى المقدمة 10 أيام',
        'تثبيت في مقابل مجى',
        'تثبيت في مقابل مجى (شامل ارسالة شامل المجى)',
        'الظهور في كل خدماتك فى مصر',
        'اظهار مميز',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {
            // Navigate to packages info page
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'اختار الباقات اللى تناسبك',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: Colors.white,
            child: Text(
              'اختار باقه واحدة او اكتر من السهل عليك تناسب احتياجاتك',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Plans List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _plans.length,
              itemBuilder: (context, index) {
                return _buildPlanCard(_plans[index]);
              },
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),

      // Bottom Button
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    final int planId = plan['id'];
    final bool isSelected = _selectedPlanIds.contains(planId);
    final bool isPopular = plan['isPopular'] ?? false;
    final String name = plan['name'];
    final double price = plan['price'];
    final List<String> features = List<String>.from(plan['features']);
    final Map<String, dynamic>? stats = plan['stats'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.blue[700]! : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with checkbox and price
          InkWell(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedPlanIds.remove(planId);
                } else {
                  _selectedPlanIds.add(planId);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Checkbox
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue[700] : Colors.transparent,
                      border: Border.all(
                        color:
                            isSelected ? Colors.blue[700]! : Colors.grey[400]!,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          )
                        : null,
                  ),

                  const SizedBox(width: 12),

                  // Plan name
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  // Price
                  Text(
                    '${price.toStringAsFixed(0)} ج.م',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[600],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Popular badge
          if (isPopular) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!),
                  bottom: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.orange[700],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    plan['badge'] ?? 'الاكثر شهرة',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange[700],
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Divider(height: 1, color: Colors.grey[200]),
          ],

          // Features list
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: features.map((feature) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          size: 10,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          feature,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // Stats section
          if (stats != null)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  // Profile icon
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.grey[600],
                      size: 22,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Stats
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${stats['count']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          stats['label'],
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    final hasSelection = _selectedPlanIds.isNotEmpty;

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
          height: 52,
          child: ElevatedButton(
            onPressed: hasSelection
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'تم اختيار ${_selectedPlanIds.length} باقة بنجاح'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[300],
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              hasSelection
                  ? 'اشترك الباقات المختارة (${_selectedPlanIds.length})'
                  : 'اشترك الباقات المختارة',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
