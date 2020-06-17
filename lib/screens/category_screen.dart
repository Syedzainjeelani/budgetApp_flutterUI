import 'package:flutter/material.dart';
import 'package:flutter_budget_ui/helpers/color_helper.dart';
import 'package:flutter_budget_ui/helpers/constants.dart';
import 'package:flutter_budget_ui/models/category_model.dart';
import 'package:flutter_budget_ui/models/expense_model.dart';
import 'package:flutter_budget_ui/widgets/radial_painter.dart';

class CategoryScreen extends StatefulWidget {
  final Category category;
  final double totalAmountSpent;
  CategoryScreen({this.category, this.totalAmountSpent});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  _buildCircleGraph() {
    double amountLeft = widget.category.maxAmount - widget.totalAmountSpent;
    double percent = amountLeft / widget.category.maxAmount;

    return Container(
      height: 250,
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 6.0,
          ),
        ],
      ),
      child: CustomPaint(
        foregroundPainter: RadialPainter(
            bgColor: Colors.grey[200],
            lineColor: getColor(context, percent),
            width: 15.0,
            percent: percent),
        child: Center(
          child: Text(
            '\$${amountLeft.toStringAsFixed(2)} / \$${widget.category.maxAmount}',
            style: kBodyTextStyle,
          ),
        ),
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
              icon: Icon(
                Icons.arrow_back_ios,
                size: 25,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(widget.category.name),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {},
                iconSize: 30,
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == 0) {
                  return _buildCircleGraph();
                } else {
                  Expense expense = widget.category.expenses[index];
                  return Container(
                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.grey[300], blurRadius: 6.0),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          expense.name,
                          style: kBodyTextStyle,
                        ),
                        Text(
                          '-\$${expense.cost.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }
              },
              childCount: widget.category.expenses.length,
            ),
          ),
        ],
      ),
    );
  }
}
