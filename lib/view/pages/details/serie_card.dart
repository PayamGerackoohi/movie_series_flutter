import 'package:flutter/material.dart';
import 'package:movie_series/model/entity/serie.dart';

class SerieCard extends StatefulWidget {
  final Serie serie;
  final bool selected;
  final void Function(int id, bool isSelected) onSelectionChanged;
  final void Function(Serie serie, int index) toggleEpisode;

  const SerieCard(
      {required this.serie,
      required this.onSelectionChanged,
      required this.toggleEpisode,
      this.selected = false,
      super.key});

  void toggled() {
    onSelectionChanged(serie.index, !selected);
  }

  @override
  State<SerieCard> createState() => SerieCardState();
}

class SerieCardState extends State<SerieCard>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;
  static const radius = Radius.circular(12);

  @override
  void initState() {
    prepareAnimations();
    runExpansion();
    super.initState();
  }

  void prepareAnimations() {
    expandController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(covariant SerieCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    runExpansion();
  }

  void runExpansion() {
    if (widget.selected) {
      if (!expandController.isCompleted) {
        expandController.forward();
      }
    } else {
      if (!expandController.isDismissed) {
        expandController.reverse();
      }
    }
  }

  BorderRadius makeBorder() =>
      widget.selected ? singleBorder() : doubleBorder();

  BorderRadius singleBorder() => const BorderRadius.only(topRight: radius);

  BorderRadius doubleBorder() =>
      const BorderRadius.only(topRight: radius, bottomRight: radius);

  TextStyle makeTextStyle() =>
      TextStyle(color: widget.selected ? Colors.yellow : Colors.white);

  int columnOf(double width) => 1 + (width / 300.0).floor();

  @override
  Widget build(BuildContext context) {
    var textStyle = makeTextStyle();
    var borderRadius = makeBorder();
    var width = MediaQuery.of(context).size.width;
    var columnCount = columnOf(width);
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ElevatedButton(
              onPressed: widget.toggled,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[900],
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: (Text(widget.serie.name, style: textStyle)))),
          SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: animation,
              child: Material(
                  elevation: 4,
                  borderRadius: const BorderRadius.only(
                      topRight: radius,
                      bottomRight: radius,
                      bottomLeft: radius),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[900],
                      borderRadius: const BorderRadius.only(
                          topRight: radius,
                          bottomRight: radius,
                          bottomLeft: radius),
                    ),
                    child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columnCount,
                          childAspectRatio: width / 70.0 / columnCount,
                        ),
                        itemCount: widget.serie.count,
                        itemBuilder: (_, index) => Padding(
                            padding: const EdgeInsets.all(8),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        index + 1 > widget.serie.last
                                            ? Colors.red
                                            : Colors.green),
                                onPressed: () => widget.toggleEpisode(
                                    widget.serie, index + 1),
                                child: Text('Episode ${index + 1}')))),
                  )))
        ]));
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }
}
