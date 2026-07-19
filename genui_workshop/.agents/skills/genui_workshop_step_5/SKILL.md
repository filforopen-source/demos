---
name: genui_workshop_step_5
description: Execute Step 5 of the GenUI Workshop, integrating the GenUI package into the Flutter app.
---

# GenUI Workshop - Step 5

**Goal**: Execute Step 5 of the GenUI workshop.

**Instructions**:
Use your code editing tools to apply the following updates to the existing files to integrate the GenUI package. Overwrite the files with the contents below.

1. Overwrite `lib/genui_utils.dart` to include the `SurfaceItem` class:
```dart
sealed class ConversationItem {}

class TextItem extends ConversationItem {
  final String text;
  final bool isUser;
  TextItem({required this.text, this.isUser = false});
}

class SurfaceItem extends ConversationItem {
  final String surfaceId;
  SurfaceItem({required this.surfaceId});
}

const systemInstruction = '''
  ## PERSONA
  You are a meteorologist.

  ## GOAL
  Work with me to produce of weather forecasts.

  ## RULES

  Do not offer opinions unless I ask for them.

  ## PROCESS
  ### Planning
  *   Ask me for a location to check the weather.
  *   Follow up and ask for a date if not provided.
  *   Synthesize a list of weather forecasts from the provided information.
  *   Where available, you will use tool calls to retreive the info (not implemented yet)
  *   Advise if you are pulling the data from a real source or making it up.
  *   Ask clarifying questions if you need to.
  *   Respond to my suggestions for changes to date or location, if I have any.
''';
```

2. Overwrite `lib/main.dart` with the complete GenUI-integrated code:
```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:genui_workshop/message_bubble.dart';
import 'package:genui_workshop/genui_utils.dart';
import 'package:genui/genui.dart' hide TextPart;
import 'package:genui/genui.dart' as genui;
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Today',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<ConversationItem> _items = [];
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  late final ChatSession _chatSession;

  late final SurfaceController _controller;
  late final A2uiTransportAdapter _transport;
  late final Conversation _conversation;
  late final Catalog catalog;

  @override
  void initState() {
    super.initState();
    final model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-3.1-flash-lite',
    );
    _chatSession = model.startChat();
    
    catalog = BasicCatalogItems.asCatalog().copyWith(
      // newItems: [weatherInput, weatherCard],
    );

    _controller = SurfaceController(catalogs: [catalog]);
    _transport = A2uiTransportAdapter(onSend: _sendAndReceive);
    _conversation = Conversation(
      controller: _controller,
      transport: _transport,
    );

    _conversation.events.listen((event) {
      setState(() {
        switch (event) {
          case ConversationSurfaceAdded added:
            _items.add(SurfaceItem(surfaceId: added.surfaceId));
            _scrollToBottom();
          case ConversationSurfaceRemoved removed:
            _items.removeWhere(
              (item) =>
                  item is SurfaceItem && item.surfaceId == removed.surfaceId,
            );
          case ConversationContentReceived content:
            _items.add(TextItem(text: content.text, isUser: false));
            _scrollToBottom();
          case ConversationError error:
            debugPrint('GenUI Error: ${error.error}');
          default:
        }
      });
    });

    final promptBuilder = PromptBuilder.chat(
      catalog: catalog,
      systemPromptFragments: [systemInstruction],
    );

    _conversation.sendRequest(
      ChatMessage.system(promptBuilder.systemPromptJoined()),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _addMessage() async {
    final text = _textController.text;

    if (text.trim().isEmpty) {
      return;
    }

    _textController.clear();

    setState(() {
      _items.add(TextItem(text: text, isUser: true));
    });

    _scrollToBottom();

    await _conversation.sendRequest(ChatMessage.user(text));
  }

  Future<void> _sendAndReceive(ChatMessage msg) async {
    final buffer = StringBuffer();

    for (final part in msg.parts) {
      if (part.isUiInteractionPart) {
        buffer.write(part.asUiInteractionPart!.interaction);
        print(part.asUiInteractionPart!.interaction);
      } else if (part is genui.TextPart) {
        buffer.write(part.text);
      }
    }

    if (buffer.isEmpty) {
      return;
    }

    final text = buffer.toString();
    final response = await _chatSession.sendMessage(Content.text(text));

    if (response.text?.isNotEmpty ?? false) {
      _transport.addChunk(response.text!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Weather'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                for (final item in _items)
                  switch (item) {
                    TextItem() => MessageBubble(
                      text: item.text,
                      isUser: item.isUser,
                    ),
                    SurfaceItem() => Surface(
                      surfaceContext: _controller.contextFor(
                        item.surfaceId,
                      ),
                    ),
                  },
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      onSubmitted: (_) => _addMessage(),
                      decoration: const InputDecoration(
                        hintText: 'Enter a message',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addMessage,
                    child: const Text('Send'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```
