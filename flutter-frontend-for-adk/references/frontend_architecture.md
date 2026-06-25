# Frontend Architecture Reference

This document directs the agent or developer to define the technical implementation, data model schemas, and folder structures of the frontend, and record them in a root-level `FRONTEND_ARCHITECTURE_NOTES.md` file.

---

## Prerequisites

> [!IMPORTANT]
> Before defining the frontend architecture, the developer or coding agent **must** verify that both `AGENT_INTERFACE_NOTES.md` and `FRONTEND_USAGE_NOTES.md` exist in the root of the workspace. If either file is missing, **stop immediately** and run Phase 1 (Discovery) and Phase 2 (Usage & Behavior) first.
>
> Refer to these files throughout:
> - Use `AGENT_INTERFACE_NOTES.md` to identify custom state keys, sub-agent execution pathways, and payload JSON models.
> - Use `FRONTEND_USAGE_NOTES.md` to map user features and UI screens to notifier capabilities and concrete widget files.

---

## Instructions for Creating FRONTEND_ARCHITECTURE_NOTES.md

You must analyze the agent interface (documented in `AGENT_INTERFACE_NOTES.md`) and the frontend behavior (documented in `FRONTEND_USAGE_NOTES.md`) and compile a technical architecture specification called `FRONTEND_ARCHITECTURE_NOTES.md` in the root of the workspace.

This document must conform to the opinionated architectural constraints defined below, but adapt them to the specific backend agent by providing concrete Dart classes, file names, API payloads, and state properties.

Create `FRONTEND_ARCHITECTURE_NOTES.md` containing the following sections:

### 1. Architectural Patterns & Core Guidelines
Document the target architectural patterns, which must follow:
*   **Layered separation of concerns:**
    *   *UI Layer:* Pure Flutter widgets observing state.
    *   *State Layer:* Single central `ChangeNotifier` managing connection, history lists, stream events, and active states.
    *   *Service Layer:* Wraps standard cross-platform `package:http` API calls (avoiding native `dart:io` or platform-specific web libraries) to manage connection lifecycles and SSE chunk processing.
    *   *Model Layer:* Plain Dart classes using manual JSON serialization.
*   **SSE streaming parser:** Use a custom connection stream reading raw line-by-line chunks from the HTTP client streamed response.
*   **Approved Packages:** List approved packages (`provider`, `flutter_markdown`, `url_launcher`, and `http`). Check with the user before suggesting any additional third-party dependencies.

### 2. Concrete Directory Scaffold
Create a listing of all specific files and folder structures to be scaffolded under `lib/` matching the target agent's workflow. Give exact filenames instead of placeholders:
*   `lib/main.dart` - Entrypoint, theme, and provider initialization.
*   `lib/config.dart` - Config values containing the backend API host/port.
*   `lib/models/` - List specific model files (e.g. `session.dart`, `event.dart`, and custom models derived from the agent's state structure, such as `research_goal.dart`, `source_citation.dart`).
*   `lib/services/` - Specific service files (e.g. `adk_api_service.dart`).
*   `lib/providers/` - Specific state notifier files (e.g. `agent_provider.dart`).
*   `lib/ui/` - Specific screens and widget files matching the layout specification.

### 3. Concrete Model Serialization Blueprints
Provide the exact Dart class declarations and manual JSON deserialization factories (`fromJson` / `toJson`) for:
*   **Generic Envelope Models:** Standard ADK `Session`, `Event`, and `EventActions` envelopes.
*   **Agent-Specific Custom Models:** Inspect `AGENT_INTERFACE_NOTES.md` Section 6 (State & Artifact Management) and map **every** state key listed there to an explicit typed model property in the `Session` model. For example, if the agent uses a `sources` state dictionary to track research sources to cite, define a typed `SourceCitation` class to match. Detail exactly how the `Session.fromJson` factory extracts and deserializes all of these structures.

### 4. ChangeNotifier State & Action Map
Specify the exact instance variables and methods to be defined in the central `ChangeNotifier` to support the user experience described in `FRONTEND_USAGE_NOTES.md`:
*   **State Fields:** List variable types and names (e.g. `List<Session> sessions`, `Session? activeSession`, `bool isExecuting`, `String? errorMessage`, etc.).
*   **Action Methods:** List specific method names and signatures (e.g. `Future<void> fetchSessionHistory()`, `Future<void> deleteSession(String id)`, `Stream<Event> startAgentRun(String prompt)`, `void handleApprovalFeedback(String message)`).

### 5. Stream Connection & Error Handling Logic
Detail how the service and state provider coordinate during streaming:
*   Outline the SSE chunk reading process (decoding byte chunks, splitting lines, yielding decoded data frames).
*   Specify how connection interruptions or server errors (e.g. non-200 responses) are propagated to the state provider to set `errorMessage` and transition state safely.

---

## Architectural Guidelines Reference

To assist you in formulating the concrete blueprints inside `FRONTEND_ARCHITECTURE_NOTES.md`, refer to the following standard code patterns:

### A. Raw package:http SSE Parser Pattern
The client uses `http.Client` from `package:http` to stream and parse raw SSE chunks:
```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

// Core connection logic:
final client = http.Client();
final request = http.Request('POST', Uri.parse('$baseUrl/run_sse'));
request.headers['Content-Type'] = 'application/json';
request.headers['Accept'] = 'text/event-stream';
request.body = jsonEncode(payload);

final streamedResponse = await client.send(request);
await for (final line in streamedResponse.stream
    .transform(utf8.decoder)
    .transform(const LineSplitter())) {
  final trimmed = line.trim();
  if (trimmed.startsWith('data:')) {
    final dataString = trimmed.substring(5).trim();
    // Parse JSON dataString into concrete Event models
  }
}
```

### B. Standard Session and Event Model Envelopes
ADK serialization payload structures use camelCase properties:
```dart
class Event {
  final String id;
  final String? invocationId;
  final String author;
  final String? contentText;
  final EventActions actions;
  final bool partial;
  final bool turnComplete;

  Event({
    required this.id,
    this.invocationId,
    required this.author,
    this.contentText,
    required this.actions,
    required this.partial,
    required this.turnComplete,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    String? extractedText;
    final content = json['content'];
    if (content != null && content['parts'] != null) {
      final List parts = content['parts'];
      if (parts.isNotEmpty && parts.first['text'] != null) {
        extractedText = parts.first['text'] as String;
      }
    }
    return Event(
      id: json['id'] as String,
      invocationId: json['invocationId'] as String?,
      author: json['author'] as String? ?? 'system',
      contentText: extractedText,
      actions: EventActions.fromJson(json['actions'] as Map<String, dynamic>? ?? {}),
      partial: json['partial'] as bool? ?? false,
      turnComplete: json['turnComplete'] as bool? ?? false,
    );
  }
}

class EventActions {
  final Map<String, dynamic> stateDelta;
  final bool endOfAgent;

  EventActions({
    required this.stateDelta,
    required this.endOfAgent,
  });

  factory EventActions.fromJson(Map<String, dynamic> json) {
    return EventActions(
      stateDelta: json['stateDelta'] as Map<String, dynamic>? ?? {},
      endOfAgent: json['endOfAgent'] as bool? ?? false,
    );
  }
}
```

### C. Standard REST Endpoints Pattern
The client uses standard `package:http` methods for pings, lists, creates, and deletes:
```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AdkApiService {
  final String baseUrl;
  final http.Client _client = http.Client();

  AdkApiService({required this.baseUrl});

  /// GET /health
  Future<bool> pingServer() async {
    try {
      final response = await _client.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// GET /apps/app/users/default_user/sessions
  Future<List<Session>> getSessions() async {
    final response = await _client.get(
      Uri.parse('$baseUrl/apps/app/users/default_user/sessions'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch sessions: ${response.statusCode}');
    }
    final List decodedList = jsonDecode(response.body);
    return decodedList
        .map((item) => Session.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// POST /apps/app/users/default_user/sessions
  Future<Session> createSession() async {
    final response = await _client.post(
      Uri.parse('$baseUrl/apps/app/users/default_user/sessions'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({}), // Send empty payload
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create session: ${response.statusCode}');
    }
    return Session.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// DELETE /apps/app/users/default_user/sessions/{session_id}
  Future<void> deleteSession(String sessionId) async {
    final response = await _client.delete(
      Uri.parse('$baseUrl/apps/app/users/default_user/sessions/$sessionId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete session: ${response.statusCode}');
    }
  }
}
```
