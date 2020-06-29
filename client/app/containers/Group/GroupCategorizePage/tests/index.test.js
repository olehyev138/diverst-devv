/**
 *
 * Tests for GroupCategorizePage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { GroupCategorizePage } from '../index';
import 'utils/mockReactRouterHooks';

describe('<GroupCategorizePage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<GroupCategorizePage classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
