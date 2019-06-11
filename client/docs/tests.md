### Resources

- https://redux.js.org/recipes/writing-tests
- https://github.com/react-boilerplate/react-boilerplate/blob/master/app/containers/App/tests/reducer.test.js

### Libraries

For the overall test framework we use [Jest](https://jestjs.io/).

Additionally, we use [Enzyme](https://github.com/airbnb/enzyme) to provide additional react testing utilities.

### General

- The entire frontend test suite can be run with `npm test`. To run a specific file run `node_modules/.bin/jest <file_name>`

- Tests for a component `x` should be stored alongside the component in a directory `test`. 

- Test files should always be appended with the `.test.js` extension.

### Selectors

When testing selectors we want to test both the plain functions, as well as the selectors built with _reselect_.

For testing plain functions, simply build a mocked state, pass it to the selector and then test that it selected & returned the correct data.

This selector is simply supposed to take a given state, and return `state.global`

```javascript
  describe('selectGlobal', () => {
    it('should select the global state domain', () => {
      const mockedState = { global: { global: 'global' } };
      const selected = selectGlobal(mockedState);

      expect(selected).toEqual({ global: 'global' });
    });
  });
```

For testing selectors built with reselect, the idea is the same. Because we are unit testing, we do not need to test the intermediary functions, only that the final result. The object returned by `createSelector` provides a `resultFunc` function that we can pass the final state too. We pass our mocked final state and test that the selector has selected and returned the correct data


```javascript
  describe('selectLocation', () => {
    it('should select the location', () => {
      const mockedState = { location: { pathname: '/foo' } };
      const selected = selectLocation().resultFunc(mockedState);

      expect(selected).toEqual({ pathname: '/foo' });
    });
  });
```

### Actions

Testing actions is straight forward. Import all the constants used. Then for each action, simply manually build the expected result, then call the action and test that the results are the same.

```javascript
    it('it has a type of LOGIN_BEGIN and sets a given payload', () => {
      const expected = {
        type: LOGIN_BEGIN,
        payload: { payload: 'payload' }
      };

      expect(loginBegin({ payload: 'payload' })).toEqual(expected);
    });
```

### Reducers

Testing reducers is also very straight forward. 

- At the top of the describe, setup a beforeEach hook that sets a global variable called `state` to the initial state as defined in your reducer. 

```javascript

describe('appReducer', () => {
  let state;

  beforeEach(() => {
    state = {
      user: null,
      enterprise: null,
      token: null,
    };
  });
  ...
});
```

- Ensure that the reducer returns the initial state, given no state & no action

```javascript
  it('returns the initial state', () => {
    const expected = state;
    expect(appReducer(undefined, {})).toEqual(expected);
  });
```

- Test that it handles each action it is supposed to. Do this by using immers `produce` function to do exactly what the reducer is supposed to do for an action `x`, then call the reducer with the initial state, the action in question and test that the results are the same.


```javascript
  it('handles the loginSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.token = 'token';
    });

    expect(appReducer(state, loginSuccess('token'))).toEqual(expected);
  });
```

### Components

- produces no console errors
- behavior
- ui is as expected
- uses proptypes

#### Connected vs unconnected

#### Snapshot testing
- Snapshot testing _is_ useful and can be applied to much more then just UI. It is important however to use it _properly_. It is most useful as a general regression test. To quickly run after changing things to see if anything has broke. It is also important to not get into a habit of _automatically_ updating the snapshot. This defeats the entire purpose of course.
