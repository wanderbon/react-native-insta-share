declare enum Errors {
    APP_NOT_INSTALL = "app_not_install",
    URL_NOT_VALID = "url_not_valid",
    DATA_NOT_VALID = "data_not_valid",
    PERMISSIONS_NOT_RECIVED = "permissions_not_recived"
}
declare type InstaShareType = {
    share(uri: string): Promise<number>;
};
declare const _default: InstaShareType;
export default _default;
export { Errors };
