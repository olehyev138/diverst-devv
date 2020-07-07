/**
 *
 * Tests for SubgroupJoinForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { SubgroupJoinForm } from '../index';

describe('<SubgroupJoinForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<SubgroupJoinForm classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
