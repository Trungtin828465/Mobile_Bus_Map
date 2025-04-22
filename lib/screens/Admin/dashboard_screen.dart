import 'package:flutter/material.dart';
import 'package:busmap/widgets/admin/dashboard_appbar.dart';
import 'package:busmap/widgets/admin/dashboard_drawer.dart';
import 'package:busmap/widgets/admin/dashboard_body.dart';
import 'package:busmap/widgets/admin/dashboard_footer.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: DashboardAppBar(scaffoldKey: _scaffoldKey),
      drawer: const DashboardDrawer(),
      body: Column(
        children: [
          const Expanded(child: DashboardBody()),
          const DashboardFooter(),
        ],
      ),
    );
  }
}
