import 'package:flutter/material.dart';

class ImageWidgetGallery extends StatefulWidget {
  final List<String> images;

  const ImageWidgetGallery({Key? key, required this.images}) : super(key: key);

  @override
  State<ImageWidgetGallery> createState() => _ImageWidgetGalleryState();
}

class _ImageWidgetGalleryState extends State<ImageWidgetGallery> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Flexible(
          flex: 7,
          child: Image.network(
            currentIndex < widget.images.length && widget.images.isNotEmpty
                ? widget.images[currentIndex]
                : '',
            fit: BoxFit.fill,
            errorBuilder: (ctx, obj, stack) {
              return Image.asset(
                'assets/placeholder.png',
                fit: BoxFit.fill,
              );
            },
          ),
        ),
        Flexible(
          flex: 2,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.images.length,
            itemBuilder: (ctx, idx) {
              return InkWell(
                onTap: currentIndex == idx
                    ? null
                    : () => setState(() => currentIndex = idx),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/loading.gif',
                      image: widget.images[idx],
                      width: size.width * 0.20,
                      fit: BoxFit.fill,
                      imageErrorBuilder: (ctx, obj, stack) {
                        return Image.asset(
                          'assets/placeholder.png',
                          width: size.width * 0.20,
                          fit: BoxFit.fill,
                        );
                      },
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: currentIndex == idx
                        ? Border.all(
                            color: Colors.red,
                            width: 4.0,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
