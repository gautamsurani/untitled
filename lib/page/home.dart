import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/bloc/home_bloc.dart';
import 'package:untitled/bloc/home_state.dart';
import 'package:untitled/constant/locale_constant.dart';
import 'package:untitled/language/languages.dart';
import 'package:untitled/widget/code_dialog.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Home> {
  HomeBloc? bloc;
  TextEditingController codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc = HomeBloc();
    bloc!.callSymbols();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          Languages.of(context)!.appName,
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'English', 'French'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: BlocProvider<HomeBloc>(
        create: (context) => bloc!,
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (_, count) {
            return Center(
              child: bloc!.state.loading
                  ? CircularProgressIndicator()
                  : Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => _openDialog(),
                          child: Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            height: 50,
                            color: Colors.grey[200],
                            child: Center(
                                child: Text(bloc!.state.symbolDetail == null
                                    ? Languages.of(context)!.labelSelectCode
                                    : bloc!.state.symbolDetail!.code!)),
                          ),
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  color: Colors.grey[200],
                                  child: TextFormField(
                                    controller: codeController,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            left: 15,
                                            bottom: 0,
                                            top: 0,
                                            right: 15),
                                        hintText: Languages.of(context)!.labelEnterCountryCode,
                                        hintStyle: TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                        focusedBorder: InputBorder.none,
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: _submit,
                                child: Container(
                                  color: Theme.of(context).primaryColor,
                                  padding: EdgeInsets.only(left: 15, right: 15),
                                  child: Center(
                                    child: Text(
                                      Languages.of(context)!.labelSubmit,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        bloc!.state.symbolDetail != null
                            ? Container(
                                margin: EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('1 '+
                                        bloc!.state.symbolDetail!.base!),
                                    Text(Languages.of(context)!.labelIsEquivalent),
                                    Text(bloc!.state.symbolDetail!
                                        .rates![bloc!.state.symbolDetail!.code!]
                                        .toString() +" "+ bloc!.state.symbolDetail!.code!)
                                  ],
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.all(20),
                                child: Center(child: Text(bloc!.state.errorMessage!=null?bloc!.state.errorMessage!:Languages.of(context)!.labelNoDataAvailable)),
                              )
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }

  void _submit() {
    bloc!.callSymbolDetail(codeController.text.toUpperCase());
  }

  _openDialog() {
    FocusScope.of(context).requestFocus(new FocusNode());
    showDialog(
        context: context,
        builder: ((BuildContext context) {
          return CodeDialog(
              title: Languages.of(context)!.labelSubmit,
              symbols: bloc!.state.symbols!.symbols!,
              onSymbolsClick: (response) {
                bloc!.callSymbolDetail(response);
              });
        }));
  }

  void handleClick(String value) {
    switch (value) {
      case 'English':
        changeLanguage(context,'en');
        break;
      case 'French':
        changeLanguage(context,'fr');
        break;
    }
  }
}
