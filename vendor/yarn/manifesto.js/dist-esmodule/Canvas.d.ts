import { Annotation, AnnotationList, IManifestoOptions, Range, Resource, Size } from "./internal";
export declare class Canvas extends Resource {
    ranges: Range[];
    constructor(jsonld?: any, options?: IManifestoOptions);
    getCanonicalImageUri(w?: number): string;
    getMaxDimensions(): Size | null;
    getContent(): Annotation[];
    getDuration(): number | null;
    getImages(): Annotation[];
    getIndex(): number;
    getOtherContent(): Promise<AnnotationList[]>;
    getWidth(): number;
    getHeight(): number;
}
