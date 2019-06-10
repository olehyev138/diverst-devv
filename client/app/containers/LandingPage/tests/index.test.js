/**
 *
 * Tests for LandingPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { render } from 'react-testing-library';
import { BrowserRouter } from 'react-router-dom';

import { LandingPage } from '../index';

xdescribe('<LandingPage />', () => {
  xit('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const dispatch = jest.fn();

    render(
      <BrowserRouter>
        <LandingPage dispatch={dispatch} />
      </BrowserRouter>
    );

    expect(spy).not.toHaveBeenCalled();
  });
});
