/**
 *
 * Tests for ThemeProvider
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { render } from 'react-testing-library';
// import 'jest-dom/extend-expect'; // add some helpful assertions

// import { ThemeProvider } from '../index';

xdescribe('<ThemeProvider />', () => {
  xit('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const dispatch = jest.fn();
    // render(<ThemeProvider dispatch={dispatch} />);

    // expect(spy).not.toHaveBeenCalled();
  });

  xit('Expect to have additional unit tests specified', () => {
    expect(true).toEqual(false);
  });
});
