import { NativeModules } from 'react-native';

type InstaShareType = {
  multiply(a: number, b: number): Promise<number>;
};

const { InstaShare } = NativeModules;

export default InstaShare as InstaShareType;
