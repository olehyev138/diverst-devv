/**
 *
 * Tests for GroupLinks
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
// import { GroupLinks } from '../index';
const { GroupLinks } = require.requireMock('../index.js');

describe('<GroupLinks />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<GroupLinks classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
