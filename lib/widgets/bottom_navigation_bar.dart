import 'package:flutter/material.dart';
import 'package:jawara_pintar_mobile_version/core/theme/app_colors.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey[500],
          selectedFontSize: 10,
          unselectedFontSize: 10,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
          iconSize: 22,
          onTap: (index) {
            if (currentIndex != index) {
              switch (index) {
                case 0:
                  Navigator.pushReplacementNamed(
                    context,
                    '/dashboard-keuangan',
                  );
                  break;
                case 1:
                  Navigator.pushReplacementNamed(
                    context,
                    '/dashboard-kegiatan',
                  );
                  break;
                case 2:
                  Navigator.pushReplacementNamed(
                    context,
                    '/dashboard-kependudukan',
                  );
                  break;
              }
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: currentIndex == 0
                      ? AppColors.primary.withOpacity(0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.payments_rounded),
              ),
              label: 'Keuangan',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: currentIndex == 1
                      ? AppColors.primary.withOpacity(0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.event_rounded),
              ),
              label: 'Kegiatan',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: currentIndex == 2
                      ? AppColors.primary.withOpacity(0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.people_rounded),
              ),
              label: 'Kependudukan',
            ),
          ],
        ),
      ),
    );
  }
}
