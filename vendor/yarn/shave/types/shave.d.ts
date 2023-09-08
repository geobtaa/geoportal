export type Link = {
    [key: string]: string | number | boolean;
};
export type Opts = {
    character?: string;
    classname?: string;
    spaces?: boolean;
    charclassname?: string;
    link?: Link;
};
export default function shave(target: string | NodeList | Node, maxHeight: number, opts?: Opts): void;
