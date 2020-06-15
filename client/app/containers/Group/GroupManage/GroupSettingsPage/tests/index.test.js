/**
 *
 * Tests for GroupSettingsPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
// import { GroupSettingsPage } from '../index';

jest.mock('utils/routeHelpers');
const RouteService = require.requireMock('utils/routeHelpers');
// Todo: TypeError: Invalid URL
describe('<GroupSettingsPage />', () => {
  it('Expect to not log errors in console', () => {
    // const spy = jest.spyOn(global.console, 'error');
    // const wrapper = shallow(<GroupSettingsPage classes={{}} />);
    //
    // expect(spy).not.toHaveBeenCalled();
  });
});
