import { NativeModules } from 'react-native';

type InstaShareType = {
  share(type: string, mediaPath: string): Promise<number>;
};

const { InstaShare } = NativeModules;

export default InstaShare as InstaShareType;
