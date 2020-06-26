/**
 *
 * Tests for NewsLinkForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { NewsLinkForm } from '../index';

describe('<NewsLinkForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<NewsLinkForm classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
