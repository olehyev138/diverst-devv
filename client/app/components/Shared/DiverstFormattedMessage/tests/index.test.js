/**
 *
 * Tests for DiverstFormattedMessage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
// import { DiverstFormattedMessage } from '../index';
const { DiverstFormattedMessage } = require.requireMock('../index.js');

describe('<DiverstFormattedMessage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<DiverstFormattedMessage classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
