/**
 *
 * Tests for CustomFieldShow
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import CustomFieldShow from '../index';

describe('<CustomFieldShow />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<CustomFieldShow classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
