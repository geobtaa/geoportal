<img src="https://avatars2.githubusercontent.com/u/6412038?v=3&s=200" alt="react logo" title="react" align="right" width="64" height="64" />

# react-dnd-touch-backend

[![npm version](https://badge.fury.io/js/react-dnd-touch-backend.svg)](http://badge.fury.io/js/react-dnd-touch-backend)
[![Dependency Status](https://david-dm.org/yahoo/react-dnd-touch-backend.svg)](https://david-dm.org/yahoo/react-dnd-touch-backend)
[![devDependency Status](https://david-dm.org/yahoo/react-dnd-touch-backend/dev-status.svg)](https://david-dm.org/yahoo/react-dnd-touch-backend#info=devDependencies)
![gzip size](http://img.badgesize.io/https://npmcdn.com/react-dnd-touch-backend?compression=gzip)

Touch Backend for [react-dnd](https://github.com/gaearon/react-dnd)

## Instalation

npm:

```bash
 npm install react-dnd-touch-backend --save
```

yarn:

```bash
 yarn add react-dnd-touch-backend
```


## Usage
Follow [react-dnd docs](http://gaearon.github.io/react-dnd/) to setup your app. Then swap out `HTML5Backend` for `TouchBackend` as such:

```js
import React, { Component } from 'react';
import TouchBackend from 'react-dnd-touch-backend';
import { DragDropContext } from 'react-dnd';

class YourApp extends Component {
  /* ... */
}

export default DragDropContext(TouchBackend)(YourApp);
```

### Options

You have the following options available to you, which you can pass in like so:

```js
DragDropContext(TouchBackend(options))
```

Options include:

- enableTouchEvents
- enableMouseEvents
- enableKeyboardEvents
- delayTouchStart
- delayMouseStart
- touchSlop
- ignoreContextMenu
- scrollAngleRanges
- enableHoverOutsideTarget

## Tips
### Drag Preview
Since native Drag-n-Drop is not currently supported in touch devices. A custom [DragPreview](https://react-dnd.github.io/react-dnd/examples/drag-around/custom-drag-layer) is required. Check out the [example](https://github.com/yahoo/react-dnd-touch-backend/blob/master/examples/dropTarget/js/DragPreview.jsx) for a sample implementation.

We might try to build it directly in the Backend itself in the future to compensate for this limitation.

### Mouse events support*
You can enable capturing mouse events by configuring your TouchBackend as follows:
```js
DragDropContext(TouchBackend({ enableMouseEvents: true }));
```
**NOTE*: This is buggy due to the difference in `touchstart/touchend` event propagation compared to `mousedown/mouseup/click`. I highly recommend that you use [react-dnd-html5-backend](https://github.com/gaearon/react-dnd-html5-backend) instead for a more performant native HTML5 drag capability.**

### Other options
**touchSlop**

* Specifies the pixel distance moved before a drag is signaled.
* Default: 0
```js
DragDropContext(TouchBackend({ touchSlop: 20 }));
```
**ignoreContextMenu**

* If true, prevents the `contextmenu` event from canceling a drag.
* Default: false
```js
DragDropContext(TouchBackend({ ignoreContextMenu: true }));
```

**scrollAngleRanges**

* Specifies ranges of angles in degrees that drag events should be ignored. This is useful when you want to allow the 
user to scroll in a particular direction instead of dragging. Degrees move clockwise, 0/360 pointing to the 
left. 
* Default: undefined
```js
// allow vertical scrolling
DragDropContext(TouchBackend({ scrollAngleRanges: [{ start: 30, end: 150 }, { start: 210, end: 330 }] }));

// allow horizontal scrolling
DragDropContext(TouchBackend({ scrollAngleRanges: [{ start: 300 }, { end: 60 }, { start: 120, end: 240 }] }));
```

**enableHoverOutsideTarget**

* Continue dragging of currently dragged element when pointer leaves DropTarget area
* Default: undefined
```js
DragDropContext(TouchBackend({ enableHoverOutsideTarget: true }));
```

**getDropTargetElementsAtPoint**
* Specify a custom function to find drop target elements at the given point.  Useful for improving performance in environments (iOS Safari) where document.elementsFromPoint is not available.
* Default: undefined (use document.elementsFromPoint or inline elementsFromPoint "polyfill")
```js
const hasNative = document && (document.elementsFromPoint || document.msElementsFromPoint);

function getDropTargetElementsAtPoint(x, y, availableDropTargets) {
  return dropTargets.filter(t => {
    const rect = t.getBoundingClientRect();
    return (x >= rect.left && x <= rect.right && 
            y <= rect.bottom && y >= rect.top);
  });
}

// use custom function only if elementsFromPoint is not supported 
DragDropContext(TouchBackend({
  getDropTargetElementsAtPoint: !hasNative && getDropTargetElementsAtPoint,
}))
```

## Examples
The `examples` folder has a sample integration. In order to build it, run:

npm:

```bash
npm i && npm run dev
```

yarn:

```bash
yarn install && yarn run dev
```

Then navigate to `localhost:7789` or `(IP Address):7789` in your mobile browser to access the example.
Code licensed under the MIT license. See LICENSE file for terms.
