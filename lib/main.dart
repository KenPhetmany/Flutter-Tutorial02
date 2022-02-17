import 'package:flutter/material.dart';

void main() {
  runApp(const FriendlyChatApp());
}

String _name = 'Ken';

class FriendlyChatApp extends StatelessWidget {
  const FriendlyChatApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'FriendlyChat',
      home: ChatScreen(),
    );
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    required this.text,
    required this.animationController,
    Key? key,
  }) : super(key: key);
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            // Displays the Avatar of the user.
            crossAxisAlignment:
                CrossAxisAlignment.start, // Position the Avatar and messages
            // relative to their parent widgets. This one, since the parent is a Row whose main axis is the horizontal, they are
            // positoned the highest  along the vertical axis
            children: [
              Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                    child: Text(_name[
                        0])), // The user's Avatar as a circle including their name.
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Positon the components relative to their parent widget.
                // Since the parent is a Column whose main axis is vertical, they are positioned the highest along the horizontal
                children: [
                  Text(_name,
                      style: Theme.of(context)
                          .textTheme
                          .headline4), // Default Flutter ThemeData for the app.
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  )
                ],
              )
            ],
          )),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    for (var message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    var message = ChatMessage(
      text: text,
      animationController: AnimationController(
        // Attached to a new message instance so the animation will occur
        duration: const Duration(milliseconds: 700),
        vsync: this, // Required.
      ),
    );
    setState(() {
      // Lets the framework know that this part of the widget tree changed and will need to be rebuilt
      _messages.insert(0, message);
    });
    _focusNode.requestFocus();
    message.animationController.forward();
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal:
                8.0), // Translates the value into a specific number of pixels relative to the
        // device.
        child: Row(
          // Row allows us to put the send button next to the input field.
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    const InputDecoration.collapsed(hintText: 'Send a message'),
                focusNode: _focusNode,
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                  // Send Button
                  icon: const Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text),
                ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('FriendlyChat'),
        ),
        body: Column(children: [
          // Contains the list of messages and the input field and send button
          Flexible(
            // Expand the list of messages while the input field remains the same.
            child: ListView.builder(
              // Builds a list on demand by providing a function that returns a new widget on each call
              // Automatically detects any children parameter.
              padding:
                  const EdgeInsets.all(8.0), // White space around the message.
              reverse: true,
              itemBuilder: (_, index) =>
                  _messages[index], // Builds each widget in [index]
              itemCount: _messages.length,
            ),
          ),
          const Divider(height: 1.0),
          Container(
            // Part of the text composer
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor), // Defines background color
            child: _buildTextComposer(),
          ),
        ]));
  }
}
