import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/res/colors.dart';

class CustomizableCounter extends StatefulWidget {
  /// the counter value will de decreased.
  final Widget? decrementIcon;

  /// the counter value will de increased.
  final Widget? incrementIcon;

  /// the current value of the counter.
  final double count;

  /// the maximum value support for counter
  final double maxCount;

  /// the minimum value support for counter
  final double minCount;

  /// the minimum value support for padding
  final double padding;

  /// amount increased or decreased after clicking buttons.
  final double step;

  /// does shown button text when counter value is zero.

  /// called when the counter value change by clicking button.
  final void Function(double c)? onCountChange;

  /// called when the counter value increase by clicking increment button.
  final void Function(double c)? onIncrement;

  /// called when the counter value increase by clicking increment button.
  final void Function(double c)? onDecrement;

  const CustomizableCounter({
    super.key,
    this.decrementIcon,
    this.incrementIcon,
    this.count = 0,
    this.maxCount = double.maxFinite,
    this.minCount = 0,
    this.step = 1,
    this.onCountChange,
    this.onIncrement,
    this.onDecrement,
    this.padding = 8,
  });

  @override
  State<CustomizableCounter> createState() => _CustomizableCounterState();
}

class _CustomizableCounterState extends State<CustomizableCounter> {
  double mCount = 0;

  @override
  void initState() {
    mCount = widget.count;
    super.initState();
  }

  void decrement() {
    setState(() {
      if ((mCount - widget.step) >= widget.minCount) {
        mCount -= widget.step;
        widget.onCountChange?.call(mCount);
        widget.onDecrement?.call(mCount);
      }
    });
  }

  void increment() {
    setState(() {
      if ((mCount + widget.step) <= widget.maxCount) {
        mCount += widget.step;
        widget.onCountChange?.call(mCount);
        widget.onIncrement?.call(mCount);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(width: 1, color: GREY),
            shape: BoxShape.rectangle,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: decrement,
                child: Padding(
                  padding: EdgeInsets.all(widget.padding),
                  child: const HeroIcon(HeroIcons.minus, size: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  _formatDouble(mCount),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: increment,
                child: Padding(
                  padding: EdgeInsets.all(widget.padding),
                  child: const HeroIcon(HeroIcons.plus, size: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String _formatDouble(double value) {
  //this also rounds (so 0.8999999999999999 becomes '0.9000')
  var verbose = value.toStringAsFixed(4);
  var trimmed = verbose;
  //trim all trailing 0's after the decimal point (and the decimal point if applicable)
  for (var i = verbose.length - 1; i > 0; i--) {
    if (trimmed[i] != '0' && trimmed[i] != '.' || !trimmed.contains('.')) {
      break;
    }
    trimmed = trimmed.substring(0, i);
  }
  return trimmed;
}
