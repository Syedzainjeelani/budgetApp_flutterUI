import 'package:flutter/material.dart';
import 'package:flutter_budget_ui/data/data.dart';
import 'package:flutter_budget_ui/helpers/color_helper.dart';
import 'package:flutter_budget_ui/helpers/constants.dart';
import 'package:flutter_budget_ui/models/category_model.dart';
import 'package:flutter_budget_ui/models/expense_model.dart';
import 'package:flutter_budget_ui/screens/category_screen.dart';

class HomeScreen extends StatelessWidget {
  _buildWeeklyChart() {
    return Container(
      height: 250,
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            spreadRadius: 1,
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                'Weekly Spending',
                style: kTitleTextStyle,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {},
                  ),
                  Text(
                    'Nov 10, 2019 - Nov 16, 2019',
                    style: kBodyTextStyle,
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildDayBar(0, 'Su'),
              _buildDayBar(1, 'Mo'),
              _buildDayBar(2, 'Tu'),
              _buildDayBar(3, 'We'),
              _buildDayBar(4, 'Th'),
              _buildDayBar(5, 'Fr'),
              _buildDayBar(6, 'Sa'),
            ],
          )
        ],
      ),
    );
  }

  _buildDayBar(int barNo, String day) {
    double weeklySpend = weeklySpending[barNo];
    double percent = weeklySpend / 100;
    double calculatedHeight = percent * 120;

    return Column(
      children: [
        Text(
          '\$${weeklySpend.toStringAsFixed(2)}',
          style: kdaysTextStyle,
        ),
        Container(
          width: 20,
          height: calculatedHeight,
          decoration: BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Text(
          day,
          style: kdaysTextStyle,
        ),
      ],
    );
  }

  _buildCategory(Category category, double totalAmountSpent) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            blurRadius: 6.0,
            color: Colors.grey[300],
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.name,
                style: kTitleTextStyle,
              ),
              Text(
                '\$${(category.maxAmount - totalAmountSpent).toStringAsFixed(2)}/\$${category.maxAmount}',
                style: kBodyTextStyle,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          LayoutBuilder(
            builder: (context, contraints) {
              double maxBarWidth = contraints.maxWidth;
              double percent =
                  (category.maxAmount - totalAmountSpent) / category.maxAmount;
              double barWidth = percent * maxBarWidth;

              if (barWidth < 0) {
                barWidth = 0;
              }

              return Stack(
                children: [
                  Container(
                    height: 20,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    height: 20,
                    width: barWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: getColor(context, percent),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            forceElevated: true,
            // floating: true,
            pinned: true,
            expandedHeight: 100,
            leading: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
              iconSize: 30,
              color: kIconColor,
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text('Simple Budget'),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.add),
                iconSize: 30,
                color: kIconColor,
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == 0) {
                  return _buildWeeklyChart();
                } else {
                  Category category = categories[index - 1];
                  double totalAmountSpent = 0;
                  category.expenses.forEach((Expense expense) {
                    totalAmountSpent += expense.cost;
                  });
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryScreen(
                          category: category,
                          totalAmountSpent: totalAmountSpent,
                        ),
                      ),
                    ),
                    child: _buildCategory(category, totalAmountSpent),
                  );
                }
              },
              childCount: categories.length,
            ),
          )
        ],
      ),
    );
  }
}
