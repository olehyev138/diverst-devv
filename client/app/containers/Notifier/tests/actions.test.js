import { SHOW_SNACKBAR, CLOSE_SNACKBAR, REMOVE_SNACKBAR } from '../constants';
import { showSnackbar, closeSnackbar, removeSnackbar } from '../actions';

describe('Notifier actions', () => {
  describe('showSnackbar()', () => {
    it('should have a type of SHOW_SNACKBAR & set a passed notification object with a key', () => {
      const notification = { options: { key: 3391900133 } };
      const expected = {
        type: SHOW_SNACKBAR,
        notification: {
          ...notification,
          key: notification.options.key
        }
      };

      expect(showSnackbar(notification)).toEqual(expected);
    });

    it('should create a key when notification options is undefined', () => {
      const notification = {};

      expect(showSnackbar(notification).notification).toHaveProperty('key');
    });
  });

  describe('closeSnackbar', () => {
    it('should have a type of CLOSE_SNACKBAR & set correct properties', () => {
      const key = 339955003;
      const expected = {
        type: CLOSE_SNACKBAR,
        dismissAll: false,
        key
      };

      expect(closeSnackbar(key)).toEqual(expected);
    });

    it('should set dismissALl to true if key is undefined', () => {
      expect(closeSnackbar(undefined).dismissAll).toEqual(true);
    });
  });

  describe('removeSnackbar', () => {
    it('should have a type of REMOVE_SNACKBAR & set passed key', () => {
      const key = 339955003;
      const expected = {
        type: REMOVE_SNACKBAR,
        key
      };

      expect(removeSnackbar(key)).toEqual(expected);
    });
  });
});
