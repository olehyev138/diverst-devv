import UserStorage from './userStorage';

export default class LocaleService {
  constructor() { throw Error('Do not make instances of LocaleService - Use the static methods instead'); }

  // Get Locale from the store or from the user storage
  static getLocale() {
    return UserStorage.getStorageValue('locale');
  }

  // Store Locale in user storage
  static storeLocale(locale) {
    UserStorage.setStorageValue('locale', locale);
  }

  // Remove Locale from user storage
  static discardLocale() {
    UserStorage.clearStorageValue('locale');
  }
}
