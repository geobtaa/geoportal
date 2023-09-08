"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    Object.defineProperty(o, k2, { enumerable: true, get: function() { return m[k]; } });
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __exportStar = (this && this.__exportStar) || function(m, exports) {
    for (var p in m) if (p !== "default" && !exports.hasOwnProperty(p)) __createBinding(exports, m, p);
};
Object.defineProperty(exports, "__esModule", { value: true });
var IntersectionObserver_1 = require("./IntersectionObserver");
Object.defineProperty(exports, "default", { enumerable: true, get: function () { return IntersectionObserver_1.default; } });
var utils_1 = require("./utils");
Object.defineProperty(exports, "parseRootMargin", { enumerable: true, get: function () { return utils_1.parseRootMargin; } });
__exportStar(require("./hook"), exports);
