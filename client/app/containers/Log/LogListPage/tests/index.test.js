/**
 *
 * Tests for LogListPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { LogListPage } from '../index';

const props = {
  getLogsBegin: jest.fn(),
  logUnmount: jest.fn()
};
describe('<LogListPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<LogListPage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
