"use strict";
/*
 * Copyright 2020 Palantir Technologies, Inc. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.getRef = exports.isRefCallback = exports.isRefObject = void 0;
function isRefObject(value) {
    return value != null && typeof value.current !== "undefined";
}
exports.isRefObject = isRefObject;
function isRefCallback(value) {
    return typeof value === "function";
}
exports.isRefCallback = isRefCallback;
function getRef(ref) {
    var _a;
    if (ref === null) {
        return null;
    }
    return (_a = ref.current) !== null && _a !== void 0 ? _a : ref;
}
exports.getRef = getRef;
//# sourceMappingURL=refs.js.map