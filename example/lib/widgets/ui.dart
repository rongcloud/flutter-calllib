import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:context_holder/context_holder.dart';

import 'package:rongcloud_call_wrapper_plugin/rongcloud_call_wrapper_plugin.dart';
import 'package:flutter_call_plugin_example/data/constants.dart';
import 'package:flutter_call_plugin_example/frame/utils/extension.dart';

List<DropdownMenuItem<RCCallVideoProfile>> videoProfileItems() {
  List<DropdownMenuItem<RCCallVideoProfile>> items = [];
  RCCallVideoProfile.values.forEach((profile) {
    items.add(DropdownMenuItem(
      value: profile,
      child: Text(
        '${ProfileStrings[profile.index]}',
        style: TextStyle(
          fontSize: 15.sp,
          color: Colors.black,
          decoration: TextDecoration.none,
        ),
      ),
    ));
  });
  return items;
}

class SliderTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 5;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class InputBox extends StatelessWidget {
  InputBox({
    required this.hint,
    required this.controller,
    this.type,
    this.size,
    this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.dp),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 0.5,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: type ?? TextInputType.text,
        textInputAction: TextInputAction.done,
        style: TextStyle(
          fontSize: size as double? ?? 20.sp,
          color: Colors.black,
          decoration: TextDecoration.none,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: size as double? ?? 20.sp,
            color: Colors.black.withOpacity(0.7),
            decoration: TextDecoration.none,
          ),
          contentPadding: EdgeInsets.only(
            top: 2.dp,
            bottom: 0.dp,
            left: 10.dp,
            right: 10.dp,
          ),
          isDense: true,
        ),
        inputFormatters: formatter,
      ),
    );
  }

  final String hint;
  final TextEditingController controller;
  final TextInputType? type;
  final num? size;
  final List<TextInputFormatter>? formatter;
}

class Button extends StatelessWidget {
  Button(
    this.text, {
    this.size,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10.dp),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 0.5,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: size as double? ?? 20.sp,
            color: Colors.black,
            decoration: TextDecoration.none,
          ),
        ),
      ),
      onTap: callback,
    );
  }

  final String text;
  final num? size;
  final void Function()? callback;
}

class Radios<T> extends StatelessWidget {
  Radios(
    this.text, {
    this.color = Colors.blue,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            value == groupValue ? Icons.radio_button_on : Icons.radio_button_off,
            color: color,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
      onTap: () => onChanged(value),
    );
  }

  final String text;
  final Color color;
  final T value;
  final T groupValue;
  final void Function(T value) onChanged;
}

class CheckBoxes extends StatelessWidget {
  CheckBoxes(
    this.text, {
    this.enable = true,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            enable && checked ? Icons.check_box : Icons.check_box_outline_blank,
            color: enable ? Colors.blue : Colors.grey,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 15.sp,
              color: enable ? Colors.black : Colors.grey,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
      onTap: () => enable ? onChanged(!checked) : null,
    );
  }

  final String text;
  final bool enable;
  final bool checked;
  final void Function(bool checked) onChanged;
}

extension IconExtension on IconData {
  Widget toWidget() {
    return Icon(this);
  }

  Widget onClick(void Function() onClick) {
    return GestureDetector(
      child: this.toWidget(),
      onTap: onClick,
    );
  }
}

extension StringExtension on String {
  Widget toText({
    Color color = Colors.black,
  }) {
    return Text(
      this,
      softWrap: true,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 15.sp,
        color: color,
        decoration: TextDecoration.none,
      ),
    );
  }

  Widget toSliderWithStringOnTop({
    required double current,
    double min = 0,
    required double max,
    void Function(double value)? onChanged,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          this,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.black,
            decoration: TextDecoration.none,
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(ContextHolder.currentContext).copyWith(
            activeTrackColor: Colors.blue,
            inactiveTrackColor: Colors.blue.withOpacity(0.1),
            thumbColor: Colors.lightBlue,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: 5.dp,
            ),
            trackHeight: 1.dp,
            trackShape: SliderTrackShape(),
            overlayColor: Colors.transparent,
          ),
          child: Slider(
            value: current,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget toSliderWithStringOnLeft({
    required double current,
    double min = 0,
    required double max,
    int flex = 1,
    double divider = 10,
    void Function(double value)? onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        this.toText(),
        VerticalDivider(
          width: divider,
        ),
        Expanded(
          flex: flex,
          child: SliderTheme(
            data: SliderTheme.of(ContextHolder.currentContext).copyWith(
              activeTrackColor: Colors.blue,
              inactiveTrackColor: Colors.blue.withOpacity(0.1),
              thumbColor: Colors.lightBlue,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 5.dp,
              ),
              trackHeight: 1.dp,
              trackShape: SliderTrackShape(),
              overlayColor: Colors.transparent,
            ),
            child: Slider(
              value: current,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget onClick(
    void Function() onClick, {
    Color color = Colors.white,
  }) {
    return GestureDetector(
      child: Text(
        this,
        style: TextStyle(
          fontSize: 15.sp,
          color: color,
          decoration: TextDecoration.none,
        ),
      ),
      onTap: onClick,
    );
  }
}

class BoxFitChooser extends StatelessWidget {
  BoxFitChooser({
    required this.fit,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: fit,
      items: [
        DropdownMenuItem<BoxFit>(
          value: BoxFit.contain,
          child: Text(
            '自适应',
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        DropdownMenuItem<BoxFit>(
          value: BoxFit.cover,
          child: Text(
            '裁剪',
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        DropdownMenuItem<BoxFit>(
          value: BoxFit.fill,
          child: Text(
            '填充',
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        // DropdownMenuItem<BoxFit>(
        //   value: BoxFit.fitWidth,
        //   child: Text('FitWidth'),
        // ),
        // DropdownMenuItem<BoxFit>(
        //   value: BoxFit.fitHeight,
        //   child: Text('FitHeight'),
        // ),
        // DropdownMenuItem<BoxFit>(
        //   value: BoxFit.scaleDown,
        //   child: Text('ScaleDown'),
        // ),
        // DropdownMenuItem<BoxFit>(
        //   value: BoxFit.none,
        //   child: Text('None'),
        // ),
      ],
      onChanged: (dynamic value) {
        onSelected?.call(value);
      },
    );
  }

  final BoxFit fit;
  final void Function(BoxFit value)? onSelected;
}
