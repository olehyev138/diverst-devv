/**
 *
 * Tests for DiverstHTMLEmbedder
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { DiverstHTMLEmbedder } from '../index';

describe('<DiverstHTMLEmbedder />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<DiverstHTMLEmbedder classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});