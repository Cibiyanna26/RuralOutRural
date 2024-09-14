import 'package:flutter/material.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/models/chat_message.dart';
import 'package:reach_out_rural/utils/size_config.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    super.key,
    this.message,
  });

  final ChatMessage? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.getProportionateScreenWidth(250),
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0 * 0.75,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(message!.isSender ? 1 : 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message!.text,
          style: TextStyle(
            color: message!.isSender
                ? kWhiteColor
                : Theme.of(context).textTheme.bodyLarge!.color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
