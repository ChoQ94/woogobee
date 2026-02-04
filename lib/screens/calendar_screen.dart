import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../constants/app_colors.dart';
import '../providers/expense_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 개인/공유 토글
              _buildFilterToggle(provider),
              const SizedBox(height: 20),

              // 달력
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.divider),
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  locale: 'ko_KR',
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    leftChevronIcon: const Icon(
                      Icons.chevron_left,
                      color: AppColors.textSecondary,
                    ),
                    rightChevronIcon: const Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    weekendStyle: TextStyle(
                      color: AppColors.calendarSaturday,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: const TextStyle(
                      color: AppColors.textPrimary,
                    ),
                    weekendTextStyle: const TextStyle(
                      color: AppColors.calendarSaturday,
                    ),
                    todayDecoration: BoxDecoration(
                      color: AppColors.calendarToday,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    todayTextStyle: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    selectedTextStyle: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    outsideDaysVisible: false,
                  ),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      final total = provider.getTotalForDay(date.day);
                      if (total > 0 && date.month == _focusedDay.month) {
                        final numberFormat = NumberFormat('#,###');
                        return Positioned(
                          bottom: 2,
                          child: Column(
                            children: [
                              Text(
                                numberFormat.format(total),
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterToggle(ExpenseProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(
            label: '개인',
            icon: Icons.person_outline,
            isSelected: !provider.showSharedOnly,
            onTap: () => provider.toggleSharedFilter(false),
          ),
          _buildToggleButton(
            label: '공유',
            icon: Icons.people_outline,
            isSelected: provider.showSharedOnly,
            onTap: () => provider.toggleSharedFilter(true),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
