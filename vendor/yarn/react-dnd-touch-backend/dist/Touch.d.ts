import { BackendFactory, Backend, DragDropManager } from 'dnd-core';
declare global {
    interface Document {
        msElementsFromPoint: Document['elementsFromPoint'];
    }
}
interface EventName {
    start?: 'mousedown' | 'touchstart';
    move?: 'mousemove' | 'touchmove';
    end?: 'mouseup' | 'touchend';
    contextmenu?: 'contextmenu';
    keydown?: 'keydown';
}
export interface Opts {
    delay?: number;
    delayTouchStart?: number;
    enableTouchEvents?: boolean;
    enableKeyboardEvents?: boolean;
    enableMouseEvents?: boolean;
    ignoreContextMenu?: boolean;
    enableHoverOutsideTarget?: boolean;
    delayMouseStart?: number;
    touchSlop?: number;
    scrollAngleRanges?: AngleRange[];
    getDropTargetElementsAtPoint?: Function;
}
interface AngleRange {
    start: number;
    end: number;
}
export declare class TouchBackend implements Backend {
    private enableKeyboardEvents;
    private enableMouseEvents;
    private delayTouchStart;
    private delayMouseStart;
    private ignoreContextMenu;
    private touchSlop;
    private scrollAngleRanges;
    private enableHoverOutsideTarget;
    private sourceNodes;
    private sourceNodeOptions;
    private sourcePreviewNodes;
    private sourcePreviewNodeOptions;
    private targetNodes;
    private targetNodeOptions;
    private _mouseClientOffset;
    private _isScrolling;
    private listenerTypes;
    private actions;
    private monitor;
    private registry;
    private getDropTargetElementsAtPoint;
    private static isSetUp;
    private moveStartSourceIds;
    private waitingForDelay;
    private timeout;
    private dragOverTargetIds;
    private draggedSourceNode;
    private draggedSourceNodeRemovalObserver;
    constructor(manager: Parameters<BackendFactory>[0], options?: Opts);
    setup(): void;
    teardown(): void;
    addEventListener<K extends keyof EventName>(subject: HTMLElement | Window, event: K, handler: (e: WindowEventMap[EventName[K]]) => void, capture?: boolean): void;
    removeEventListener<K extends keyof EventName>(subject: HTMLElement | Window, event: K, handler: (e: WindowEventMap[EventName[K]]) => void, capture?: boolean): void;
    connectDragSource(sourceId: any, node: HTMLElement): () => void;
    connectDragPreview(sourceId: string, node: HTMLElement, options: any): () => void;
    connectDropTarget(targetId: any, node: any): () => void;
    getSourceClientOffset: (sourceId: string) => {
        x: any;
        y: any;
    };
    handleTopMoveStartCapture: (e: Event) => void;
    handleMoveStart: (sourceId: string) => void;
    getTopMoveStartHandler(): (e: MouseEvent | TouchEvent) => void;
    handleTopMoveStart: (e: MouseEvent | TouchEvent) => void;
    handleTopMoveStartDelay: (e: Event) => void;
    handleTopMoveCapture: () => void;
    handleMove: (_: any, targetId: string) => void;
    handleTopMove: (e: MouseEvent | TouchEvent) => void;
    handleTopMoveEndCapture: (e: Event) => void;
    handleCancelOnEscape: (e: KeyboardEvent) => void;
    installSourceNodeRemovalObserver(node: any): void;
    resurrectSourceNode(): void;
    uninstallSourceNodeRemovalObserver(): void;
}
export default function createTouchBackend(optionsOrManager: DragDropManager<any> | Opts): TouchBackend | ((manager: DragDropManager<any>) => TouchBackend);
export {};
