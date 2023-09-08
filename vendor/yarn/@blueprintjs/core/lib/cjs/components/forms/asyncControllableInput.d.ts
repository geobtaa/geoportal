import * as React from "react";
export interface IAsyncControllableInputProps extends React.DetailedHTMLProps<React.InputHTMLAttributes<HTMLInputElement>, HTMLInputElement> {
    inputRef?: React.LegacyRef<HTMLInputElement>;
}
export interface IAsyncControllableInputState {
    /**
     * Whether we are in the middle of a composition event.
     * @default false
     */
    isComposing: boolean;
    /**
     * The source of truth for the input value. This is not updated during IME composition.
     * It may be updated by a parent component.
     * @default ""
     */
    externalValue: IAsyncControllableInputProps["value"];
    /**
     * The latest input value, which updates during IME composition. If undefined, we use
     * externalValue instead.
     */
    localValue: IAsyncControllableInputProps["value"];
}
/**
 * A stateful wrapper around the low-level <input> component which works around a
 * [React bug](https://github.com/facebook/react/issues/3926). This bug is reproduced when an input
 * receives CompositionEvents (for example, through IME composition) and has its value prop updated
 * asychronously. This might happen if a component chooses to do async validation of a value
 * returned by the input's `onChange` callback.
 *
 * Implementation adapted from https://jsfiddle.net/m792qtys/ (linked in the above issue thread).
 *
 * Note: this component does not apply any Blueprint-specific styling.
 */
export declare class AsyncControllableInput extends React.PureComponent<IAsyncControllableInputProps, IAsyncControllableInputState> {
    state: IAsyncControllableInputState;
    static getDerivedStateFromProps({ value }: IAsyncControllableInputProps): {
        externalValue: string | number | readonly string[] | undefined;
    };
    render(): JSX.Element;
    private handleCompositionStart;
    private handleCompositionEnd;
    private handleChange;
}
