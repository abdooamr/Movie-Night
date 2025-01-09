import 'package:flutter/material.dart';

class CustomSettingsTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final Widget? leading;
  final Widget? child;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final Function()? onTap;
  final bool enabled;

  CustomSettingsTile({
    required this.title,
    this.subtitle = '',
    this.leading,
    this.child,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.onTap,
    this.enabled = true,
  });

  @override
  _CustomSettingsTileState createState() => _CustomSettingsTileState();
}

class _CustomSettingsTileState extends State<CustomSettingsTile> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListTile(
            tileColor: Colors.transparent,
            leading: widget.leading,
            title: Text(widget.title,
                style: widget.titleTextStyle ??
                    Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 16,
                        )),
            subtitle: widget.subtitle.isNotEmpty
                ? Text(
                    widget.subtitle,
                    style: widget.subtitleTextStyle ??
                        Theme.of(context).textTheme.titleSmall,
                  )
                : null,
            enabled: widget.enabled,
            onTap: widget.onTap,
            trailing: widget.child,
            dense: true,
            isThreeLine:
                widget.subtitle.isNotEmpty && widget.subtitle.length > 70,
          ),
          _CustomSettingsTileDivider(),
        ],
      ),
    );
  }
}

class _CustomSettingsTileDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: Theme.of(context).dividerColor,
    );
  }
}
