import 'package:flutter/material.dart';
import 'package:flutter_subshegde/universal/constants/app_colors.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:number_paginator/number_paginator.dart';

class NumberPaginator1 extends StatefulWidget {
  @override
  _NumberPaginator1State createState() => _NumberPaginator1State();
}

class _NumberPaginator1State extends State<NumberPaginator1> {
  int numberPages = 5;
  int curentIndex = 0;

  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(() {
        fn();
      });
    }
  }

  var selectedPageNumber = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const Text('Pagination'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('number_paginator')],
            ),
            if (numberPages != null && numberPages! > 0) ...[
              Center(
                child: NumberPaginator(
                  numberPages: numberPages!,
                  onPageChange: (int index) {
                    safeSetState(() {
                      curentIndex = index;
                    });
                    // api call
                  },
                  config: const NumberPaginatorUIConfig(
                    buttonSelectedBackgroundColor: AppColors.blue,
                    buttonUnselectedForegroundColor: Colors.black,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20,),
             const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('number_pagination')],
            ),
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  NumberPagination(
                    onPageChanged: (int pageNumber) {
                      setState(() {
                        selectedPageNumber = pageNumber;
                      });
                      // api call
                    },
                    visiblePagesCount: 5,
                    totalPages: 10,
                    currentPage: selectedPageNumber,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
