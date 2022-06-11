import 'package:bookque/common/styles.dart';
import 'package:bookque/data/models/report.dart';
import 'package:flutter/material.dart';

class ReportDialog extends StatefulWidget {
  const ReportDialog({Key? key}) : super(key: key);

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  bool isChecked = false;

  List<Report> selectedReport = [];

  Widget reportDialog(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        reportHeader(context),
        Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const Text('Apa yang membuatmu ingin melaporkan buku ini?'),
              const SizedBox(height: 10),
              reportList(),
              const SizedBox(height: 5),
              sentReportButton(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget reportHeader(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 15),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(12), topLeft: Radius.circular(12)),
      ),
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(child: Text('Laporkan', style: popUpTitle)),
            Positioned(
              right: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ]),
    );
  }

  Widget reportList() {
    return SizedBox(
      height: 300,
      width: 320,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: listReport.length,
          itemBuilder: (context, index) {
            final Report reports = listReport[index];
            return InkWell(
              onTap: () {
                setState(() {
                  reports.isSelected = !reports.isSelected;
                  if (reports.isSelected == true) {}
                });
              },
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                height: 50,
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      reports.name,
                      style: buttonSmall,
                    ),
                    reports.isSelected
                        ? const Icon(
                      Icons.check_circle,
                      color: primaryColor,
                    )
                        : const Icon(
                      Icons.circle_outlined,
                      color: primaryColor,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget sentReportButton(BuildContext context) {
    return SizedBox(
      width: 320,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        onPressed: () {},
        child: Text(
          'Kirim',
          style: buttonLarge,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      content: reportDialog(context),
    );
  }
}