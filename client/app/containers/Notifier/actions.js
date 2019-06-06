import { SHOW_SNACKBAR, CLOSE_SNACKBAR, REMOVE_SNACKBAR } from './constants';

export function showSnackbar(notification) {
  const key = notification.options && notification.options.key;

  return {
    type: SHOW_SNACKBAR,
    notification: {
      ...notification,
      key: key || new Date().getTime() + Math.random(),
    },
  };
}

export function closeSnackbar(key) {
  return {
    type: CLOSE_SNACKBAR,
    dismissAll: !key, // dismiss all if no key has been defined
    key,
  }
}

export function removeSnackbar(key) {
  return {
    type: REMOVE_SNACKBAR,
    key,
  }
}
