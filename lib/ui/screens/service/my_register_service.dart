import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/service_controller.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';

class MyRegisterService extends StatefulWidget {
  const MyRegisterService({super.key});

  @override
  State<StatefulWidget> createState() => MyServices();
}

class MyServices extends State<MyRegisterService> {
  @override
  Widget build(BuildContext context) {
    final controller=Get.find<ServiceController>();
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: AssetImage(
              'assets/images/sports_icon.png',
            ),
            fit: BoxFit.cover),
      ),
      child: GradientBuilder(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("My Services"),
            backgroundColor: Colors.transparent,
            titleTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Get.back(),
            ),
          ),
          body: FutureBuilder(
            future: controller.getuserService(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (snapshot.data == null) {
                return Center(child: Text('No data found'));
              }
              return ListView.separated(
                itemCount: controller.userservice.length,
                itemBuilder: (context, index) {
                  // final  service=snapshot.data![index];
                  return ListTile(
                    onTap: () {

                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(height: 1);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

// class Services extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//
//   }
// }
