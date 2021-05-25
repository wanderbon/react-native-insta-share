"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.Errors = exports.default = void 0;

var _reactNative = require("react-native");

var Errors;
exports.Errors = Errors;

(function (Errors) {
  Errors["APP_NOT_INSTALL"] = "app_not_install";
  Errors["URL_NOT_VALID"] = "url_not_valid";
  Errors["DATA_NOT_VALID"] = "data_not_valid";
  Errors["PERMISSIONS_NOT_RECIVED"] = "permissions_not_recived";
})(Errors || (exports.Errors = Errors = {}));

const {
  InstaShare
} = _reactNative.NativeModules;
var _default = InstaShare;
exports.default = _default;
//# sourceMappingURL=index.js.map