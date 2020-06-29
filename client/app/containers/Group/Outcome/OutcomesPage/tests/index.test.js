/**
 *
 * Tests for OutcomesPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { OutcomesPage } from '../index';
import 'utils/mockReactRouterHooks';

const props = {
  getOutcomesBegin: jest.fn(),
  deleteOutcomeBegin: jest.fn(),
  outcomesUnmount: jest.fn()
};
describe('<OutcomesPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<OutcomesPage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
