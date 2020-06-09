/**
 *
 * Tests for Metrics
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { Metrics } from '../index';
import { intl } from 'tests/mocks/react-intl';

describe('<Metrics />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<Metrics />);

    expect(spy).not.toHaveBeenCalled();
  });
});
