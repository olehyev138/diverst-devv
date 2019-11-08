// Basic interface for storing local user data
const UserStorage = {
  // Returns the stored value or null if a value doesn't exist for the key provided
  getStorageValue(key) {
    const value = window.localStorage.getItem(key);

    if (value)
      return JSON.parse(value);

    return null;
  },

  // Stores or updates the value for the key provided
  setStorageValue(key, value) {
    window.localStorage.setItem(key, JSON.stringify(value));
  },

  // Removes the stored value for the key provided
  clearStorageValue(key) {
    window.localStorage.removeItem(key);
  }
};

export default UserStorage;
