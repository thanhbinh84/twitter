import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mms/blocs/message/message_cubit.dart';
import 'package:mms/blocs/message/message_states.dart';
import 'package:mms/common/utils.dart';
import 'package:mms/data/models/message.dart';
import 'package:mms/views/widgets/theme_button.dart';

class MainScreen extends StatefulWidget {
  MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MessageCubit _messageCubit;
  TextEditingController _textEditingController = TextEditingController();
  final _controller = ScrollController();

  @override
  void initState() {
    _messageCubit = BlocProvider.of<MessageCubit>(context);
    _getMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessageCubit, MessageState>(
        listener: (context, state) {
          if (state is MessageFailure) Utils.errorToast(state.error);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Simple Twitter'),
            actions: [ThemeButton()],
          ),
          body: _mainView(),
        ));
  }

  _mainView() {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<MessageCubit, MessageState>(
            builder: (context, state) {
              if (state is MessageLoadInProgress)
                return SpinKitWave(color: Theme.of(context).accentColor, size: 25.0);
              else if (state is MessageLoadSuccess)
                return ListView.builder(
                    controller: _controller,
                    padding: const EdgeInsets.all(20),
                    itemBuilder: (BuildContext context, int index) {
                      Message msg = state.messages[index];
                      return Row(
                          mainAxisAlignment: msg.isReceived ? MainAxisAlignment.start : MainAxisAlignment.end,
                          children: [
                            SizedBox(width: msg.isReceived ? 0 : 50),
                            Flexible(
                                child: Container(
                              margin: EdgeInsets.only(bottom: 5),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(msg.isReceived ? 0 : 16),
                                    bottomRight: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                    topRight: Radius.circular(!msg.isReceived ? 0 : 16)),
                                color: msg.isReceived
                                    ? Theme.of(context).highlightColor
                                    : Theme.of(context).accentColor,
                              ),
                              child: Text(msg.text, style: TextStyle(fontSize: 16, color: Colors.white)),
                            )),
                            SizedBox(width: msg.isReceived ? 50 : 0)
                          ]);
                    },
                    itemCount: state.messages.length);
              return Center(
                child: Text('Something went wrong', style: Theme.of(context).textTheme.bodyText1),
              );
            },
          ),
        ),
        _textInputField()
      ],
    );
  }

  _textInputField() => Container(
        padding: EdgeInsets.all(15),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
                child: TextFormField(
                    controller: _textEditingController,
                    maxLength: MAX_MESSAGE_LENGTH,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                    ))),
            SizedBox(width: 15),
            IconButton(icon: Icon(Icons.send), onPressed: _send)
          ],
        ),
      );

  _send() {
    String msg = _textEditingController.text;
    _messageCubit.addMessage(Message(date: DateTime.now(), text: msg));
    _textEditingController.clear();
    setState(() {});
    _scrollToTop();
  }

  _getMessage() {
    _messageCubit.getMessages();
  }

  _scrollToTop() {
    _controller.animateTo(
      0.0,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }
}
