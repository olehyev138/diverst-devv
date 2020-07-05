/**
 *
 * Tests for ErrorBoundary
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import ErrorBoundary from '../index';

describe('<ErrorBoundary />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<ErrorBoundary classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
