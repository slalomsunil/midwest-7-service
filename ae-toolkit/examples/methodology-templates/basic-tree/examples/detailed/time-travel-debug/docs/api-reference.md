# Time Travel Debug API Reference

## TimelineManager

### Constructor
```typescript
new TimelineManager(options?: TimelineOptions)
```

### Methods

#### `capture(point: string, state: any): void`
Captures current application state at specified execution point.

#### `travelTo(timestamp: number): Promise<void>`
Navigates to specific timestamp in execution history.

#### `getCurrentState(): StateSnapshot | null`
Returns current state snapshot or null if none exists.

#### `getTimeline(): TimelineEntry[]`
Returns complete execution timeline.

## StateCapture

### Methods

#### `serialize(state: any): SerializedState`
Serializes application state for storage.

#### `deserialize(state: SerializedState): any`
Deserializes stored state back to original form.

#### `createSnapshot(): StateSnapshot`
Creates complete state snapshot of current application state.

## NavigationInterface

### Events

#### `onTimelineChange(callback: (timeline: TimelineEntry[]) => void)`
Fired when timeline is updated with new entries.

#### `onStateChange(callback: (state: StateSnapshot) => void)`
Fired when current state changes due to navigation.

#### `onNavigationError(callback: (error: NavigationError) => void)`
Fired when navigation fails or encounters errors.

### UI Components

#### `<TimelineViewer />`
Visual timeline component showing execution history.

#### `<StateInspector />`
Component for inspecting current state values.

#### `<NavigationControls />`
Play/pause/step controls for temporal navigation.

## Configuration

```typescript
interface TimelineOptions {
  maxSnapshots?: number;
  captureInterval?: number;
  enableStateCompression?: boolean;
  customSerializer?: StateSerializer;
}
```