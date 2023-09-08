import { Language } from "./internal";
export declare class LanguageMap extends Array<Language> {
    static parse(language: any, defaultLocale: string): LanguageMap;
    static getValue(languageCollection: LanguageMap, locale?: string): string | null;
    static getValues(languageCollection: LanguageMap, locale?: string): Array<string | null>;
}
