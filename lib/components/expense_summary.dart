import 'package:expense_tracker/bar%20graph/bar_graph.dart';
import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/datetime/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfweek;
  const ExpenseSummary({super.key, required this.startOfweek});

  //calculate max amount in bar graph
  double calculateMax(
    ExpenseData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    double max = 100;
    List<double> values = [
      value.calculateExpenseSummary()[sunday] ?? 0,
      value.calculateExpenseSummary()[monday] ?? 0,
      value.calculateExpenseSummary()[tuesday] ?? 0,
      value.calculateExpenseSummary()[wednesday] ?? 0,
      value.calculateExpenseSummary()[thursday] ?? 0,
      value.calculateExpenseSummary()[friday] ?? 0,
      value.calculateExpenseSummary()[saturday] ?? 0,
    ];
    //sort values from small to largest
    values.sort();
    //get the largest value
    //and increase the cap
    max = values.last * 1.1;
    return max == 0 ? 100 : max;
  }

  //calculate the weeks total expense
  String calculateWeekTotal(
    ExpenseData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    double max = 100;
    List<double> values = [
      value.calculateExpenseSummary()[sunday] ?? 0,
      value.calculateExpenseSummary()[monday] ?? 0,
      value.calculateExpenseSummary()[tuesday] ?? 0,
      value.calculateExpenseSummary()[wednesday] ?? 0,
      value.calculateExpenseSummary()[thursday] ?? 0,
      value.calculateExpenseSummary()[friday] ?? 0,
      value.calculateExpenseSummary()[saturday] ?? 0,
    ];
    double total = 0;
    for (int i = 0; i < values.length; i++) {
      total += values[i];
    }
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    // get yyyymmdd for each day of the week
    String sunday = convertDateTimeToString(startOfweek.add(Duration(days: 0)));
    String monday = convertDateTimeToString(startOfweek.add(Duration(days: 1)));
    String tuesday = convertDateTimeToString(
      startOfweek.add(Duration(days: 2)),
    );
    String wednesday = convertDateTimeToString(
      startOfweek.add(Duration(days: 3)),
    );
    String thursday = convertDateTimeToString(
      startOfweek.add(Duration(days: 4)),
    );
    String friday = convertDateTimeToString(startOfweek.add(Duration(days: 5)));
    String saturday = convertDateTimeToString(
      startOfweek.add(Duration(days: 6)),
    );

    return Consumer<ExpenseData>(
      builder: (contect, value, child) => Column(
        children: [
          //weeks total
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Weekly Total:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'R${calculateWeekTotal(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          //bar graph
          SizedBox(
            height: 200,
            child: MyBarGraph(
              maxY: calculateMax(
                value,
                sunday,
                monday,
                tuesday,
                wednesday,
                thursday,
                friday,
                saturday,
              ),
              sunAmount: value.calculateExpenseSummary()[sunday] ?? 0,
              monAmount: value.calculateExpenseSummary()[monday] ?? 0,
              tueAmount: value.calculateExpenseSummary()[tuesday] ?? 0,
              wedAmount: value.calculateExpenseSummary()[wednesday] ?? 0,
              thuAmount: value.calculateExpenseSummary()[thursday] ?? 0,
              friAmount: value.calculateExpenseSummary()[friday] ?? 0,
              satAmount: value.calculateExpenseSummary()[saturday] ?? 0,
            ),
          ),
        ],
      ),
    );
  }
}
