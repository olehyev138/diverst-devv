/**
 *
 * Tests for SocialLinkForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { SocialLinkForm } from '../index';

describe('<SocialLinkForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<SocialLinkForm classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
