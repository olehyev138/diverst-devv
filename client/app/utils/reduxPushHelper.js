import { push } from 'connected-react-router';

export const redirectAction = url => push(url);

export const createRedirectAction = url => (...args) => push(url(...args));
