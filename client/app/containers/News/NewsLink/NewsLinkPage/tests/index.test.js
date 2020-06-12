/**
 *
 * Tests for NewsLinkPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { NewsLinkPage } from '../index';

jest.mock('utils/routeHelpers');
const RouteService = require.requireMock('utils/routeHelpers');
const props = {
  currentUser: {},
};

describe('<NewsLinkPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<NewsLinkPage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
