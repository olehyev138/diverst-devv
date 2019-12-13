import {
  selectEmailDomain,
  selectPaginatedEmails,
  selectEmailsTotal,
  selectEmail,
  selectIsFetchingEmails,
  selectIsFetchingEmail,
  selectIsCommitting,
  selectHasChanged,
} from '../selectors';

describe('Email selectors', () => {
  describe('selectEmailDomain', () => {
    it('should select the email domain', () => {
      const mockedState = { emails: { email: {} } };
      const selected = selectEmailDomain(mockedState);

      expect(selected).toEqual({ email: {} });
    });
  });

  describe('selectPaginatedEmails', () => {
    it('should select the paginated emails', () => {
      const mockedState = { emailList: { id: 742, __dummy: '742' } };
      const selected = selectPaginatedEmails().resultFunc(mockedState);

      expect(selected).toEqual({ id: 742, __dummy: '742' });
    });
  });

  describe('selectEmailsTotal', () => {
    it('should select the emails total', () => {
      const mockedState = { emailListTotal: 507 };
      const selected = selectEmailsTotal().resultFunc(mockedState);

      expect(selected).toEqual(507);
    });
  });

  describe('selectEmail', () => {
    it('should select the email', () => {
      const mockedState = { currentEmail: { id: 370, __dummy: '370' } };
      const selected = selectEmail().resultFunc(mockedState);

      expect(selected).toEqual({ id: 370, __dummy: '370' });
    });
  });

  describe('selectIsFetchingEmails', () => {
    it('should select the \'is fetching emails\' flag', () => {
      const mockedState = { isFetchingEmails: true };
      const selected = selectIsFetchingEmails().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectIsFetchingEmail', () => {
    it('should select the \'is fetching email\' flag', () => {
      const mockedState = { isFetchingEmail: true };
      const selected = selectIsFetchingEmail().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectIsCommitting', () => {
    it('should select the \'is committing\' flag', () => {
      const mockedState = { isCommitting: true };
      const selected = selectIsCommitting().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectHasChanged', () => {
    it('should select the \'has changed\' flag', () => {
      const mockedState = { hasChanged: false };
      const selected = selectHasChanged().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });
});
