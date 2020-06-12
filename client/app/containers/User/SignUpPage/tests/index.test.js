/**
 *
 * Tests for SignUpPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { SignUpPage } from '../index';

jest.mock('utils/routeHelpers');
const RouteService = require.requireMock('utils/routeHelpers');

describe('<SignUpPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<SignUpPage classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
