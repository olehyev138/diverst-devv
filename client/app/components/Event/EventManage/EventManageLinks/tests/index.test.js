/**
 *
 * Tests for EventManageLinks
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import 'utils/mockReactRouterHooks';
import { EventManageLinks } from '../index';

const props = {
  event: { owner_group_id: 1 }
};

describe('<EventManageLinks />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<EventManageLinks {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
