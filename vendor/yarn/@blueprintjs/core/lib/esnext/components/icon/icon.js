/*
 * Copyright 2017 Palantir Technologies, Inc. All rights reserved.
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
var Icon_1;
import { __decorate } from "tslib";
import classNames from "classnames";
import * as React from "react";
import { polyfill } from "react-lifecycles-compat";
import { IconSvgPaths16, IconSvgPaths20 } from "@blueprintjs/icons";
import { AbstractPureComponent2, Classes, DISPLAYNAME_PREFIX } from "../../common";
let Icon = Icon_1 = class Icon extends AbstractPureComponent2 {
    render() {
        const { icon } = this.props;
        if (icon == null || typeof icon === "boolean") {
            return null;
        }
        else if (typeof icon !== "string") {
            return icon;
        }
        const { className, color, htmlTitle, iconSize = Icon_1.SIZE_STANDARD, intent, title = icon, tagName = "span", ...htmlprops } = this.props;
        // choose which pixel grid is most appropriate for given icon size
        const pixelGridSize = iconSize >= Icon_1.SIZE_LARGE ? Icon_1.SIZE_LARGE : Icon_1.SIZE_STANDARD;
        // render path elements, or nothing if icon name is unknown.
        const paths = this.renderSvgPaths(pixelGridSize, icon);
        const classes = classNames(Classes.ICON, Classes.iconClass(icon), Classes.intentClass(intent), className);
        const viewBox = `0 0 ${pixelGridSize} ${pixelGridSize}`;
        return React.createElement(tagName, {
            ...htmlprops,
            className: classes,
            title: htmlTitle,
        }, React.createElement("svg", { fill: color, "data-icon": icon, width: iconSize, height: iconSize, viewBox: viewBox },
            title && React.createElement("desc", null, title),
            paths));
    }
    /** Render `<path>` elements for the given icon name. Returns `null` if name is unknown. */
    renderSvgPaths(pathsSize, iconName) {
        const svgPathsRecord = pathsSize === Icon_1.SIZE_STANDARD ? IconSvgPaths16 : IconSvgPaths20;
        const pathStrings = svgPathsRecord[iconName];
        if (pathStrings == null) {
            return null;
        }
        return pathStrings.map((d, i) => React.createElement("path", { key: i, d: d, fillRule: "evenodd" }));
    }
};
Icon.displayName = `${DISPLAYNAME_PREFIX}.Icon`;
Icon.SIZE_STANDARD = 16;
Icon.SIZE_LARGE = 20;
Icon = Icon_1 = __decorate([
    polyfill
], Icon);
export { Icon };
//# sourceMappingURL=icon.js.map