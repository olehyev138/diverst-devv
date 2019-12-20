import produce from 'immer';
import emailReducer from 'containers/GlobalSettings/Email/Email/reducer';
import {
  getEmailBegin, getEmailSuccess, getEmailError,
  getEmailsBegin, getEmailsError, getEmailsSuccess,
  updateEmailBegin, updateEmailError, updateEmailSuccess,
  emailsUnmount,
} from 'containers/GlobalSettings/Email/Email/actions';

describe('emailReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      emailList: [],
      emailListTotal: null,
      currentEmail: null,
      isFetchingEmails: false,
      isFetchingEmail: false,
      isCommitting: false,
      hasChanged: false,
    };
  });

  it('handles the getEmailBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isFetchingEmail = true;
    });

    expect(
      emailReducer(
        state,
        getEmailBegin({})
      )
    ).toEqual(expected);
  });

  it('handles the getEmailSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.currentEmail = { id: 30, name: 'dummy30' };
      draft.isFetchingEmail = false;
    });

    expect(
      emailReducer(
        state,
        getEmailSuccess({ email: { id: 30, name: 'dummy30' } })
      )
    ).toEqual(expected);
  });

  it('handles the getEmailError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isFetchingEmail = false;
    });

    expect(
      emailReducer(
        state,
        getEmailError({})
      )
    ).toEqual(expected);
  });

  it('handles the getEmailsBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isFetchingEmails = true;
      draft.hasChanged = false;
    });

    expect(
      emailReducer(
        state,
        getEmailsBegin({})
      )
    ).toEqual(expected);
  });

  it('handles the getEmailsError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isFetchingEmails = false;
    });

    expect(
      emailReducer(
        state,
        getEmailsError({})
      )
    ).toEqual(expected);
  });

  it('handles the getEmailsSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.emailList = [{ id: 37, name: 'dummy' }];
      draft.emailListTotal = 49;
      draft.isFetchingEmails = false;
    });

    expect(
      emailReducer(
        state,
        getEmailsSuccess({
          items: [{ id: 37, name: 'dummy' }],
          total: 49,
        })
      )
    ).toEqual(expected);
  });

  it('handles the updateEmailBegin action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = true;
      draft.hasChanged = false;
    });

    expect(
      emailReducer(
        state,
        updateEmailBegin({})
      )
    ).toEqual(expected);
  });

  it('handles the updateEmailSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = false;
      draft.hasChanged = true;
    });

    expect(
      emailReducer(
        state,
        updateEmailSuccess({})
      )
    ).toEqual(expected);
  });

  it('handles the updateEmailError action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.isCommitting = false;
    });

    expect(
      emailReducer(
        state,
        updateEmailError({})
      )
    ).toEqual(expected);
  });

  it('handles the emailsUnmount action correctly', () => {
    const expected = {
      emailList: [],
      emailListTotal: null,
      currentEmail: null,
      isFetchingEmails: false,
      isFetchingEmail: false,
      isCommitting: false,
      hasChanged: false,
    };

    expect(
      emailReducer(
        state,
        emailsUnmount({})
      )
    ).toEqual(expected);
  });
});
