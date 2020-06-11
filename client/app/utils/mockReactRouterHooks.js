// This file is intended to be used for when a component uses react-router hooks that require the router context,
// such as `useLocation`, but you're using `shallow` to test since you only care about how the component itself renders,
// this will stop those errors from happening while still allowing you to use `shallow` and have the snapshot work properly.
//
// Important: Must be imported before the component being tested is imported.

jest.mock('react-router-dom', () => ({
  ...jest.requireActual('react-router-dom'),
  useLocation: () => ({
    pathname: '/',
    key: 'testKey',
  })
}));
