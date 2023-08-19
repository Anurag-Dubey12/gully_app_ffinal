import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/src/ui/screens/rate_us.dart';
import 'package:gully_app/src/ui/widgets/gradient_builder.dart';

class LegalViewScreen extends StatelessWidget {
  const LegalViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBuilder(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Privacy Policy',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: InkWell(
          onTap: () => Get.to(() => const RateUsScreen()),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                      '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis efficitur tincidunt interdum. Mauris suscipit tortor non felis vulputate rutrum. Donec tincidunt mauris lectus, gravida viverra libero tristique placerat. Mauris id urna id odio tempus aliquet. Nam et hendrerit metus, at molestie nibh. Etiam sed pretium odio. Praesent maximus dignissim ante, ut tempor nisl consequat sed. Suspendisse dapibus scelerisque mi et accumsan. Nunc pulvinar, erat id feugiat ornare, lorem ex eleifend nisl, eget condimentum sem mauris pharetra felis. Sed eu metus libero. Nunc efficitur eros in gravida consequat. Donec leo quam, auctor eget felis quis, feugiat lacinia justo. In in hendrerit nunc. Nam ut nulla auctor, faucibus metus eleifend, mattis ante.
              
              
              In quam ipsum, maximus et finibus ut, lacinia vel mauris. Duis nec vehicula justo, ac accumsan sem. Curabitur sapien nisl, venenatis at libero non, feugiat consectetur arcu. Phasellus aliquet ex non justo varius, vel vehicula quam tristique. Duis lacinia id sem sit amet convallis. Nulla nunc orci, auctor non imperdiet ac, dictum in ligula. Sed ut ornare sapien, nec hendrerit dolor. Aliquam mattis id massa eu ullamcorper. Praesent id ullamcorper felis, sit amet viverra augue. Mauris convallis massa sapien, semper rutrum augue mollis at. Fusce ante sem, tristique eu ultricies in, consequat eu velit. In ac tristique purus, vel viverra ligula. Ut pharetra ut orci nec fringilla. Praesent nec odio at ligula ultricies dapibus. Aliquam vehicula auctor risus in tincidunt.,
              Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis efficitur tincidunt interdum. Mauris suscipit tortor non felis vulputate rutrum. Donec tincidunt mauris lectus, gravida viverra libero tristique placerat. Mauris id urna id odio tempus aliquet. Nam et hendrerit metus, at molestie nibh. Etiam sed pretium odio. Praesent maximus dignissim ante, ut tempor nisl consequat sed. Suspendisse dapibus scelerisque mi et accumsan. Nunc pulvinar, erat id feugiat ornare, lorem ex eleifend nisl, eget condimentum sem mauris pharetra felis. Sed eu metus libero. Nunc efficitur eros in gravida consequat. Donec leo quam, auctor eget felis quis, feugiat lacinia justo. In in hendrerit nunc. Nam ut nulla auctor, faucibus metus eleifend, mattis ante.
            
            
            In quam ipsum, maximus et finibus ut, lacinia vel mauris. Duis nec vehicula justo, ac accumsan sem. Curabitur sapien nisl, venenatis at libero non, feugiat consectetur arcu. Phasellus aliquet ex non justo varius, vel vehicula quam tristique. Duis lacinia id sem sit amet convallis. Nulla nunc orci, auctor non imperdiet ac, dictum in ligula. Sed ut ornare sapien, nec hendrerit dolor. Aliquam mattis id massa eu ullamcorper. Praesent id ullamcorper felis, sit amet viverra augue. Mauris convallis massa sapien, semper rutrum augue mollis at. Fusce ante sem, tristique eu ultricies in, consequat eu velit. In ac tristique purus, vel viverra ligula. Ut pharetra ut orci nec fringilla. Praesent nec odio at ligula ultricies dapibus. Aliquam vehicula auctor risus in tincidunt.'''),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
