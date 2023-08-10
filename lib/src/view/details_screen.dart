import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_user/src/constant/widgets/common_text.dart';
import 'package:get_user/src/constant/widgets/common_text_form_field.dart';
import 'package:get_user/src/provider/database/cloud_database.dart';
import 'package:get_user/src/provider/model/model.dart';
import 'package:get_user/src/utils/media_query.dart';

class DetailScreen extends StatefulWidget {
  final Note note;
  final String doc;
  final bool isAdd;
  const DetailScreen({
    super.key,
    required this.note,
    required this.doc,
    required this.isAdd,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final GlobalKey<FormState> _noteKey = GlobalKey<FormState>();

  final StreamController _controller = StreamController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  final ValueNotifier<AutovalidateMode> _valueNotifier =
      ValueNotifier(AutovalidateMode.disabled);

  bool isLink = false;

  @override
  void initState() {
    _titleController.text = widget.note.title;
    _bodyController.text = widget.note.body;

    _controller.sink.add(widget.note.title);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: StreamBuilder(
          stream: _controller.stream,
          builder: (context, snapshot) => CommonText(
            text: snapshot.data.toString(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _valueNotifier.value = AutovalidateMode.onUserInteraction;
              if (_noteKey.currentState!.validate()) {
                if (widget.isAdd) {
                  FirebaseCloud.firebaseCloud.insertData(
                    note: Note(
                      title: _titleController.text,
                      body: _bodyController.text,
                    ),
                  );
                  Navigator.of(context).pop();
                } else {
                  FirebaseCloud.firebaseCloud.upDateData(doc: widget.doc, note: Note(
                      title: _titleController.text,
                      body: _bodyController.text,
                    ),);
                  Navigator.of(context).pop();
                }
              }
            },
            icon: const Icon(
              Icons.save,
              color: Colors.lightGreenAccent,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(26),
          child: SizedBox(
            width: (size(context: context).width >= 500)
                ? 500
                : size(context: context).width,
            child: ValueListenableBuilder(
              valueListenable: _valueNotifier,
              builder: (context, value, child) => Form(
                key: _noteKey,
                autovalidateMode: value,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CommonTextFormField(
                        controller: _titleController,
                        onChanged: (value) {
                          _controller.sink.add(value);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "enter title";
                          } else {
                            return null;
                          }
                        },
                        textInputType: TextInputType.text,
                        hintText: "Enter Title",
                        labelText: const CommonText(text: "Title"),
                      ),
                      SizedBox(
                        height: size(context: context).height * 0.02,
                      ),
                      CommonTextFormField(
                        maxLine: 4,
                        controller: _bodyController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "enter description";
                          } else {
                            return null;
                          }
                        },
                        textInputType: TextInputType.text,
                        hintText: "Body",
                        labelText: const CommonText(text: "Description"),
                      ),
                      SizedBox(
                        height: size(context: context).height * 0.02,
                      ),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: CommonText(text: "(Optinol) "),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
