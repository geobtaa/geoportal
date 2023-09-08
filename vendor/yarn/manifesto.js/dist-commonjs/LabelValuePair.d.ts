import { LanguageMap } from "./internal";
export declare class LabelValuePair {
    label: LanguageMap;
    value: LanguageMap;
    defaultLocale: string;
    resource: any;
    constructor(defaultLocale: string);
    parse(resource: any): void;
    getLabel(): string | null;
    setLabel(value: string): void;
    getValue(): string | null;
    getValues(): Array<string | null>;
    setValue(value: string): void;
}
