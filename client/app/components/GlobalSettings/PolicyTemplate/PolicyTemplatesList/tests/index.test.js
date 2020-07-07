/**
 *
 * Tests for TemplatesList
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { TemplatesList } from '../index';

describe('<EmailLinks />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<TemplatesList classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
