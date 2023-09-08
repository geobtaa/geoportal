var Language = /** @class */ (function () {
    function Language(value, locale) {
        if (Array.isArray(value)) {
            if (value.length === 1) {
                this.value = value[0];
            }
            else {
                // concatenate all of the values
                this.value = value.join("<br/>");
            }
        }
        else {
            this.value = value;
        }
        this.locale = locale;
    }
    return Language;
}());
export { Language };
//# sourceMappingURL=Language.js.map