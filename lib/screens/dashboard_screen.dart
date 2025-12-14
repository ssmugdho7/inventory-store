import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer allows this specific widget to rebuild when inventory changes
    return Consumer<InventoryProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          color: Colors.teal.shade50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Overview",
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.teal
                ),
              ),
              const SizedBox(height: 10),
              
              // Row 1: Total Items & Total Stock
              Row(
                children: [
                  // We use Expanded so cards fill the width evenly
                  Expanded(
                    child: _buildStatCard(
                      'Total Items', 
                      '${provider.totalItems}', 
                      Icons.inventory_2, 
                      Colors.blue
                    )
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildStatCard(
                      'Total Stock', 
                      '${provider.totalStock}', 
                      Icons.numbers, 
                      Colors.orange
                    )
                  ),
                ],
              ),
              const SizedBox(height: 10),
              
              // Row 2: Low Stock Warning
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Low Stock', 
                      '${provider.lowStockItems}', 
                      Icons.warning_amber_rounded, 
                      Colors.red,
                      isAlert: provider.lowStockItems > 0
                    )
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to build consistent cards
  Widget _buildStatCard(String title, String value, IconData icon, Color color, {bool isAlert = false}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // If it's an alert (Low Stock > 0), give it a subtle red tint
      color: isAlert ? Colors.red.shade50 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isAlert ? Colors.red : Colors.black87,
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}