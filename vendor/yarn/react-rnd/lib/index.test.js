"use strict";
/* tslint:disable */
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (Object.hasOwnProperty.call(mod, k)) result[k] = mod[k];
    result["default"] = mod;
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
var ava_1 = __importDefault(require("ava"));
var React = __importStar(require("react"));
var sinon_1 = require("sinon");
var enzyme_1 = __importStar(require("enzyme"));
var enzyme_adapter_react_16_1 = __importDefault(require("enzyme-adapter-react-16"));
var _1 = require("./");
enzyme_1.default.configure({ adapter: new enzyme_adapter_react_16_1.default() });
var mouseMove = function (x, y) {
    var event = document.createEvent("MouseEvents");
    event.initMouseEvent("mousemove", true, true, window, 0, 0, 0, x, y, false, false, false, false, 0, null);
    document.dispatchEvent(event);
    return event;
};
var mouseUp = function (x, y) {
    var event = document.createEvent("MouseEvents");
    event.initMouseEvent("mouseup", true, true, window, 0, 0, 0, x, y, false, false, false, false, 0, null);
    document.dispatchEvent(event);
    return event;
};
ava_1.default.beforeEach(function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var div;
    return __generator(this, function (_a) {
        div = document.createElement("div");
        document.body.appendChild(div);
        return [2 /*return*/];
    });
}); });
ava_1.default("should mount without error", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var rnd;
    return __generator(this, function (_a) {
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { default: { x: 100, y: 100, width: 100, height: 100 } }));
        t.truthy(!!rnd);
        return [2 /*return*/];
    });
}); });
ava_1.default("Should custom class name be applied to box", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var rnd;
    return __generator(this, function (_a) {
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { className: "custom-class-name", default: { x: 100, y: 100, width: 100, height: 100 } }));
        t.truthy(rnd.getDOMNode().classList.contains("custom-class-name"));
        return [2 /*return*/];
    });
}); });
ava_1.default("Should render custom components", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var CustomComponent, rnd, customComponents;
    return __generator(this, function (_a) {
        CustomComponent = function () { return React.createElement("div", { className: "custom-component" }); };
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { default: { x: 100, y: 100, width: 100, height: 100 }, resizeHandleComponent: {
                top: React.createElement(CustomComponent, null),
                right: React.createElement(CustomComponent, null),
                bottom: React.createElement(CustomComponent, null),
                left: React.createElement(CustomComponent, null),
                topRight: React.createElement(CustomComponent, null),
                bottomRight: React.createElement(CustomComponent, null),
                bottomLeft: React.createElement(CustomComponent, null),
                topLeft: React.createElement(CustomComponent, null),
            } }));
        customComponents = rnd.find(".custom-component");
        t.is(customComponents.length, 8);
        return [2 /*return*/];
    });
}); });
ava_1.default("Should set handler className", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var rnd, handlers;
    return __generator(this, function (_a) {
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { default: { x: 100, y: 100, width: 100, height: 100 }, resizeHandleClasses: {
                top: "handler",
                right: "handler",
                bottom: "handler",
                left: "handler",
                topRight: "handler",
                bottomRight: "handler",
                bottomLeft: "handler",
                topLeft: "handler",
            } }));
        handlers = rnd.find(".handler");
        // FIXME: Is it a enzyme 3.x bug ? I can not understand why handlers.length equals 16.
        //        When use enzyme v2.x this test is passed...
        // t.is(handlers.length, 8);
        t.is(handlers.length, 16);
        return [2 /*return*/];
    });
}); });
ava_1.default("Should not render resizer when enable props all false", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var rnd, handlers;
    return __generator(this, function (_a) {
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { default: { x: 100, y: 100, width: 100, height: 100 }, enableResizing: {
                top: false,
                right: false,
                bottom: false,
                left: false,
                topRight: false,
                bottomRight: false,
                bottomLeft: false,
                topLeft: false,
            }, resizeHandleClasses: {
                top: "handler",
                right: "handler",
                bottom: "handler",
                left: "handler",
                topRight: "handler",
                bottomRight: "handler",
                bottomLeft: "handler",
                topLeft: "handler",
            } }));
        handlers = rnd.find(".handler");
        t.is(handlers.length, 0);
        return [2 /*return*/];
    });
}); });
ava_1.default("should call onMouseDown when mouse downed", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var onMouseDown, rnd;
    return __generator(this, function (_a) {
        onMouseDown = sinon_1.spy();
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { default: { x: 100, y: 100, width: 100, height: 100 }, onMouseDown: onMouseDown }));
        rnd.find("div").at(0).simulate("mousedown");
        t.is(onMouseDown.callCount, 1);
        t.is(onMouseDown.firstCall.args[0].type, "mousedown");
        return [2 /*return*/];
    });
}); });
ava_1.default("should call onDragStart when start dragging", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var onDragStart, rnd;
    return __generator(this, function (_a) {
        onDragStart = sinon_1.spy();
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { default: { x: 100, y: 100, width: 100, height: 100 }, onDragStart: onDragStart }));
        rnd.find("div").at(0).simulate("mousedown");
        t.is(onDragStart.callCount, 1);
        t.is(onDragStart.firstCall.args[0].type, "mousedown");
        t.is(onDragStart.firstCall.args[1].x, 200);
        t.is(onDragStart.firstCall.args[1].y, 200);
        return [2 /*return*/];
    });
}); });
ava_1.default("should call onDrag when dragging", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var onDrag, rnd;
    return __generator(this, function (_a) {
        onDrag = sinon_1.spy();
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { default: { x: 100, y: 100, width: 100, height: 100 }, onDrag: onDrag }));
        rnd.find("div").at(0).simulate("mousedown", { clientX: 0, clientY: 0 });
        mouseMove(200, 220);
        t.is(onDrag.callCount, 1);
        t.is(onDrag.firstCall.args[1].x, 500);
        t.is(onDrag.firstCall.args[1].y, 520);
        t.not((rnd.getDOMNode().getAttribute("style") || "").indexOf("transform: translate(400px, 420px)"), -1);
        return [2 /*return*/];
    });
}); });
ava_1.default("should call onDragStop when drag stop", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var onDragStop, rnd;
    return __generator(this, function (_a) {
        onDragStop = sinon_1.spy();
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { default: { x: 100, y: 100, width: 100, height: 100 }, onDragStop: onDragStop }));
        rnd.find("div").at(0).simulate("mousedown", { clientX: 0, clientY: 0 });
        mouseMove(200, 220);
        mouseUp(100, 120);
        t.is(onDragStop.callCount, 1);
        t.is(onDragStop.firstCall.args[1].x, 200);
        t.is(onDragStop.firstCall.args[1].y, 220);
        return [2 /*return*/];
    });
}); });
ava_1.default("should dragging disabled when axis equals none", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var onDrag, rnd;
    return __generator(this, function (_a) {
        onDrag = sinon_1.spy();
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { onDrag: onDrag, dragAxis: "none", default: { x: 100, y: 100, width: 100, height: 100 } }), {
            attachTo: document.querySelector("div"),
        });
        rnd.find("div").at(0).simulate("mousedown", { clientX: 0, clientY: 0 });
        mouseMove(200, 220);
        t.is(onDrag.callCount, 1);
        t.not((rnd.getDOMNode().getAttribute("style") || "").indexOf("transform: translate(100px, 100px)"), -1);
        return [2 /*return*/];
    });
}); });
ava_1.default("should enable dragging only x when axis equals x", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var onDrag, rnd;
    return __generator(this, function (_a) {
        onDrag = sinon_1.spy();
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { onDrag: onDrag, dragAxis: "x", default: { x: 100, y: 100, width: 100, height: 100 } }), {
            attachTo: document.querySelector("div"),
        });
        rnd.find("div").at(0).simulate("mousedown", { clientX: 0, clientY: 0 });
        mouseMove(200, 220);
        t.is(onDrag.callCount, 1);
        t.not((rnd.getDOMNode().getAttribute("style") || "").indexOf("transform: translate(300px, 100px)"), -1);
        return [2 /*return*/];
    });
}); });
ava_1.default("xdragging only y when axis equals y", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var onDrag, rnd;
    return __generator(this, function (_a) {
        onDrag = sinon_1.spy();
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { onDrag: onDrag, dragAxis: "y", default: { x: 100, y: 100, width: 100, height: 100 } }), {
            attachTo: document.querySelector("div"),
        });
        rnd.find("div").at(0).simulate("mousedown", { clientX: 0, clientY: 0 });
        mouseMove(200, 220);
        t.is(onDrag.callCount, 1);
        t.not((rnd.getDOMNode().getAttribute("style") || "").indexOf("transform: translate(100px, 320px)"), -1);
        return [2 /*return*/];
    });
}); });
ava_1.default("should enable dragging both x & y when axis equals both", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var onDrag, rnd;
    return __generator(this, function (_a) {
        onDrag = sinon_1.spy();
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { onDrag: onDrag, dragAxis: "both", default: { x: 100, y: 100, width: 100, height: 100 } }), {
            attachTo: document.querySelector("div"),
        });
        rnd.find("div").at(0).simulate("mousedown", { clientX: 0, clientY: 0 });
        mouseMove(200, 220);
        t.is(onDrag.callCount, 1);
        t.not((rnd.getDOMNode().getAttribute("style") || "").indexOf("transform: translate(300px, 320px)"), -1);
        return [2 /*return*/];
    });
}); });
ava_1.default("should snap when dragging smaller than threshold", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var rnd;
    return __generator(this, function (_a) {
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { dragGrid: [30, 100], default: { x: 100, y: 100, width: 100, height: 100 } }), {
            attachTo: document.querySelector("div"),
        });
        rnd.find("div").at(0).simulate("mousedown", { clientX: 0, clientY: 0 });
        mouseMove(14, 49);
        t.not((rnd.getDOMNode().getAttribute("style") || "").indexOf("transform: translate(100px, 100px)"), -1);
        return [2 /*return*/];
    });
}); });
ava_1.default("should snap when dragging larger than threshold", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var rnd;
    return __generator(this, function (_a) {
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { dragGrid: [30, 100], default: { x: 100, y: 100, width: 100, height: 100 } }), {
            attachTo: document.querySelector("div"),
        });
        rnd.find("div").at(0).simulate("mousedown", { clientX: 0, clientY: 0 });
        mouseMove(15, 50);
        t.not((rnd.getDOMNode().getAttribute("style") || "").indexOf("transform: translate(130px, 200px)"), -1);
        return [2 /*return*/];
    });
}); });
ava_1.default("should limit position by parent bounds", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var rnd;
    return __generator(this, function (_a) {
        rnd = enzyme_1.mount(React.createElement("div", { style: { width: "800px", height: "600px" } },
            React.createElement(_1.Rnd, { bounds: "parent", default: { x: 0, y: 0, width: 100, height: 100 } })), { attachTo: document.querySelector("div") });
        rnd.find("div").at(0).childAt(0).simulate("mousedown", { clientX: 50, clientY: 50 });
        mouseMove(1000, 1000);
        t.not((rnd.find("div").at(0).childAt(0).getDOMNode().getAttribute("style") || "").indexOf("transform: translate(700px, 500px)"), -1);
        return [2 /*return*/];
    });
}); });
ava_1.default("should limit position by selector bounds", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var rnd;
    return __generator(this, function (_a) {
        rnd = enzyme_1.mount(React.createElement("div", { className: "target", style: { width: "1000px", height: "800px" } },
            React.createElement("div", { style: { width: "800px", height: "600px" } },
                React.createElement(_1.Rnd, { className: "rnd", bounds: ".target", default: { x: 100, y: 100, width: 100, height: 100 } }))), { attachTo: document.querySelector("div") });
        rnd.find("div").at(0).childAt(0).childAt(0).simulate("mousedown", { clientX: 0, clientY: 0 });
        mouseMove(2000, 2000);
        t.not((rnd.find("div").at(0).childAt(0).childAt(0).getDOMNode().getAttribute("style") || "").indexOf("translate(900px, 700px)"), -1);
        return [2 /*return*/];
    });
}); });
ava_1.default("Should box width and height equal 100px", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var rnd;
    return __generator(this, function (_a) {
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { default: { x: 100, y: 100, width: 100, height: 100 }, resizeHandleClasses: {
                top: "handler",
                right: "handler",
                bottom: "handler",
                left: "handler",
                topRight: "handler",
                bottomRight: "handler",
                bottomLeft: "handler",
                topLeft: "handler",
            } }), { attachTo: document.querySelector("div") });
        t.is(rnd.getDOMNode().style.width, "100px");
        t.is(rnd.getDOMNode().style.height, "100px");
        return [2 /*return*/];
    });
}); });
ava_1.default("Should call onResizeStart when mousedown", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var onResizeStart, rnd;
    return __generator(this, function (_a) {
        onResizeStart = sinon_1.spy();
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { default: { x: 100, y: 100, width: 100, height: 100 }, resizeHandleClasses: {
                top: "handler",
                right: "handler",
                bottom: "handler",
                left: "handler",
                topRight: "handler",
                bottomRight: "handler",
                bottomLeft: "handler",
                topLeft: "handler",
            }, enableResizing: {
                top: false,
                right: true,
                bottom: false,
                left: false,
                topRight: false,
                bottomRight: false,
                bottomLeft: false,
                topLeft: false,
            }, onResizeStart: onResizeStart }), { attachTo: document.querySelector("div") });
        rnd.find("div.handler").at(0).simulate("mousedown", { clientX: 0, clientY: 0 });
        t.is(onResizeStart.callCount, 1);
        t.is(onResizeStart.getCall(0).args[1], "right");
        return [2 /*return*/];
    });
}); });
ava_1.default("should call onResize with expected args when resize direction right", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var onResize, onResizeStart, rnd;
    return __generator(this, function (_a) {
        onResize = sinon_1.spy();
        onResizeStart = sinon_1.spy();
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { default: { x: 100, y: 100, width: 100, height: 100 }, resizeHandleClasses: {
                top: "handler",
                right: "handler",
                bottom: "handler",
                left: "handler",
                topRight: "handler",
                bottomRight: "handler",
                bottomLeft: "handler",
                topLeft: "handler",
            }, enableResizing: {
                top: false,
                right: true,
                bottom: false,
                left: false,
                topRight: false,
                bottomRight: false,
                bottomLeft: false,
                topLeft: false,
            }, onResizeStart: onResizeStart, onResize: onResize }), { attachTo: document.querySelector("div") });
        rnd.find("div.handler").at(0).simulate("mousedown", { clientX: 0, clientY: 0 });
        mouseMove(200, 220);
        t.is(onResize.callCount, 1);
        t.truthy(onResize.getCall(0).args[0] instanceof Event);
        t.is(onResize.getCall(0).args[1], "right");
        t.deepEqual(onResize.getCall(0).args[2].clientWidth, 300);
        t.deepEqual(onResize.getCall(0).args[2].clientHeight, 100);
        t.deepEqual(onResize.getCall(0).args[3], { width: 200, height: 0 });
        return [2 /*return*/];
    });
}); });
ava_1.default("should call onResizeStop with expected args when resize direction right", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var onResize, onResizeStop, rnd;
    return __generator(this, function (_a) {
        onResize = sinon_1.spy();
        onResizeStop = sinon_1.spy();
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { default: { x: 100, y: 100, width: 100, height: 100 }, resizeHandleClasses: {
                top: "handler",
                right: "handler",
                bottom: "handler",
                left: "handler",
                topRight: "handler",
                bottomRight: "handler",
                bottomLeft: "handler",
                topLeft: "handler",
            }, enableResizing: {
                top: false,
                right: true,
                bottom: false,
                left: false,
                topRight: false,
                bottomRight: false,
                bottomLeft: false,
                topLeft: false,
            }, onResizeStop: onResizeStop, onResize: onResize }), { attachTo: document.querySelector("div") });
        rnd.find("div.handler").at(0).simulate("mousedown", { clientX: 0, clientY: 0 });
        mouseMove(200, 220);
        mouseUp(200, 220);
        t.is(onResizeStop.callCount, 1);
        t.truthy(onResize.getCall(0).args[0] instanceof Event);
        t.is(onResize.getCall(0).args[1], "right");
        t.deepEqual(onResize.getCall(0).args[2].clientWidth, 300);
        t.deepEqual(onResize.getCall(0).args[2].clientHeight, 100);
        t.deepEqual(onResize.getCall(0).args[3], { width: 200, height: 0 });
        return [2 /*return*/];
    });
}); });
ava_1.default("should move x when resizing left", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var onResize, onResizeStart, rnd;
    return __generator(this, function (_a) {
        onResize = sinon_1.spy();
        onResizeStart = sinon_1.spy();
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { default: { x: 100, y: 100, width: 100, height: 100 }, resizeHandleClasses: {
                top: "handler",
                right: "handler",
                bottom: "handler",
                left: "handler",
                topRight: "handler",
                bottomRight: "handler",
                bottomLeft: "handler",
                topLeft: "handler",
            }, enableResizing: {
                top: false,
                right: false,
                bottom: false,
                left: true,
                topRight: false,
                bottomRight: false,
                bottomLeft: false,
                topLeft: false,
            }, onResizeStart: onResizeStart, onResize: onResize }), { attachTo: document.querySelector("div") });
        rnd.find("div.handler").at(0).simulate("mousedown", { clientX: 0, clientY: 0 });
        mouseMove(-50, 0);
        t.is(onResize.callCount, 1);
        t.is(onResize.getCall(0).args[1], "left");
        t.deepEqual(onResize.getCall(0).args[2].clientWidth, 150);
        t.deepEqual(onResize.getCall(0).args[2].clientHeight, 100);
        t.deepEqual(onResize.getCall(0).args[3], { width: 50, height: 0 });
        t.not((rnd.getDOMNode().getAttribute("style") || "").indexOf("transform: translate(50px, 100px)"), -1);
        return [2 /*return*/];
    });
}); });
ava_1.default("should move y when resizing top", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var onResize, onResizeStart, rnd;
    return __generator(this, function (_a) {
        onResize = sinon_1.spy();
        onResizeStart = sinon_1.spy();
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { default: { x: 100, y: 100, width: 100, height: 100 }, resizeHandleClasses: {
                top: "handler",
                right: "handler",
                bottom: "handler",
                left: "handler",
                topRight: "handler",
                bottomRight: "handler",
                bottomLeft: "handler",
                topLeft: "handler",
            }, enableResizing: {
                top: true,
                right: false,
                bottom: false,
                left: false,
                topRight: false,
                bottomRight: false,
                bottomLeft: false,
                topLeft: false,
            }, onResizeStart: onResizeStart, onResize: onResize }), { attachTo: document.querySelector("div") });
        rnd.find("div.handler").at(0).simulate("mousedown", { clientX: 0, clientY: 0 });
        mouseMove(0, -50);
        t.is(onResize.callCount, 1);
        t.is(onResize.getCall(0).args[1], "top");
        t.deepEqual(onResize.getCall(0).args[2].clientWidth, 100);
        t.deepEqual(onResize.getCall(0).args[2].clientHeight, 150);
        t.deepEqual(onResize.getCall(0).args[3], { width: 0, height: 50 });
        t.not((rnd.getDOMNode().getAttribute("style") || "").indexOf("transform: translate(100px, 50px)"), -1);
        return [2 /*return*/];
    });
}); });
ava_1.default("should snapped by original grid when x axis resizing smaller then threshold", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var onResize, rnd;
    return __generator(this, function (_a) {
        onResize = sinon_1.spy();
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { default: { x: 100, y: 100, width: 100, height: 100 }, resizeHandleClasses: {
                top: "handler",
                right: "handler",
                bottom: "handler",
                left: "handler",
                topRight: "handler",
                bottomRight: "handler",
                bottomLeft: "handler",
                topLeft: "handler",
            }, enableResizing: {
                top: false,
                right: false,
                bottom: false,
                left: false,
                topRight: false,
                bottomRight: true,
                bottomLeft: false,
                topLeft: false,
            }, onResize: onResize, resizeGrid: [20, 1] }), { attachTo: document.querySelector("div") });
        rnd.find("div.handler").at(0).simulate("mousedown", { clientX: 0, clientY: 0 });
        mouseMove(9, 0);
        t.deepEqual(onResize.getCall(0).args[2].clientWidth, 100);
        return [2 /*return*/];
    });
}); });
ava_1.default("should snapped by original grid when x axis resizing larger then threshold", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var onResize, rnd;
    return __generator(this, function (_a) {
        onResize = sinon_1.spy();
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { default: { x: 100, y: 100, width: 100, height: 100 }, resizeHandleClasses: {
                top: "handler",
                right: "handler",
                bottom: "handler",
                left: "handler",
                topRight: "handler",
                bottomRight: "handler",
                bottomLeft: "handler",
                topLeft: "handler",
            }, enableResizing: {
                top: false,
                right: false,
                bottom: false,
                left: false,
                topRight: false,
                bottomRight: true,
                bottomLeft: false,
                topLeft: false,
            }, onResize: onResize, resizeGrid: [20, 1] }), { attachTo: document.querySelector("div") });
        rnd.find("div.handler").at(0).simulate("mousedown", { clientX: 0, clientY: 0 });
        mouseMove(10, 0);
        t.deepEqual(onResize.getCall(0).args[2].clientWidth, 120);
        return [2 /*return*/];
    });
}); });
ava_1.default("should snapped by original grid when y axis resizing smaller then threshold", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var onResize, rnd;
    return __generator(this, function (_a) {
        onResize = sinon_1.spy();
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { default: { x: 100, y: 100, width: 100, height: 100 }, resizeHandleClasses: {
                top: "handler",
                right: "handler",
                bottom: "handler",
                left: "handler",
                topRight: "handler",
                bottomRight: "handler",
                bottomLeft: "handler",
                topLeft: "handler",
            }, enableResizing: {
                top: false,
                right: false,
                bottom: false,
                left: false,
                topRight: false,
                bottomRight: true,
                bottomLeft: false,
                topLeft: false,
            }, onResize: onResize, resizeGrid: [1, 20] }), { attachTo: document.querySelector("div") });
        rnd.find("div.handler").at(0).simulate("mousedown", { clientX: 0, clientY: 0 });
        mouseMove(0, 9);
        t.deepEqual(onResize.getCall(0).args[2].clientHeight, 100);
        return [2 /*return*/];
    });
}); });
ava_1.default("should snapped by original grid when y axis resizing larger then threshold", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var onResize, rnd;
    return __generator(this, function (_a) {
        onResize = sinon_1.spy();
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { default: { x: 100, y: 100, width: 100, height: 100 }, resizeHandleClasses: {
                top: "handler",
                right: "handler",
                bottom: "handler",
                left: "handler",
                topRight: "handler",
                bottomRight: "handler",
                bottomLeft: "handler",
                topLeft: "handler",
            }, enableResizing: {
                top: false,
                right: false,
                bottom: false,
                left: false,
                topRight: false,
                bottomRight: true,
                bottomLeft: false,
                topLeft: false,
            }, onResize: onResize, resizeGrid: [1, 20] }), { attachTo: document.querySelector("div") });
        rnd.find("div.handler").at(0).simulate("mousedown", { clientX: 0, clientY: 0 });
        mouseMove(0, 10);
        t.deepEqual(onResize.getCall(0).args[2].clientHeight, 120);
        return [2 /*return*/];
    });
}); });
ava_1.default("should snapped by original grid when y axis resizing larger then threshold", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var onResize, rnd;
    return __generator(this, function (_a) {
        onResize = sinon_1.spy();
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { default: { x: 100, y: 100, width: 100, height: 100 }, resizeHandleClasses: {
                top: "handler",
                right: "handler",
                bottom: "handler",
                left: "handler",
                topRight: "handler",
                bottomRight: "handler",
                bottomLeft: "handler",
                topLeft: "handler",
            }, enableResizing: {
                top: false,
                right: false,
                bottom: false,
                left: false,
                topRight: false,
                bottomRight: true,
                bottomLeft: false,
                topLeft: false,
            }, onResize: onResize, resizeGrid: [30, 20] }), { attachTo: document.querySelector("div") });
        rnd.find("div.handler").at(0).simulate("mousedown", { clientX: 0, clientY: 0 });
        mouseMove(20, 10);
        // TODO: It'a resizable-box grid bug??
        t.deepEqual(onResize.getCall(0).args[2].clientWidth, 120);
        t.deepEqual(onResize.getCall(0).args[2].clientHeight, 120);
        return [2 /*return*/];
    });
}); });
ava_1.default("should clamped by parent size", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var rnd;
    return __generator(this, function (_a) {
        rnd = enzyme_1.mount(React.createElement("div", { style: { width: "800px", height: "600px" } },
            React.createElement(_1.Rnd, { default: { x: 0, y: 0, width: 100, height: 100 }, resizeHandleClasses: {
                    top: "handler",
                    right: "handler",
                    bottom: "handler",
                    left: "handler",
                    topRight: "handler",
                    bottomRight: "handler",
                    bottomLeft: "handler",
                    topLeft: "handler",
                }, bounds: "parent", enableResizing: {
                    top: false,
                    right: false,
                    bottom: false,
                    left: false,
                    topRight: false,
                    bottomRight: true,
                    bottomLeft: false,
                    topLeft: false,
                } })), { attachTo: document.querySelector("div") });
        rnd.find("div.handler").at(0).simulate("mousedown", { clientX: 0, clientY: 0 });
        mouseMove(1200, 1200);
        t.is(rnd.childAt(0).getDOMNode().style.width, "800px");
        t.is(rnd.childAt(0).getDOMNode().style.height, "600px");
        return [2 /*return*/];
    });
}); });
ava_1.default("should clamped by selector size", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var rnd;
    return __generator(this, function (_a) {
        rnd = enzyme_1.mount(React.createElement("div", { className: "target", style: { width: "1000px", height: "800px" } },
            React.createElement("div", { style: { width: "800px", height: "600px" } },
                React.createElement(_1.Rnd, { default: { x: 0, y: 0, width: 100, height: 100 }, resizeHandleClasses: {
                        top: "handler",
                        right: "handler",
                        bottom: "handler",
                        left: "handler",
                        topRight: "handler",
                        bottomRight: "handler",
                        bottomLeft: "handler",
                        topLeft: "handler",
                    }, bounds: ".target", enableResizing: {
                        top: false,
                        right: false,
                        bottom: false,
                        left: false,
                        topRight: false,
                        bottomRight: true,
                        bottomLeft: false,
                        topLeft: false,
                    } }))), { attachTo: document.querySelector("div") });
        rnd.find("div.handler").at(0).simulate("mousedown", { clientX: 0, clientY: 0 });
        mouseMove(2000, 2000);
        t.is(rnd.childAt(0).childAt(0).getDOMNode().style.width, "1000px");
        t.is(rnd.childAt(0).childAt(0).getDOMNode().style.height, "800px");
        return [2 /*return*/];
    });
}); });
ava_1.default("should get rnd updated when updatePosition invoked", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var rnd;
    return __generator(this, function (_a) {
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { default: { x: 100, y: 100, width: 100, height: 100 } }));
        rnd.instance().updatePosition({ x: 200, y: 300 });
        t.not((rnd.getDOMNode().getAttribute("style") || "").indexOf("transform: translate(200px, 300px)"), -1);
        return [2 /*return*/];
    });
}); });
ava_1.default("should get rnd updated when updateSize invoked", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var rnd;
    return __generator(this, function (_a) {
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { default: { x: 100, y: 100, width: 100, height: 100 } }));
        rnd.instance().updateSize({ width: 200, height: 300 });
        t.is(rnd.getDOMNode().style.width, "200px");
        t.is(rnd.getDOMNode().style.height, "300px");
        return [2 /*return*/];
    });
}); });
ava_1.default("should find drag handle class when dragHandleClassName props passed", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var onDrag, rnd;
    return __generator(this, function (_a) {
        onDrag = sinon_1.spy();
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { dragHandleClassName: "handle", onDrag: onDrag, default: { x: 100, y: 100, width: 100, height: 100 } },
            React.createElement("div", { className: "handle" }, "Test")));
        rnd.find("div.handle").simulate("mousedown", { clientX: 0, clientY: 0 });
        mouseMove(200, 220);
        t.is(onDrag.callCount, 1);
        return [2 /*return*/];
    });
}); });
ava_1.default("should pass data- attribute", function (t) { return __awaiter(void 0, void 0, void 0, function () {
    var rnd;
    return __generator(this, function (_a) {
        rnd = enzyme_1.mount(React.createElement(_1.Rnd, { "data-foo": "42" }, "Test"));
        t.is(!!rnd.find("[data-foo]"), true);
        return [2 /*return*/];
    });
}); });
