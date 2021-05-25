import { NativeModules } from 'react-native';

type InstaShareType = {
  share(uri: string): Promise<number>;
};

const { InstaShare } = NativeModules;

export default InstaShare as InstaShareType;
