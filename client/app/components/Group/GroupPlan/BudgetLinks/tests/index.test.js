/**
 *
 * Tests for BudgetLinks
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { BudgetLinks } from '../index';

const props = {
  currentGroup: {}
};
describe('<BudgetLinks />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<BudgetLinks classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
