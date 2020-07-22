import {
  selectGlobal, selectRouter, selectLocation,
  selectEnterprise, selectToken, selectUser,
  selectAdminDrawerOpen
} from 'containers/Shared/App/selectors';

describe('App selectors', () => {
  describe('selectGlobal', () => {
    it('should select the global state domain', () => {
      const mockedState = { global: { global: 'global' } };
      const selected = selectGlobal(mockedState);

      expect(selected).toEqual({ global: 'global' });
    });
  });

  describe('selectRouter', () => {
    it('should select the router state domain', () => {
      const mockedState = { router: { router: 'router' } };
      const selected = selectRouter(mockedState);

      expect(selected).toEqual({ router: 'router' });
    });
  });

  describe('selectLocation', () => {
    it('should select the location', () => {
      const mockedState = { location: { pathname: '/foo' } };
      const selected = selectLocation().resultFunc(mockedState);

      expect(selected).toEqual({ pathname: '/foo' });
    });
  });

  describe('selectEnterprise', () => {
    it('should select the enterprise', () => {
      const mockedState = { global: { data: { enterprise: 'enterprise' } } };
      const selected = selectEnterprise().resultFunc(mockedState.global);

      expect(selected).toEqual('enterprise');
    });
  });

  describe('selectToken', () => {
    it('should select the token', () => {
      const mockedState = { global: { token: 'token' } };
      const selected = selectToken().resultFunc(mockedState.global);

      expect(selected).toEqual('token');
    });
  });

  describe('selectUser', () => {
    it('should select the user', () => {
      const mockedState = { global: { data: 'user' } };
      const selected = selectUser().resultFunc(mockedState.global);

      expect(selected).toEqual('user');
    });
  });

  describe('selectAdminDrawerOpen', () => {
    it('should select the admin drawer open boolean', () => {
      const mockedState = { global: { adminDrawerOpen: false } };
      const selected = selectAdminDrawerOpen().resultFunc(mockedState.global);

      expect(selected).toEqual(false);
    });
  });
});
