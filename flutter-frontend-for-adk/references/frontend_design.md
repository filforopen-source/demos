# Frontend Design & Layout Reference

This document directs the agent or developer to define the visual style, theming, responsive layouts, and interactive behaviors of the frontend, and record them in a root-level `FRONTEND_DESIGN_NOTES.md` file.

---

## Prerequisites

> [!IMPORTANT]
> Before defining the frontend design, the developer or coding agent **must** verify that `AGENT_INTERFACE_NOTES.md`, `FRONTEND_USAGE_NOTES.md`, and `FRONTEND_ARCHITECTURE_NOTES.md` exist in the root of the workspace. If any of these files are missing, **stop immediately** and complete the earlier phases first.
>
> Refer to these files throughout:
> - Use `AGENT_INTERFACE_NOTES.md` to understand the target agent itself (its core purpose, sub-agent catalog, and execution lifecycle) so that you can design custom visual indicators and timeline transitions that accurately reflect the running backend workflow.
> - Use `FRONTEND_USAGE_NOTES.md` to identify the required screens, features, and conversational sequences that need design specs.
> - Use `FRONTEND_ARCHITECTURE_NOTES.md` to align screen designs and widget layout divisions with the technical file structure (e.g. matching `dashboard_screen.dart` and custom widgets).

---

## Instructions for Creating FRONTEND_DESIGN_NOTES.md

### Step 1: Collect User Design Preferences
Before writing the design notes, the coding agent **must** present a set of options to the user in the chat and ask for their preferences. Do not assume or decide on these values without user input. Ask the user for their preferences on these topics:

1.  **Visual Theme & Tone**
2.  **Primary Accent Color**
3.  **Typography & Font Choices**
4.  **Animations & Motion Style**

Suggest some pre-generated options for each one based on the notes in `FRONTEND_USAGE_NOTES.md`, but allow the user to specify something else.

---

### Step 2: Analyze the Agent's Screens & Adapt Layouts
Read `FRONTEND_USAGE_NOTES.md` Section 3 (Screen Specifications) to identify the specific screens, panels, drawers, or views that this specific agent requires. 
Do not assume a standard 3-column split view; adapt your visual layout to the specific screens defined by the user's agent.

---

### Step 3: Write FRONTEND_DESIGN_NOTES.md
Create `FRONTEND_DESIGN_NOTES.md` in the root of the project containing the following sections, using the user's responses from Step 1 and the screens analyzed in Step 2:

#### 1. Global Theme & Visual Style
Specify the exact theme configurations for the application:
*   **Color Palette:** Define the HEX values and Flutter color codes (`0xFF...`) for:
    *   *App Background:* Main scaffold background canvas.
    *   *Surface Background:* Lighter background for cards, sidebars, and input overlays.
    *   *Accent Primary:* Vibrant highlight color for primary actions, sliders, or active progress steps (based on the user's accent preference).
    *   *Accent Glow/Secondary:* Auxiliary highlight color for alerts or success indicators.
    *   *Text Primary:* Highly legible font color for headings, text inputs, and outputs.
    *   *Text Secondary:* Muted font color for helper labels and timestamp metadata.
    *   *Borders / Dividers:* Subtle boundary lines separating layout panes.
*   **Typography Hierarchy:** Outline the chosen font families, font sizes, weights, and line-heights (optimized for readability based on the user's font preferences).
*   **Visual Enhancements:** Shadow parameters (`BoxShadow` values), border radii (typically `12px` for modern cards, `8px` for inputs), and overlay opacities.
*   **Accessibility Design:** Define guidelines for:
    *   Supporting system text-scaling preferences (preventing text clipping or overflow).
    *   Ensuring AA/AAA contrast ratios for text on active surfaces.
    *   Minimum touch/tap target sizes (minimum `48x48` logical pixels for mobile/tablet platforms).

#### 2. Screen Specifications & Route Navigation
Define the routes, navigation patterns, and panel layouts for the specific screens derived in Step 2:
*   **Routing Scheme:** Specify route paths and names (e.g., `/` for Dashboard, `/settings` for settings).
*   **Screen Layout Structure:** Explain how the screen real estate is shared among the agent-specific panels on widescreen/desktop layouts.

#### 3. Screen Breakpoints & Adaptive Layouts
Detail exactly how the app reflows the agent-specific panels across different screen widths:
*   **Breakpoint Definitions:**
    *   *Desktop / Widescreen:* Width `>= 1024px` (All major panels visible side-by-side).
    *   *Tablet / Medium:* Width `< 1024px` and `>= 600px` (Sidebar collapses into a drawer, panels share remaining split space).
    *   *Mobile:* Width `< 600px` (Single column; reflows split panels into tabbed navigation pages or bottom sheets).
*   **Platform Adaptations:** Design adjustments for target platforms (e.g., scrollbars and mouse-hover states for Desktop/Web, safe area margins and touch gestures for Mobile/iOS/Android).

#### 4. Interactive Components & Micro-animations
Define states and animations matching the user's motion preference (Step 1) for the custom widgets:
*   **Active Processing Indicators:** Pulse animations or loading spinners representing running agent states.
*   **Hover & Active Highlights:** Visual feedback (scale, color shifts, opacity changes) when hovering or clicking buttons, cards, and links.
*   **Content Transitions:** Smooth opacity fades (`FadeIn`) or sliding animations (`SlideTransition`) for streaming content blocks, plan checklists, or new message feeds.

---

## Design Reference Guidelines

Use the following code definitions as standard implementation patterns when writing `FRONTEND_DESIGN_NOTES.md`:

### A. Dark Mode Material ThemeData Definition
```dart
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0B0F19),
  cardColor: const Color(0xFF131926),
  primaryColor: const Color(0xFF6366F1),
  dividerColor: const Color(0xFF1E293B),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFF8FAFC)),
    bodyMedium: TextStyle(fontSize: 15, height: 1.5, color: Color(0xFF94A3B8)),
  ),
);
```

### B. Responsive Layout Implementation Pattern
Use `LayoutBuilder` to dynamically reflow the UI columns based on screen width:
```dart
Widget build(BuildContext context) {
  return Scaffold(
    body: LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1024) {
          // Desktop: Show sidebar and panels side-by-side
          return Row(
            children: [
              const SidebarWidget(width: 260),
              Expanded(child: ChatPanelWidget()),
              Expanded(child: WorkspacePanelWidget()),
            ],
          );
        } else if (constraints.maxWidth >= 600) {
          // Tablet: Collapsible sidebar, side-by-side panels
          return Row(
            children: [
              Expanded(child: ChatPanelWidget()),
              Expanded(child: WorkspacePanelWidget()),
            ],
          );
        } else {
          // Mobile: Single panel with tab navigation
          return MobileTabbedView();
        }
      },
    ),
  );
}
```
