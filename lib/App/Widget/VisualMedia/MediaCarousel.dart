import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/FullScreenImage.dart';
import 'package:escuchamos_flutter/App/Widget/VisualMedia/VideoPlayer.dart';

class MediaCarousel extends StatefulWidget {
  final List<String> mediaUrls;

  const MediaCarousel({
    Key? key,
    required this.mediaUrls,
  }) : super(key: key);

  @override
  _MediaCarouselState createState() => _MediaCarouselState();
}

class _MediaCarouselState extends State<MediaCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    const double mediaHeight = 250.0;
    const double mediaWidth = double.infinity;

    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: mediaHeight,
            enableInfiniteScroll: false,
            autoPlay: false,
            enlargeCenterPage: true,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.mediaUrls.map((url) {
            return GestureDetector(
              onTap: () {
                if (!url.endsWith('.mp4')) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImage(imageUrl: url),
                    ),
                  );
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: url.endsWith('.mp4')
                    ? AspectRatio(
                        aspectRatio: 16 / 9,
                        child: VideoPlayerWidget(videoUrl: url),
                      )
                    : Image.network(
                        url,
                        fit: BoxFit.cover,
                        width: mediaWidth,
                      ),
              ),
            );
          }).toList(),
        ),
        if (widget.mediaUrls.length > 1) // Muestra el contador solo si hay más de 1 elemento
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${_currentIndex + 1}/${widget.mediaUrls.length}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
