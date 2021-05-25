import { NativeModules } from 'react-native';
var Errors;

(function (Errors) {
  Errors["APP_NOT_INSTALL"] = "app_not_install";
  Errors["URL_NOT_VALID"] = "url_not_valid";
  Errors["DATA_NOT_VALID"] = "data_not_valid";
  Errors["PERMISSIONS_NOT_RECIVED"] = "permissions_not_recived";
})(Errors || (Errors = {}));

const {
  InstaShare
} = NativeModules;
export default InstaShare;
export { Errors };
//# sourceMappingURL=index.js.map