import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mms/blocs/auth/auth_bloc.dart';
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

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class _MainScreenState extends State<MainScreen> {
  TextEditingController _inputController = TextEditingController();
  final _listController = ScrollController();
  late MessageCubit _messageCubit;

  @override
  void initState() {
    _messageCubit = BlocProvider.of<MessageCubit>(context);
    _getMessage();
    super.initState();
  }

  _getMessage() {
    BlocProvider.of<MessageCubit>(context).getMessages();
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
            actions: [ThemeButton(), _signOutButton],
          ),
          body: Column(
            children: [_mainListView(), _inputField()],
          ),
        ));
  }

  get _signOutButton => IconButton(onPressed: _showSignOutDialog, icon: Icon(Icons.logout));

  _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Sign out"),
          content: Text("Are you sure you want to sign out?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text("Confirm"),
              onPressed: () => _logout(dialogContext),
            ),
          ],
        );
      },
    );
  }

  _logout(BuildContext dialogContext) {
    Navigator.of(dialogContext).pop();
    BlocProvider.of<AuthCubit>(context).loggedOut();
  }

  _mainListView() => Expanded(
        child: BlocBuilder<MessageCubit, MessageState>(
          builder: (context, state) {
            if (state is MessageLoadInProgress)
              return SpinKitWave(color: Theme.of(context).accentColor, size: 25.0);
            else if (state is MessageLoadSuccess) return _messageListView(state.messages);
            return Center(
              child: Text('Something went wrong', style: Theme.of(context).textTheme.bodyText1),
            );
          },
        ),
      );

  _messageListView(List<Message> messages) {
    return ListView.builder(
        controller: _listController,
        padding: const EdgeInsets.all(20),
        itemBuilder: (BuildContext context, int index) {
          return _messageListItem(messages[index]);
        },
        itemCount: messages.length);
  }

  _messageListItem(Message msg) {
    bool isAuthor = msg.isAuthor;
    TextTheme textTheme = Theme.of(context).textTheme;
    return _popupMenu(msg, isAuthor,
        Row(
          mainAxisAlignment: isAuthor ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            SizedBox(width: isAuthor ? 0 : 50),
            Flexible(
                child: Container(
              margin: EdgeInsets.only(bottom: 5),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isAuthor ? 0 : 16),
                    bottomRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    topRight: Radius.circular(isAuthor ? 16 : 0)),
                color: isAuthor ? Theme.of(context).accentColor : Theme.of(context).highlightColor,
              ),
              child: Column(
                children: [
                  Text(msg.text, style: textTheme.bodyText2),
                  SizedBox(height: 10),
                  Row(children: [
                    Text(msg.userName, style: textTheme.bodyText1),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.circle, size: 5),
                    ),
                    Text(msg.time, style: textTheme.bodyText1)
                  ],)
                ],
              ),
            )),
            SizedBox(width: isAuthor ? 50 : 0),
          ],
        ));
  }

  _popupMenu(Message msg, isAuthor, Widget child) => PopupMenuButton(
      enabled: isAuthor,
      child: child,
      offset: Offset(0, 50),
      itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              child: Text("Edit"),
              value: 1,
            ),
            PopupMenuItem(
              child: Text("Delete"),
              value: 2,
            )
          ],
      onSelected: (value) => value == 1 ? _edit(msg) : _delete(msg));

  _edit(Message msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Message'),
          content: TextFormField(
            onChanged: (text) => msg.text = text,
            maxLength: MAX_MESSAGE_LENGTH,
            initialValue: msg.text,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Update'),
              onPressed: () {
                Navigator.of(context).pop();
                _messageCubit.addMessage(msg);
              },
            ),
          ],
        );
      },
    );
  }

  _delete(Message msg) {
    _messageCubit.deleteMessage(msg);
  }

  _inputField() => Container(
        padding: EdgeInsets.all(15),
        color: Theme.of(context).bottomAppBarColor,
        child: Row(
          children: [
            Expanded(
                child: TextFormField(
                    controller: _inputController,
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
    _messageCubit.addMessage(Message(text: _inputController.text, date: DateTime.now()));
    _inputController.clear();
    _scrollToTop();
  }

  _scrollToTop() {
    _listController.animateTo(
      0.0,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }
}
