/**
 *
 * Tests for UserDownloadsPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { UserDownloadsPage } from '../index';

jest.mock('utils/routeHelpers');
const RouteService = require.requireMock('utils/routeHelpers');
const props = {
  getUserDownloadDataBegin: jest.fn(),
  getUserDownloadsBegin: jest.fn(),
  userUnmount: jest.fn(),
};

describe('<UserDownloadsPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<UserDownloadsPage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
