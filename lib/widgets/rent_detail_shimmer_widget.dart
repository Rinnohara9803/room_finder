import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RentDetailShimmerWidget extends StatelessWidget {
  const RentDetailShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(
        milliseconds: 1500,
      ),
      baseColor: Colors.grey,
      highlightColor: Colors.white,
      direction: ShimmerDirection.ltr,
      child: Column(
        children: [
          Expanded(
            flex: 9,
            child: Container(
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Expanded(
            flex: 13,
            child: Container(
              color: Colors.white,
            ),
          ),
          Container(
            height: 80,
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            color: Colors.black12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '__ __ __ __ __ __ __',
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    FloatingActionButton.small(
                      heroTag: '1',
                      backgroundColor: Colors.white,
                      onPressed: () {},
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    FloatingActionButton.small(
                      heroTag: '2',
                      backgroundColor: Colors.white,
                      onPressed: () {},
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    FloatingActionButton.small(
                      heroTag: '3',
                      backgroundColor: Colors.white,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
