
import 'package:flutter/material.dart';
import 'package:sportzstar/widgets/Layout/main_layout_widget.dart';
import 'package:sportzstar/widgets/custom_button.dart';

class ResetPasswordLayout extends StatelessWidget {
  ResetPasswordLayout({
    super.key,
    this.image,
    this.noImgSize = false,
    this.title,
    this.paragraph,
    required this.innerBody,
    this.submit,
    this.submitText,
    this.isLoading,
  });

  String? image;
  bool? noImgSize;
  String? title;
  String? paragraph;
  Widget innerBody;
  Function? submit;
  String? submitText;
  bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return MainLayoutWidget(
      
      isLoading: isLoading ?? false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Center(
          heightFactor: 1.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   image,
              //   width: noImgSize == true ? null : 80,
              // ),
              const SizedBox(
                height: 20,
              ),
              if (title != null)
                Text(
                  title ?? '',
                  style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              if (paragraph != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    paragraph ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              Container(
                child: innerBody,
              ),
              const SizedBox(
                height: 40,
              ),
              submit != null
                  ? CustomButton(
                      onPressed: () {
                        
                      },
                      text: 'Reset Password',
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}