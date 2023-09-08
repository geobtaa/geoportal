/// <reference types="node" />

import { AnnotationMotivation, Behavior, ExternalResourceType, IIIFResourceType, MediaType, RenderingFormat, ServiceProfile, ViewingDirection, ViewingHint } from '@iiif/vocabulary';

export declare class JSONLDResource {
	context: string;
	id: string;
	__jsonld: any;
	constructor(jsonld?: any);
	getProperty(name: string): any;
}
export declare class ManifestResource extends JSONLDResource {
	externalResource: IExternalResource;
	options: IManifestoOptions;
	constructor(jsonld: any, options?: IManifestoOptions);
	getIIIFResourceType(): IIIFResourceType;
	getLabel(): LanguageMap;
	getDefaultLabel(): string | null;
	getMetadata(): LabelValuePair[];
	getRendering(format: RenderingFormat): Rendering | null;
	getRenderings(): Rendering[];
	getService(profile: ServiceProfile): Service | null;
	getServices(): Service[];
	getThumbnail(): Thumbnail | null;
	isAnnotation(): boolean;
	isCanvas(): boolean;
	isCollection(): boolean;
	isManifest(): boolean;
	isRange(): boolean;
	isSequence(): boolean;
}
export declare class Resource extends ManifestResource {
	index: number;
	constructor(jsonld?: any, options?: IManifestoOptions);
	getFormat(): MediaType | null;
	getResources(): Annotation[];
	getType(): ExternalResourceType | null;
	getWidth(): number;
	getHeight(): number;
	getMaxWidth(): number;
	getMaxHeight(): number | null;
}
export declare class IIIFResource extends ManifestResource {
	defaultTree: TreeNode;
	index: number;
	isLoaded: boolean;
	parentCollection: Collection;
	parentLabel: string;
	constructor(jsonld?: any, options?: IManifestoOptions);
	getAttribution(): LanguageMap;
	getDescription(): LanguageMap;
	getIIIFResourceType(): IIIFResourceType;
	getLogo(): string | null;
	getLicense(): string | null;
	getNavDate(): Date;
	getRelated(): any;
	getSeeAlso(): any;
	getTrackingLabel(): string;
	getDefaultTree(): TreeNode;
	getRequiredStatement(): LabelValuePair | null;
	isCollection(): boolean;
	isManifest(): boolean;
	load(): Promise<IIIFResource>;
}
export declare class Annotation extends ManifestResource {
	constructor(jsonld: any, options: IManifestoOptions);
	getBody(): AnnotationBody[];
	getMotivation(): AnnotationMotivation | null;
	getOn(): string;
	getTarget(): string | null;
	getResource(): Resource;
}
export declare class AnnotationBody extends ManifestResource {
	constructor(jsonld?: any, options?: IManifestoOptions);
	getFormat(): MediaType | null;
	getType(): ExternalResourceType | null;
	getWidth(): number;
	getHeight(): number;
}
export declare class AnnotationList extends JSONLDResource {
	options: IManifestoOptions;
	label: string;
	isLoaded: boolean;
	constructor(label: any, jsonld?: any, options?: IManifestoOptions);
	getIIIFResourceType(): IIIFResourceType;
	getLabel(): string;
	getResources(): Annotation[];
	load(): Promise<AnnotationList>;
}
export declare class AnnotationPage extends ManifestResource {
	constructor(jsonld: any, options: IManifestoOptions);
	getItems(): Annotation[];
}
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
export declare class Collection extends IIIFResource {
	items: IIIFResource[];
	private _collections;
	private _manifests;
	constructor(jsonld: any, options: IManifestoOptions);
	getCollections(): Collection[];
	getManifests(): Manifest[];
	getCollectionByIndex(collectionIndex: number): Promise<Collection>;
	getManifestByIndex(manifestIndex: number): Promise<Manifest>;
	getTotalCollections(): number;
	getTotalManifests(): number;
	getTotalItems(): number;
	getViewingDirection(): ViewingDirection;
	/**
	 * Get a tree of sub collections and manifests, using each child manifest's first 'top' range.
	 */
	getDefaultTree(): TreeNode;
	private _parseManifests;
	private _parseCollections;
}
export declare class Duration {
	start: number;
	end: number;
	constructor(start: number, end: number);
	getLength(): number;
}
export interface IAccessToken {
	accessToken: string;
	error: string;
	errorDescription: string;
	expiresIn: number;
	tokenType: string;
}
export interface IExternalImageResourceData extends IExternalResourceData {
	width: number;
	height: number;
}
export interface IExternalResource {
	authAPIVersion: number;
	authHoldingPage: any;
	clickThroughService: Service | null;
	data: IExternalResourceData;
	dataUri: string | null;
	error: any;
	externalService: Service | null;
	getData(accessToken?: IAccessToken): Promise<IExternalResource>;
	hasServiceDescriptor(): boolean;
	height: number;
	index: number;
	isAccessControlled(): boolean;
	isResponseHandled: boolean;
	kioskService: Service | null;
	loginService: Service | null;
	logoutService: Service | null;
	options?: IManifestoOptions;
	restrictedService: Service | null;
	status: number;
	tokenService: Service | null;
	width: number;
}
export interface IExternalResourceData {
	hasServiceDescriptor: boolean;
	id: string;
	index: number;
	profile: string | any[];
}
export interface IExternalResourceOptions {
	authApiVersion: number;
}
export interface IManifestoOptions {
	defaultLabel: string;
	index?: number;
	locale: string;
	navDate?: Date;
	pessimisticAccessControl: boolean;
	resource: IIIFResource;
}
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
export declare class Language {
	value: string;
	locale: string;
	constructor(value: string | string[], locale: string);
}
export declare class LanguageMap extends Array<Language> {
	static parse(language: any, defaultLocale: string): LanguageMap;
	static getValue(languageCollection: LanguageMap, locale?: string): string | null;
	static getValues(languageCollection: LanguageMap, locale?: string): Array<string | null>;
}
export declare class Manifest extends IIIFResource {
	index: number;
	private _allRanges;
	items: Sequence[];
	private _topRanges;
	constructor(jsonld?: any, options?: IManifestoOptions);
	getPosterCanvas(): Canvas | null;
	getBehavior(): Behavior | null;
	getDefaultTree(): TreeNode;
	private _getTopRanges;
	getTopRanges(): Range[];
	private _getRangeById;
	private _parseRanges;
	getAllRanges(): Range[];
	getRangeById(id: string): Range | null;
	getRangeByPath(path: string): Range | null;
	getSequences(): Sequence[];
	getSequenceByIndex(sequenceIndex: number): Sequence;
	getTotalSequences(): number;
	getManifestType(): ManifestType;
	isMultiSequence(): boolean;
	isPagingEnabled(): boolean;
	getViewingDirection(): ViewingDirection | null;
	getViewingHint(): ViewingHint | null;
}
export declare enum ManifestType {
	EMPTY = "",
	MANUSCRIPT = "manuscript",
	MONOGRAPH = "monograph"
}
export declare class Range extends ManifestResource {
	private _ranges;
	canvases: string[] | null;
	items: ManifestResource[];
	parentRange: Range | undefined;
	path: string;
	treeNode: TreeNode;
	constructor(jsonld?: any, options?: IManifestoOptions);
	getCanvasIds(): string[];
	getDuration(): Duration | undefined;
	getRanges(): Range[];
	getBehavior(): Behavior | null;
	getViewingDirection(): ViewingDirection | null;
	getViewingHint(): ViewingHint | null;
	getTree(treeRoot: TreeNode): TreeNode;
	spansTime(time: number): boolean;
	private _parseTreeNode;
}
export declare class Rendering extends ManifestResource {
	constructor(jsonld?: any, options?: IManifestoOptions);
	getFormat(): RenderingFormat;
}
export declare class Sequence extends ManifestResource {
	items: Canvas[];
	private _thumbnails;
	constructor(jsonld?: any, options?: IManifestoOptions);
	getCanvases(): Canvas[];
	getCanvasById(id: string): Canvas | null;
	getCanvasByIndex(canvasIndex: number): any;
	getCanvasIndexById(id: string): number | null;
	getCanvasIndexByLabel(label: string, foliated?: boolean): number;
	getLastCanvasLabel(alphanumeric?: boolean): string;
	getLastPageIndex(): number;
	getNextPageIndex(canvasIndex: number, pagingEnabled?: boolean): number;
	getPagedIndices(canvasIndex: number, pagingEnabled?: boolean): number[];
	getPrevPageIndex(canvasIndex: number, pagingEnabled?: boolean): number;
	getStartCanvasIndex(): number;
	getThumbs(width: number, height?: number): Thumb[];
	getThumbnails(): Thumbnail[];
	getStartCanvas(): string;
	getTotalCanvases(): number;
	getViewingDirection(): ViewingDirection | null;
	getViewingHint(): ViewingHint | null;
	isCanvasIndexOutOfRange(canvasIndex: number): boolean;
	isFirstCanvas(canvasIndex: number): boolean;
	isLastCanvas(canvasIndex: number): boolean;
	isMultiCanvas(): boolean;
	isPagingEnabled(): boolean;
	isTotalCanvasesEven(): boolean;
}
export declare class Deserialiser {
	static parse(manifest: any, options?: IManifestoOptions): IIIFResource | null;
	static parseJson(json: any, options?: IManifestoOptions): IIIFResource | null;
	static parseCollection(json: any, options?: IManifestoOptions): Collection;
	static parseCollections(collection: Collection, options?: IManifestoOptions): void;
	static parseManifest(json: any, options?: IManifestoOptions): Manifest;
	static parseManifests(collection: Collection, options?: IManifestoOptions): void;
	static parseItem(json: any, options?: IManifestoOptions): IIIFResource | null;
	static parseItems(collection: Collection, options?: IManifestoOptions): void;
}
export declare class Service extends ManifestResource {
	constructor(jsonld?: any, options?: IManifestoOptions);
	getProfile(): ServiceProfile;
	getConfirmLabel(): string | null;
	getDescription(): string | null;
	getFailureDescription(): string | null;
	getFailureHeader(): string | null;
	getHeader(): string | null;
	getServiceLabel(): string | null;
	getInfoUri(): string;
}
export declare class Size {
	width: number;
	height: number;
	constructor(width: number, height: number);
}
export declare enum StatusCode {
	AUTHORIZATION_FAILED = 1,
	FORBIDDEN = 2,
	INTERNAL_SERVER_ERROR = 3,
	RESTRICTED = 4
}
export declare class Thumb {
	data: any;
	index: number;
	uri: string;
	label: string;
	width: number;
	height: number;
	visible: boolean;
	constructor(width: number, canvas: Canvas);
}
export declare class Thumbnail extends Resource {
	constructor(jsonld: any, options: IManifestoOptions);
}
export declare class TreeNode {
	data: any;
	nodes: TreeNode[];
	selected: boolean;
	expanded: boolean;
	id: string;
	label: string;
	navDate: Date;
	parentNode: TreeNode;
	constructor(label?: string, data?: any);
	addNode(node: TreeNode): void;
	isCollection(): boolean;
	isManifest(): boolean;
	isRange(): boolean;
}
export declare enum TreeNodeType {
	COLLECTION = "collection",
	MANIFEST = "manifest",
	RANGE = "range"
}
export declare class Utils {
	static getMediaType(type: string): MediaType;
	static getImageQuality(profile: ServiceProfile): string;
	static getInexactLocale(locale: string): string;
	static getLocalisedValue(resource: any, locale: string): string | null;
	static generateTreeNodeIds(treeNode: TreeNode, index?: number): void;
	static normaliseType(type: string): string;
	static normaliseUrl(url: string): string;
	static normalisedUrlsMatch(url1: string, url2: string): boolean;
	static isImageProfile(profile: ServiceProfile): boolean;
	static isLevel0ImageProfile(profile: ServiceProfile): boolean;
	static isLevel1ImageProfile(profile: ServiceProfile): boolean;
	static isLevel2ImageProfile(profile: ServiceProfile): boolean;
	static parseManifest(manifest: any, options?: IManifestoOptions | undefined): IIIFResource | null;
	static checkStatus(response: any): any;
	static loadManifest(url: string): Promise<any>;
	static loadExternalResourcesAuth1(resources: IExternalResource[], openContentProviderInteraction: (service: Service) => any, openTokenService: (resource: IExternalResource, tokenService: Service) => Promise<any>, getStoredAccessToken: (resource: IExternalResource) => Promise<IAccessToken | null>, userInteractedWithContentProvider: (contentProviderInteraction: any) => Promise<any>, getContentProviderInteraction: (resource: IExternalResource, service: Service) => Promise<any>, handleMovedTemporarily: (resource: IExternalResource) => Promise<any>, showOutOfOptionsMessages: (resource: IExternalResource, service: Service) => void): Promise<IExternalResource[]>;
	static loadExternalResourceAuth1(resource: IExternalResource, openContentProviderInteraction: (service: Service) => any, openTokenService: (resource: IExternalResource, tokenService: Service) => Promise<void>, getStoredAccessToken: (resource: IExternalResource) => Promise<IAccessToken | null>, userInteractedWithContentProvider: (contentProviderInteraction: any) => Promise<any>, getContentProviderInteraction: (resource: IExternalResource, service: Service) => Promise<any>, handleMovedTemporarily: (resource: IExternalResource) => Promise<any>, showOutOfOptionsMessages: (resource: IExternalResource, service: Service) => void): Promise<IExternalResource>;
	static doAuthChain(resource: IExternalResource, openContentProviderInteraction: (service: Service) => any, openTokenService: (resource: IExternalResource, tokenService: Service) => Promise<any>, userInteractedWithContentProvider: (contentProviderInteraction: any) => Promise<any>, getContentProviderInteraction: (resource: IExternalResource, service: Service) => Promise<any>, handleMovedTemporarily: (resource: IExternalResource) => Promise<any>, showOutOfOptionsMessages: (resource: IExternalResource, service: Service) => void): Promise<IExternalResource | void>;
	static attemptResourceWithToken(resource: IExternalResource, openTokenService: (resource: IExternalResource, tokenService: Service) => Promise<any>, authService: Service): Promise<IExternalResource | void>;
	static loadExternalResourcesAuth09(resources: IExternalResource[], tokenStorageStrategy: string, clickThrough: (resource: IExternalResource) => Promise<any>, restricted: (resource: IExternalResource) => Promise<any>, login: (resource: IExternalResource) => Promise<any>, getAccessToken: (resource: IExternalResource, rejectOnError: boolean) => Promise<IAccessToken>, storeAccessToken: (resource: IExternalResource, token: IAccessToken, tokenStorageStrategy: string) => Promise<any>, getStoredAccessToken: (resource: IExternalResource, tokenStorageStrategy: string) => Promise<IAccessToken>, handleResourceResponse: (resource: IExternalResource) => Promise<any>, options?: IManifestoOptions): Promise<IExternalResource[]>;
	static loadExternalResourceAuth09(resource: IExternalResource, tokenStorageStrategy: string, clickThrough: (resource: IExternalResource) => Promise<any>, restricted: (resource: IExternalResource) => Promise<any>, login: (resource: IExternalResource) => Promise<any>, getAccessToken: (resource: IExternalResource, rejectOnError: boolean) => Promise<IAccessToken>, storeAccessToken: (resource: IExternalResource, token: IAccessToken, tokenStorageStrategy: string) => Promise<any>, getStoredAccessToken: (resource: IExternalResource, tokenStorageStrategy: string) => Promise<IAccessToken>, handleResourceResponse: (resource: IExternalResource) => Promise<any>, options?: IManifestoOptions): Promise<IExternalResource>;
	static createError(name: StatusCode, message: string): Error;
	static createAuthorizationFailedError(): Error;
	static createRestrictedError(): Error;
	static createInternalServerError(message: string): Error;
	static authorize(resource: IExternalResource, tokenStorageStrategy: string, clickThrough: (resource: IExternalResource) => Promise<any>, restricted: (resource: IExternalResource) => Promise<any>, login: (resource: IExternalResource) => Promise<any>, getAccessToken: (resource: IExternalResource, rejectOnError: boolean) => Promise<IAccessToken>, storeAccessToken: (resource: IExternalResource, token: IAccessToken, tokenStorageStrategy: string) => Promise<any>, getStoredAccessToken: (resource: IExternalResource, tokenStorageStrategy: string) => Promise<IAccessToken>): Promise<IExternalResource>;
	private static showAuthInteraction;
	static getService(resource: any, profile: ServiceProfile): Service | null;
	static getResourceById(parentResource: JSONLDResource, id: string): JSONLDResource;
	/**
	 * Does a depth first traversal of an Object, returning an Object that
	 * matches provided k and v arguments
	 * @example Utils.traverseAndFind({foo: 'bar'}, 'foo', 'bar')
	 */
	static traverseAndFind(object: any, k: string, v: string): object | undefined;
	static getServices(resource: any): Service[];
	static getTemporalComponent(target: string): number[] | null;
}
export declare const loadManifest: (url: string) => Promise<string>;
export declare const parseManifest: (manifest: any, options?: IManifestoOptions | undefined) => IIIFResource | null;

export as namespace manifesto;
