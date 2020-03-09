import { createBrowserHistory } from 'history';
const history = createBrowserHistory();

/* eslint-disable-next-line no-restricted-globals */
const path = (/#!(\/.*)$/.exec(location.hash) || [])[1];
if (path) history.replace(path);

export default history;
