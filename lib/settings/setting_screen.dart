import '../droplet_repo.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _tokenController;
  late SharedPreferences pref;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _dpInstance = DigitalDroplet.instance;
  final _focusNode = FocusNode();

  bool tokenHidden = true;
  bool tokenExist = false;
  bool isVerified = false;
  bool isEditing = false;
  String? errorText;

  @override
  void initState() {
    dev.log("RUnning init settings");
    _tokenController = TextEditingController();
    // _tokenController.addListener()
    // _focusNode.requestFocus();
    setToken();
    super.initState();
  }

  String? getToken() {
    return pref.getString("auth_token");
  }

  setToken() async {
    String obscuredText = "";
    pref = await SharedPreferences.getInstance();

    final token = getToken();
    if (token != null) {
      obscuredText = token.replaceRange(5, token.length - 4, "x" * 20);
    }
    setState(() {
      if (obscuredText.isNotEmpty) {
        tokenExist = true;
        tokenHidden = false;
        isVerified = true;
      }
      _tokenController.text = obscuredText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _tokenController,
                maxLines: 3,
                minLines: 1,
                readOnly: tokenExist,
                autofocus: false,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  errorText: errorText,
                  border: const OutlineInputBorder(),
                  suffixIcon: isVerified
                      ? const Icon(
                          Icons.verified,
                          color: Colors.green,
                        )
                      : null,
                ),
                validator: (token) =>
                    token == null || token.isEmpty || token.length < 16
                        ? "Invalid Token"
                        : null,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                        onPressed: !tokenExist && !isEditing
                            ? null
                            : () {
                                isEditing
                                    ? setState(() {
                                        _focusNode.unfocus();
                                        isEditing = false;
                                        setToken();
                                      })
                                    : setState(() {
                                        isEditing = true;
                                        tokenExist = false;
                                        isVerified = false;
                                        _tokenController.text =
                                            getToken() ?? "";
                                        _focusNode.requestFocus();
                                      });
                              },
                        child: Text(isEditing ? "Cancel" : "Edit Token")),
                    const SizedBox(
                      width: 16.0,
                    ),
                    FilledButton(
                      onPressed: tokenExist
                          ? null
                          : () async {
                              bool? isValid = _formKey.currentState?.validate();

                              if (isValid != null && isValid) {
                                isValid = await _dpInstance
                                    .isValidUser(_tokenController.text);
                                if (!isValid) {
                                  setState(() {
                                    errorText = "Invalid Token";
                                  });
                                } else {
                                  setState(() {
                                    isVerified = true;
                                  });
                                }
                              }
                            },
                      child: const Text(
                        "Validate Token",
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _focusNode.unfocus();
    super.dispose();
  }
}
